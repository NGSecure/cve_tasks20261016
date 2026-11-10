#!/bin/bash
# [patch-bundle] 构建期在最终镜像内执行（Dockerfile 末尾的单镜像适配层）：
#   1) 快照镜像 ENV，供主服务以“原容器环境”启动（不继承调用者环境）；
#   2) 用与 tests/test.sh 相同的官方安装脚本预装 uv 0.7.13（同一安装位置 $HOME/.local/bin），
#      并以与 test.sh 完全相同的 `uv init` + `uv add …` 预热依赖缓存，再离线重放验证——
#      判定阶段因此无需联网，test.sh 的测试命令与判分逻辑不变；
#   3) 自检折叠后端的数据目录已随镜像固化。
set -euo pipefail
PB=/opt/pb
# shellcheck source=/dev/null
. "$PB/services.sh"

# ---- 1) 主服务环境快照（剔除构建期才有的代理/证书变量）
{
    echo "# generated at image build time: image ENV + compose environment of service 'main'"
    echo "PB_MAIN_ENV=("
    while IFS= read -r -d '' kv; do
        case "${kv%%=*}" in
            HOSTNAME|PWD|OLDPWD|SHLVL|_|BASH_ENV|http_proxy|https_proxy|HTTP_PROXY|HTTPS_PROXY|no_proxy|NO_PROXY|ftp_proxy|FTP_PROXY|all_proxy|ALL_PROXY) continue ;;
            SSL_CERT_FILE|CURL_CA_BUNDLE|GIT_SSL_CAINFO|PIP_CERT|REQUESTS_CA_BUNDLE|NODE_EXTRA_CA_CERTS|UV_*|PB_*) continue ;;
        esac
        printf '  %q\n' "$kv"
    done < <(env -0)
    for kv in "${PB_MAIN_COMPOSE_ENV[@]}"; do printf '  %q\n' "$kv"; done
    printf '  %q\n' "HOME=/root"
    echo ")"
} > "$PB/main-env.sh"

# ---- 2) 判定依赖离线化
if [ "${#PB_UV_ADD_SETS[@]}" -gt 0 ]; then
    export HOME=/root
    # 与 test.sh 完全相同的安装命令（产生同样的 ~/.local/bin/{uv,uvx,env}）；安装脚本顺带改写的
    # shell 启动文件随即还原，agent 的 shell 环境保持原样。
    rcbak=$(mktemp -d /tmp/pb-rcbak.XXXXXX)
    rcfiles=(.profile .bashrc .bash_profile .bash_login .zshrc .zshenv .config/fish/conf.d/uv.env.fish)
    for f in "${rcfiles[@]}"; do
        if [ -e "$HOME/$f" ]; then mkdir -p "$rcbak/$(dirname "$f")"; cp -a "$HOME/$f" "$rcbak/$f"; fi
    done
    curl -LsSf https://astral.sh/uv/0.7.13/install.sh | sh
    for f in "${rcfiles[@]}"; do
        if [ -e "$rcbak/$f" ]; then cp -a "$rcbak/$f" "$HOME/$f"; else rm -f "$HOME/$f"; fi
    done
    rm -rf "$rcbak"
    # shellcheck source=/dev/null
    . "$HOME/.local/bin/env"
    uv --version
    warm=$(mktemp -d /tmp/pb-warm.XXXXXX)
    for pass in online offline; do
        rm -rf "$warm/tests"; mkdir -p "$warm/tests"; cd "$warm/tests"
        uv init >/dev/null 2>&1 || true
        for deps in "${PB_UV_ADD_SETS[@]}"; do
            if [ "$pass" = offline ]; then UV_OFFLINE=1 uv add $deps; else uv add $deps; fi
        done
        UV_OFFLINE=1 uv run pytest --version
    done
    cd /
    rm -rf "$warm"
    echo "[pb] uv cache warmed for: ${PB_UV_ADD_SETS[*]}"
fi

# ---- 3) 折叠后端自检
for b in "${PB_BACKENDS[@]}"; do
    eval "root=\${PB_${b}_root}; datadir=\${PB_${b}_datadir:-}"
    [ -x "$root/bin/sh" ] || { echo "[pb] backend $b rootfs missing at $root" >&2; exit 1; }
    if [ -n "$datadir" ] && [ -z "$(ls -A "$root$datadir" 2>/dev/null)" ]; then
        echo "[pb] backend $b datadir $datadir is empty — build with BuildKit (DOCKER_BUILDKIT=1)" >&2
        exit 1
    fi
done

mkdir -p /run/pb /var/log/pb
rm -f /run/pb/autostart.done
echo "[pb] image setup done"
