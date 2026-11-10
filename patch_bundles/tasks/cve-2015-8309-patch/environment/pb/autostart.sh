# [patch-bundle] 经镜像 ENV BASH_ENV 被每个非交互 bash 读取（含 OpenSandbox execd 的 `bash -c`）。
# 平台不执行镜像 CMD 时，由沙箱内第一条以 root 执行的 bash 命令同步拉起原 compose 服务，
# 等价于原环境“容器启动即服务就绪”；之后每次仅做一次文件存在判断，无输出、不改 $?。
if [ ! -e /run/pb/autostart.done ] && [ "${EUID:-1}" = 0 ] && [ -z "${PB_IN_SERVICE:-}" ]; then
    BASH_ENV= PB_IN_SERVICE=1 /opt/pb/ensure-services --quiet </dev/null >/dev/null 2>&1
    { mkdir -p /run/pb && : > /run/pb/autostart.done; } 2>/dev/null
fi
