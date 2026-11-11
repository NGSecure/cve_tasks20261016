#!/bin/bash
# [patch-bundle] 构建期在最终镜像内执行（Dockerfile 末尾的单镜像适配层，以 root 运行）：
#   1) 快照镜像 ENV，供主服务以“原容器环境”启动（不继承调用者环境）；
#   2) 自检折叠后端的数据目录已随镜像固化；
#   3) 建立运行期目录（原镜像 USER 为非 root 时，该用户也须能写入锁、日志与 pid 文件）。
# 判定依赖（uv、pytest 等）不在镜像里预装：与原题一致，由 tests/test.sh 在联网的判定阶段在线安装，
# agent 阶段的环境因此与原题完全相同。
set -euo pipefail
PB=/opt/pb
# shellcheck source=/dev/null
. "$PB/services.sh"

# ---- 1) 主服务环境快照（剔除构建期才有的代理/证书变量；HOME 按 docker 的规则另行确定）
mu="${PB_MAIN_USER:-root}"; mu="${mu%%:*}"
home="${PB_MAIN_HOME:-}"
if [ -z "$home" ]; then   # 镜像 ENV 未显式设置 HOME：docker 取容器用户在 /etc/passwd 中的家目录，缺省 /
    home=$(awk -F: -v u="$mu" '$1==u || $3==u {print $6; exit}' /etc/passwd)
    home="${home:-/}"
fi
{
    echo "# generated at image build time: image ENV + compose environment of service 'main'"
    echo "PB_MAIN_ENV=("
    # compgen -e：bash 内建列出已导出变量（不依赖 env -0，busybox 镜像同样适用）
    while IFS= read -r k; do
        case "$k" in
            HOME|HOSTNAME|PWD|OLDPWD|SHLVL|_|BASH_ENV|http_proxy|https_proxy|HTTP_PROXY|HTTPS_PROXY|no_proxy|NO_PROXY|ftp_proxy|FTP_PROXY|all_proxy|ALL_PROXY) continue ;;
            SSL_CERT_FILE|CURL_CA_BUNDLE|GIT_SSL_CAINFO|PIP_CERT|REQUESTS_CA_BUNDLE|NODE_EXTRA_CA_CERTS|UV_*|PB_*) continue ;;
        esac
        printf '  %q\n' "$k=${!k}"
    done < <(compgen -e)
    for kv in "${PB_MAIN_COMPOSE_ENV[@]}"; do printf '  %q\n' "$kv"; done
    printf '  %q\n' "HOME=$home"
    echo ")"
} > "$PB/main-env.sh"

# ---- 2) 折叠后端自检（rootfs 里的符号链接多为绝对路径，如 alpine 的 /bin/sh -> /bin/busybox，
#         只能在 chroot 内解析，所以以“chroot 后能执行 /bin/sh”为准，不在宿主视角下测 -x）
if [ "${#PB_BACKENDS[@]}" -gt 0 ]; then
    CHROOT=$(command -v chroot || echo /usr/sbin/chroot)
    [ -x "$CHROOT" ] || { echo "[pb] chroot not found in the main image; folded backends cannot run" >&2; exit 1; }
fi

