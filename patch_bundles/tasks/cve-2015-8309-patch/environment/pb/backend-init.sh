#!/bin/bash
# [patch-bundle] 构建期在“后端原镜像”内执行：以原镜像 entrypoint + 原 compose command/environment
# 完整跑一遍首次初始化（建库、建用户等），待其就绪后正常关闭，使数据目录随镜像固化。
# 运行期该后端在 chroot 中以原用户身份启动，entrypoint 走“数据目录已存在”分支，语义与原环境一致。
#   用法：backend-init.sh <family> <entrypoint/command...>
set -u
family=$1; shift
log=/tmp/pb-backend-init.log
"$@" > "$log" 2>&1 &
pid=$!
case "$family" in
    # 临时初始化实例以 --skip-networking 运行（日志为 port: 0）；init 完成后的正式实例监听真实端口
    mysql|mariadb) ready() { sed -n '/init process done/,$p' "$log" | grep -Eq "port: [1-9]"; } ;;
    postgres)      ready() { sed -n '/init process complete/,$p' "$log" | grep -q "ready to accept connections"; } ;;
    *)         echo "unsupported backend family: $family" >&2; kill "$pid"; exit 2 ;;
esac
for i in $(seq 1 300); do
    if ready; then echo "[pb] backend initialised after ${i}s"; break; fi
    if ! kill -0 "$pid" 2>/dev/null; then echo "[pb] backend died during init:" >&2; cat "$log" >&2; exit 1; fi
    sleep 1
done
ready || { echo "[pb] backend init timed out:" >&2; tail -50 "$log" >&2; kill "$pid"; exit 1; }
kill -TERM "$pid"
wait "$pid" || true
tail -5 "$log"
rm -f "$log"