# postgres 的动态共享内存实现按运行期条件重选。构建期初始化时 /dev/shm 是 tmpfs，initdb 选了 posix；
# 运行期后端在 chroot 内，/dev/shm 只是普通目录，glibc < 2.34 的 shm_open 要求它位于 tmpfs，否则返回
# ENOSYS，postgres 启动即 FATAL（could not open shared memory segment ...: Function not implemented）。
# initdb 自己的规则是“shm_open 可用选 posix，否则选 sysv”：这里在与运行期相同的 chroot 条件下（无 /proc、
# /dev/shm 为普通目录）运行该镜像自带的 initdb 初始化一个临时目录，把它的选择写回数据目录。
# 实测 postgres:9.4/9.6/11/12.2（glibc 2.24/2.28）改为 sysv，postgres:12/13 等（glibc >= 2.36）保持 posix。
# 只改变 postgres 内部动态共享内存的实现方式，不影响任何 SQL 行为。
pg_dsm_reselect() {
    local b=$1 root=$2 pgdata=$3 initdb owner probe choice f spec made=() shm_made=0
    initdb=$(cd "$root" && ls -d usr/lib/postgresql/*/bin/initdb usr/local/bin/initdb usr/bin/initdb 2>/dev/null | head -1) || true
    owner=$(stat -c %u:%g "$pgdata")
    if [ -z "$initdb" ] || [ "${owner%%:*}" = 0 ]; then
        echo "[pb] WARN: backend $b: cannot probe POSIX shm (initdb='$initdb', owner=$owner); dynamic_shared_memory_type stays posix" >&2
        return 0
    fi
    for spec in "null 1 3" "zero 1 5" "random 1 8" "urandom 1 9"; do
        set -- $spec
        [ -e "$root/dev/$1" ] && continue
        mknod -m 666 "$root/dev/$1" c "$2" "$3" 2>/dev/null && made+=("$root/dev/$1")
    done
    # 与运行期 prepare_backend_root 准备的一致：/dev/shm 为 1777 的普通目录
    [ -d "$root/dev/shm" ] || { mkdir -p "$root/dev/shm"; shm_made=1; }
    chmod 1777 "$root/dev/shm"
    mkdir -p "$root/tmp"
    probe=$(mktemp -d "$root/tmp/pb-dsm-probe.XXXXXX")
    chown "$owner" "$probe"
    env -i PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin LANG=C LC_ALL=C \
        "$CHROOT" --userspec="$owner" "$root" "/$initdb" -N -A trust -D "${probe#"$root"}/data" > "$probe.log" 2>&1 || true
    choice=$(sed -n "s/^[[:space:]]*dynamic_shared_memory_type[[:space:]]*=[[:space:]]*'\{0,1\}\([a-z]*\).*/\1/p" \
        "$probe/data/postgresql.conf" 2>/dev/null | head -1) || true
    case "$choice" in
        posix) echo "[pb] backend $b: POSIX shm works in chroot; dynamic_shared_memory_type stays posix" ;;
        sysv)
            for f in "$pgdata/postgresql.conf" "$pgdata/postgresql.auto.conf"; do
                [ -f "$f" ] && sed -i -E "s/^([[:space:]]*dynamic_shared_memory_type[[:space:]]*=[[:space:]]*)'?posix'?/\1sysv/" "$f"
            done
            echo "[pb] backend $b: POSIX shm unavailable in chroot (old glibc); dynamic_shared_memory_type posix -> sysv (initdb's own choice)" ;;
        *)
            echo "[pb] WARN: backend $b: initdb probe failed; dynamic_shared_memory_type stays posix" >&2
            tail -5 "$probe.log" >&2 ;;
    esac
    rm -rf "$probe" "$probe.log"
    [ "${#made[@]}" -eq 0 ] || rm -f "${made[@]}"
    [ "$shm_made" = 0 ] || rmdir "$root/dev/shm" 2>/dev/null || true
}

for b in "${PB_BACKENDS[@]}"; do
    eval "root=\${PB_${b}_root}; datadir=\${PB_${b}_datadir:-}"
    "$CHROOT" "$root" /bin/sh -c : || { echo "[pb] backend $b rootfs missing or not runnable at $root" >&2; exit 1; }
    if [ -n "$datadir" ] && [ -z "$(ls -A "$root$datadir" 2>/dev/null)" ]; then
        echo "[pb] backend $b datadir $datadir is empty — build with BuildKit (DOCKER_BUILDKIT=1)" >&2
        exit 1
    fi
    if [ -n "$datadir" ] && grep -Eqs "^[[:space:]]*dynamic_shared_memory_type[[:space:]]*=[[:space:]]*'?posix" "$root$datadir/postgresql.conf"; then
        pg_dsm_reselect "$b" "$root" "$root$datadir"
    fi
done

# ---- 3) 运行期目录
install -d -m 1777 /run/pb /var/log/pb
for f in /run/pb/lock /run/pb/main.supervisor.pid /var/log/pb/ensure-services.log /var/log/pb/main.log; do
    : > "$f"; chmod 666 "$f"
done
rm -f /run/pb/autostart.done
echo "[pb] image setup done"
