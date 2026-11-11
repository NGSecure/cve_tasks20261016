# CVE「打 patch」题 → 新平台单镜像 patch bundle

来源：`cve-verified-1497/`（Harbor 打 patch 题，只读，未改动）。本目录把其中 **全部 1497 题** 直接转换为新平台的 **patch bundle**（不再转成打 PoC），产物在 `tasks/<cve>-patch/`，逐题转换记录见 `conversion_report.csv`。

## 1. 判定模型（与原题一致）

原题的流程是：沙箱联网启动、服务就绪后进入 agent 阶段；agent 在漏洞环境里**原地修改代码**（需要时自己重启服务或重新编译），**断网**，可以反复修改、反复自测；任务结束后，在**同一环境**里**联网**运行一次 `tests/test.sh`，结果为二值：

- `test_vuln.py` 相当于标准 PoC，是一组攻击请求，修复后必须全部被挡住；
- `test_func.py` 是回归测试，原有功能必须仍然可用，用来排除“删功能”“停服务”之类的伪修复；
- 两组测试全部通过时 reward=1，否则为 0。

所以 patch 题**只需要漏洞版这一个环境**：不需要 fix 环境，也不需要 task-server。测试文件只在判定时上传，agent 工作期间看不到。

| | 打 PoC（旧转换） | 打 patch（本目录） |
|---|---|---|
| agent 产出 | 一个能触发漏洞的输入 | 对漏洞代码的原地修改 |
| 需要的环境 | vul + fix（fix 由 solve.sh 构造） | 只要 vul |
| 谁打谁 | agent 的 PoC 打 vul 和 fix | 标准 PoC（test_vuln）打 agent 修过的环境 |
| 通过条件 | vul 被触发，fix 不被触发 | 攻击全部被挡住，功能测试全部通过 |
| 在哪里判定 | 独立的 task-server | 同一个沙箱（单镜像），判定一次 |

单镜像 = 原 Dockerfile（逐字保留）+ 折叠进来的 compose 后端（如 mysql:5.7）+ 一层平台适配，对应 `task.toml` 的 `[environment].docker_image`。

## 2. 目录结构

```
patch_bundles/
├── conversion/
│   ├── convert_patch_bundle.py   # 生成器：原题目录 → bundle
│   ├── convert_all.py            # 批量转换，写 conversion_report.csv
│   ├── runtime/                  # 拷进每个 bundle 的 environment/pb/，构建进镜像 /opt/pb/
│   │   ├── ensure-services       # 按原 compose 语义拉起服务（幂等，不重启已运行的服务）
│   │   ├── supervise             # 复现 restart: unless-stopped
│   │   ├── init / autostart.sh   # 镜像 CMD / BASH_ENV 兜底（平台不执行 CMD 时由首条 bash 命令拉起服务）
│   │   ├── backend-init.sh       # 构建期在后端原镜像内按原 environment 完成首次初始化
│   │   └── setup-image.sh        # 构建期：主服务环境快照、后端自检（含 postgres 共享内存实现重选）、运行期目录
│   ├── templates/                # task.toml / build.sh / push.sh 模板
│   ├── image_configs.json        # 基础镜像与后端镜像的 Entrypoint/Cmd/Env/User 缓存（转换可离线复现）
│   └── local/                    # 本地工具，不随 bundle 分发
│       ├── build_local.sh        # 仅用于出网经 TLS 中间人代理的受限环境（注入构建期 CA）；不要用它构建要推送的镜像
│       └── leakscan.py           # 泄漏扫描
├── conversion_report.csv         # 每题一行：status、后端、主服务、镜像 USER、特殊标记（flags）
└── tasks/<cve>-patch/
    ├── task.toml  instruction.md  build.sh  push.sh
    ├── environment/{Dockerfile, task-deps/, pb/}
    ├── solution/solve.sh
    └── tests/{test.sh, test_func.py, test_vuln.py, ...}
```

## 3. 用法

```bash
# Phase 1：公网环境，构建 + 自检（agent 阶段断网执行 solve.sh，判定阶段联网执行 test.sh）
# 要求 Noop=0 / Oracle=1，且 pytest 条数与审计记录（manifest.csv）逐项一致
bash patch_bundles/tasks/cve-2012-0973-patch/build.sh
SELF_CHECK_FULL=1 bash patch_bundles/tasks/cve-2012-0973-patch/build.sh   # 另以“执行镜像 CMD”的方式再跑一遍

# Phase 2：上传网络，直推 SWR 并回填 task.toml（与 arvo bundle 同一套）
docker login swr-coder-data-platform-wce1sr.swr-pro.myhuaweicloud.com
export NEWPLATFORM_DIR=/path/to/VulAgent/new_platform_harbor
bash patch_bundles/tasks/cve-2012-0973-patch/push.sh

# 重新生成：全部 / 部分 / 单题（--link 以硬链接代替复制未改动的文件，仅省磁盘）
python3 patch_bundles/conversion/convert_all.py --link
python3 patch_bundles/conversion/convert_all.py --link --only cve-2012-0973,cve-2014-0238
python3 patch_bundles/conversion/convert_patch_bundle.py cve-verified-1497/<cve> patch_bundles/tasks/<cve>-patch
```

批量构建时 Docker Hub 匿名拉取会被限流（429），请先 `docker login`，或给 dockerd 配置镜像源（如 `--registry-mirror https://mirror.gcr.io`）。同理，原 Dockerfile 中经 composer 等从 GitHub API 下载依赖的步骤，在同一出口 IP 上大量构建时也可能触发 GitHub 的匿名限额，需分批或错峰构建。

## 4. 与原题的全部差异

原则：**题面、参考解、测试用例、漏洞代码与版本一律不动**，只改运行环境与判分管道。

| 项目 | 处理 | 为什么不影响难度和考察点 |
|---|---|---|
| `instruction.md`、`solution/`、`tests/` 中除 `test.sh` 外的文件、`environment/` 中除 `Dockerfile`/`docker-compose.yaml` 外的文件 | 逐字节相同（含文件权限） | 题面、参考解、判据完全不变 |
| 原 `environment/Dockerfile` | 逐字嵌入新 Dockerfile 的中段 | 应用、漏洞代码、依赖版本不变 |
| `tests/test.sh` | 只在原有兜底 `trap` 之后插入 7 行前缀：建 `/logs/verifier`、root 下设 `HOME=/root`、判定前调用 `ensure-services`（另有 1 题修复原题的语法错误，见 §7） | uv / pip 等安装步骤与 pytest 命令、判分逻辑一字未改，判定时照原样联网安装 |
| compose 后端（如 `mysql:5.7`、`redis:7`） | 用**同一个上游镜像**的完整 rootfs 折叠进主镜像；运行期以原 entrypoint + command、原用户身份在 chroot 中运行；服务名（如 `db`）解析到 127.0.0.1；与 docker 一样，本机主机名在后端内可解析，后端的 `HOSTNAME` 等于主机名 | 后端版本、配置、初始数据与原环境一致，只是从“另一个容器”变成“同一沙箱内的进程” |
| 需初始化的后端（mysql / mariadb / postgres / mongo） | 构建期以原 environment/command 完整跑一遍首次初始化（建库、建用户、执行 initdb 脚本），数据目录随镜像固化 | 与原环境首次启动后的状态相同；运行期 entrypoint 走“已初始化”分支 |
| 旧版 glibc 的 postgres 后端（postgres:9.4、9.6、11、12.2，共 6 题） | 数据目录中的 `dynamic_shared_memory_type` 由 posix 改为 sysv。做法是在构建期、与运行期相同的 chroot 条件下运行该镜像自带的 initdb，采用它的选择；新版 glibc 的 postgres（12、13、14、15）经同样的探测保持 posix | chroot 内无法挂载 tmpfs，`/dev/shm` 只是普通目录，旧版 glibc（实测 2.24、2.28、2.31）的 `shm_open` 因此直接失败，postgres 启动即退出。sysv 正是 initdb 在这种环境下本来会做的选择；它只决定 postgres 内部共享内存段的分配方式，不影响任何 SQL 行为 |
| 原 compose 挂载给后端的文件（45 题共 53 个，如 initdb SQL、mongo init js、LDAP ldif） | 构建期 `COPY` 到原挂载点，内容逐字相同；命名卷忽略（数据随镜像） | 初始化输入不变 |
| 由 `Dockerfile.db` 等源码构建的后端（6 题） | 把该 Dockerfile 逐字内联为一个构建阶段（只把 FROM 行的阶段名改为 `pb-backend-<服务名>`） | 后端构建过程不变 |
| 服务启动语义 | `ensure-services` 复现 depends_on(service_healthy) + healthcheck + restart: unless-stopped；**只启动未运行的服务，绝不重启已运行的服务** | agent 若改了需要重启才生效的代码却没重启，判的仍是旧代码，与原环境一致 |
| 无 healthcheck 的服务 | 主服务以 EXPOSE 端口、后端以该类数据库的默认端口（命令行指定端口时以命令行为准）连续 10 秒可连为就绪；无端口可探测时以进程连续 10 秒存活为就绪 | 原 entrypoint 常先起临时实例做初始化；原环境里容器启动到判定之间隔着整个 agent 阶段，服务早已稳定，单镜像须显式等待才能达到同样的就绪状态 |
| 镜像 USER 为非 root 的 6 题 | 镜像 USER 保持原值；主服务总以该用户运行（以 root 调用时按 docker 的方式降权，含附加组），`HOME` 按 docker 规则确定 | 服务的运行身份与原容器一致 |
| main 需要特权的 10 题（9 题 privileged、1 题仅 cap_add） | 镜像不变；把原设置记入 `task.toml [metadata]` 的 `sandbox_privileged / sandbox_cap_add / sandbox_security_opt / sandbox_devices`，`build.sh` 自检以同等权限运行 | 平台须以同等权限启动沙箱，见 §6 |
| 镜像入口 | `CMD ["/opt/pb/init"]`；`ENV BASH_ENV=/opt/pb/autostart.sh`；基础镜像有 ENTRYPOINT 时置空（并入主服务命令，如 `docker-php-entrypoint /entrypoint.sh`）。无常驻服务的 697 题 CMD 保持原 compose 的保活命令 | OpenSandbox 默认以 `tail -f /dev/null` 为入口、不执行镜像 CMD，命令经 `bash -c` 执行；BASH_ENV 让沙箱内第一条 bash 命令同步拉起服务，等价于原环境“容器启动即服务就绪” |
| `environment/docker-compose.yaml` | 移除（服务定义已转为 `environment/pb/services.sh`） | 单镜像，TaskHub 的 Oracle/Noop 不支持 compose |

agent 能看到的环境差异仅有：`/opt/pb/`（服务脚本与后端 rootfs）、环境变量 `BASH_ENV`、`ps` 中的 supervise / chroot 进程。这些都不包含答案信息；镜像里没有预装任何判定依赖。

## 5. 验证结果

**静态检查（全部 1497 题，通过）**：原题目录零改动（`git status` 干净）；10.9 万个应当保留的文件逐字节一致且权限相同；每个 `test.sh` 去掉前缀后与原文完全相同（cve-2022-21685 另有一处已注明的修复）；原 Dockerfile 逐字出现在新 Dockerfile 中；新 Dockerfile 中 `COPY` 的来源全部存在；`services.sh` 可被 bash 正确加载且每个后端的字段齐全；`task.toml` 的难度、类别、标签、超时与资源配额与原题一致；生成的脚本与 `test.sh` 均通过 `bash -n`（原题中唯一的语法错误 cve-2022-21685 已做最小修复，见 §7）。

**判定输出格式（全部 1497 题，通过）**：平台优先读 `/logs/verifier/reward.json`，要求每个值都是数字，否则报 `validation errors for VerifierResult`；没有 reward.json 时以 `float()` 解析 `reward.txt`。全部 test.sh 只以覆盖写的方式向 `reward.txt` 写入单个 `0` 或 `1`（兜底 trap 仅在文件为空时写 0），没有任何文件写 reward.json，转换也不改动奖励写入。`build.sh` 按平台的同一规则解析判定输出，平台会拒收的输出直接判自检失败。另有 8 题的 test.sh 原本就没有兜底 trap（cve-2017-0901、cve-2017-9763、cve-2018-25032、cve-2018-8947、cve-2019-15642、cve-2022-21725、cve-2022-22984、cve-2023-26920）：只有判定时依赖安装失败才会不写 reward，平台记为判定异常（RewardFileNotFoundError）而不是 0，与原题行为一致，未改动。

**抽样实跑**：在本地按平台与原题 `task.toml` 的联网时序执行：沙箱联网启动，首条命令（以 root 建日志目录）拉起服务并等待就绪；随后断网（在容器网络命名空间里删除默认路由，eth0 与 IP 不变，模拟平台的出网策略），（Oracle）以镜像默认用户执行 `solve.sh`；判定前恢复联网，上传 tests 并运行 `test.sh`。

| 题目 | 特点 | Noop | Oracle | 泄漏扫描 |
|---|---|---|---|---|
| cve-2019-12108 | main 为 privileged；miniupnpd 绑定 eth0 | 0（4 failed, 6 passed） | 1（10 passed） | 无可疑项 |
| cve-2016-7145 | 镜像 USER 非 root（ircd） | 0（11 failed, 12 passed） | 1（23 passed） | 无可疑项¹ |
| cve-2014-0238 | C 库，无常驻服务 | 0（3 failed, 10 passed） | 1（13 passed） | 无可疑项 |
| cve-2012-0973 | PHP + mysql:5.7 | 0（12 failed, 12 passed） | 1（24 passed） | 无可疑项² |
| cve-2015-7294 | docker-test-openldap | 0（5 failed, 7 passed） | 1（12 passed） | 无可疑项 |
| cve-2021-43826 | Envoy + 源码构建的上游后端 | 0（6 failed, 12 passed） | 1（18 passed） | 无可疑项 |
| cve-2021-4247 | mongo:4.4 | 0（7 failed, 9 passed）³ | 1（16 passed） | 无可疑项 |
| cve-2014-125045⁴ | mysql:5.7 + initdb 脚本 | 0（12 failed, 13 passed） | 1（25 passed） | 无可疑项 |
| cve-2015-10023⁴ | postgres:13 | 0（13 failed, 16 passed） | 1（29 passed） | 无可疑项 |

除注明者外，pytest 通过与失败的条数与审计记录逐项一致。

1. 只命中 nefarious2 源码仓库自带的历史补丁（`doc/*.patch`、`patches/diffs/*.diff`），均不涉及参考解所改的 `m_authenticate.c`、`version.c`，按现行规则单列备查。
2. 修复指纹出现在原题环境内的 `Field.php`：参考解照抄了同库中已有的正确检查，属原题设计，不是转换引入的。
3. 审计记录为 8 failed / 8 passed，差一条：`test_server_survives_connection_timeout` 连接黑洞地址 10.255.255.1 等待超时，结果取决于网络是否静默丢弃发往该地址的包。Noop 仍为 0，Oracle 与审计一致。
4. 在自检改为“联网启动”之前实跑（当时从启动起即断网，判定前联网），其余流程相同；这两题的服务启动不需要联网。

泄漏扫描覆盖：`.git` 目录、隐藏测试与参考解（按文件名与内容哈希）、补丁/备份文件，以及“修复指纹”（参考解新增的特征行在镜像别处是否出现）。补丁/备份文件只把转换新增的、或内容涉及参考解所改文件的判为可疑，源码仓库自带的历史补丁单列备查；修复指纹只把出现在转换新增内容（`/opt/pb`）中的判为可疑，出现在原题环境内的单列，供对照原题。

受本地开发沙箱出网限制、无法在此得出结论的抽样有三题：cve-2015-10125 启动时用 wp-cli 下载 WordPress，本地出网经 TLS 中间人代理，下载失败（cURL error 60），全部测试报错，需平台保证启动期联网（§6 第 2 项）；cve-2014-125077 的 `cron.php` 要从外网拉取 Searx 实例列表，本地超时，Noop 与 Oracle 各多一条失败，其余用例一致；cve-2021-4259 构建时 composer 经 GitHub API 下载依赖，被本地代理拦截，无法构建。

**后端实测（本批全部 43 种后端，全部健康）**：本地出网代理失效后，改为单独验证后端：用各题真实的后端构建阶段与 `/opt/pb` 运行时构建镜像（主服务换成最小镜像、不启动），在断网容器中运行 `ensure-services`，检查每个折叠后端能否在 chroot 中启动并通过原 healthcheck。本批 282 道带后端的题共用 37 种上游镜像和 6 个源码构建的后端，每种至少实测一题，全部在最终版运行时上健康：mysql 5.6 / 5.7 / 8.0 / 8.0.19，mariadb 10.1 / 10.3 / 10.4 / 10.5 / 10.6 / 10.7 / 10.11，postgres 9.4 / 9.6 / 11 / 12 / 12.2 / 13 / 14 / 15，mongo 3.6 / 4.0 / 4.4 / 5 / 5.0 / 5.0-focal，redis 5 / 5.0.6 / 6 / 6.2 / 6-alpine / 6-bookworm / 7，memcached 1.5，couchdb 3.2，registry 2，osixia/openldap 1.5.0，docker-test-openldap，以及 4 个基于 mysql / mariadb 的 `Dockerfile.db`、dovecot 和 Envoy 测试上游。

这项实测发现并修复了两个问题：

- **旧版 glibc 的 postgres 起不来（6 题）。** postgres:9.4、9.6、11、12.2 基于 glibc 2.24 / 2.28，其 `shm_open` 要求 `/dev/shm` 是 tmpfs，而 chroot 内无法挂载，postgres 启动即报 `could not open shared memory segment ...: Function not implemented`。现在构建期在相同的 chroot 条件下运行该镜像自带的 initdb，采用它的选择：这 4 个版本选 sysv，12 / 13 / 14 / 15 仍为 posix（见 §4）。
- **osixia/openldap 起不来（cve-2020-5246）。** 其启动脚本执行 `hostname --fqdn`，而后端内无法解析本机主机名，脚本失败后，镜像的进程管理器还会终止沙箱内所有进程。现在与 docker 一致：后端内本机主机名可解析，`HOSTNAME` 等于主机名，slapd 的监听方式与原环境相同。

## 6. 需要平台确认的事项

1. 判定阶段联网：**已确认**。test.sh 照原样在线安装依赖，镜像不预装。
2. **联网时序与断网方式。** 原题 `task.toml` 的时序是：启动阶段联网（`[environment] network_mode = "public"`），agent 阶段断网，判定阶段联网。平台需满足两点：
   - 沙箱启动到首条命令返回（服务就绪）之前保持联网。少数题的服务启动时就要联网，例如 cve-2015-10125 启动时用 wp-cli 下载 WordPress，断网启动则主服务起不来、所有测试报错。对 800 道有常驻服务的题扫描了启动脚本：明确依赖启动期联网的只有这一题；另有约 10 题在启动时执行 mvn、gradle、npx 等可能联网的命令，其依赖已在构建期安装或缓存，预计不受影响，但未逐题断网实测。
   - 以出网策略断网，保留 eth0 与 IP，不能移除或重建网卡。有 16 题的启动脚本、服务配置或测试引用了 eth0 或本机 IP（如 cve-2019-12108 的 miniupnpd 以 `listening_ip=eth0` 启动，测试连 eth0 的地址），网卡缺失、被移除或重建都会使其失效。Harbor 的 Docker 与 OpenSandbox 实现都用与沙箱共享网络命名空间的 egress sidecar 控制出网，满足这一点。
3. 平台是否执行镜像 CMD。按 Harbor 的 OpenSandbox 实现，默认不执行；本方案以 BASH_ENV 兜底，两种情况都已验证。
4. 沙箱是否保留 `CAP_SYS_CHROOT`、`CAP_MKNOD`，`/etc/hosts` 是否可写（Docker 与 K8s 默认均满足）。只影响带后端的 282 题。
5. 10 题的 main 原本以特权运行（cve-2014-9114、cve-2017-5985、cve-2018-10856、cve-2019-12108、cve-2019-12109、cve-2019-12589、cve-2021-3995、cve-2022-27651、cve-2022-29162 为 privileged，cve-2021-39196 为 cap_add NET_RAW/NET_ADMIN）。平台若不能以同等权限启动沙箱，这些题的漏洞或修复可能无法验证，建议先不上线。
6. agent 与 verifier 以什么用户运行。1491 题镜像 USER 为 root；6 题为非 root（cve-2016-7145 ircd、cve-2020-5221 ftpuser、cve-2022-1430 与 cve-2022-2930 octoprint、cve-2022-37298 shinken、cve-2024-21527 gotenberg），原题中 agent 与 test.sh 也以该用户执行。两种调用方式本方案都能拉起服务。
7. 是否需要另行收集 agent 的补丁 diff 作留档。判分不依赖它。
8. 命名：`nwrc/<cve>-patch`，`[metadata] type = "patch"`。

## 7. 已知问题与风险

1. **原题缺陷（已做最小修复）：cve-2022-21685 原本永远判 0。** 原 `tests/test.sh` 第 89 行 `echo` 缺右引号，bash 读到文件末尾报语法错误，后面的判分语句从不执行，兜底 trap 一律记 0，参考解也拿不到 1（审计记录 manifest.csv 已注明，审计方当时写好的补丁未能应用）。本转换只补上这一个引号（见 `convert_patch_bundle.py` 的 `KNOWN_TEST_FIXES`）：测试命令不变，判分语义恢复原意，即 `set -e` 下 pytest 失败即退出记 0、全部通过记 1。这是全部 1497 题中唯一一处对原测试文件的改动。
2. **后端进程对 agent 可见。** 原环境中后端在另一个容器里，agent 无法触及；单镜像中拥有 root 的 agent 能看到、也能杀掉后端进程。`supervise` 会在 2 秒后自动拉起，效果等同于“agent 无法让后端长期停摆”，与原环境一致。原 compose 中多数后端没有 restart 策略，但它们在原环境里本就不受 agent 影响，所以统一自动重启更贴近原题。
3. **网络拓扑变化。** 后端从独立主机（如 `db`）变成 127.0.0.1 上的别名，所有服务共享同一个回环地址与端口空间。涉及“内外网 / 主机名 / 来源 IP 区分”的漏洞（如 SSRF 打内网服务、按来源地址授权）需逐题复核。
4. **判定在 agent 的沙箱内进行。** 这是 Harbor patch 题的固有设计：拥有 root 的 agent 理论上可以篡改判定时用到的工具链（如 PATH 中的命令、系统 Python）。判定依赖现在与原题一样在判定时联网现装，不再预置在镜像里，预先篡改的余地比离线预装方案更小；仍建议在轨迹审查中留意。
5. **后端在 chroot 中运行，没有 `/proc`。** 容器内没有 CAP_SYS_ADMIN，无法在 chroot 内挂载 proc 或 tmpfs。本批全部 43 种后端都已实测能在这种条件下启动（§5）。已知的连带限制是旧版 glibc 的 POSIX 命名共享内存与信号量（`shm_open` / `sem_open`）不可用；本批只有 postgres 受影响，已处理（§4）。今后若新增依赖 `/proc` 或这两个接口的后端镜像，`build.sh` 自检会暴露。
6. **镜像标签可变。** 原题使用 `redis:7`、`mongo:5.0` 这类可变标签，将来构建时拉到的版本可能与审计时不同。这一点原题同样存在；本转换与原题使用同一标签，二者在同一时刻构建得到的版本一致。`image_configs.json` 记录的是 2026-11 抓取的镜像配置，仅用于生成服务启动命令。
7. **自检的 pytest 条数比对。** `build.sh` 要求 Noop/Oracle 的 pytest 通过与失败条数与审计记录逐项一致，用来确认环境行为与原环境一致。含随机性或依赖外部网络的测试可能出现条数波动，例如 cve-2021-4247 的 `test_server_survives_connection_timeout` 连接黑洞地址 10.255.255.1 等待超时，结果取决于所在网络是否静默丢弃该地址的包；cve-2014-125077 的 `cron.php` 要从外网拉取 Searx 实例列表。出现波动时可用 `ALLOW_COUNT_MISMATCH=1` 降级为警告后人工判断。
8. **osixia/openldap 的进程管理器退出时会终止沙箱内所有进程（仅 cve-2020-5246）。** 该镜像的 `/container/tool/run` 在 slapd 退出或自身收到 SIGTERM 时执行 `kill(-1, SIGTERM)`。原环境中这只影响 ldap 容器；折叠后共享同一个 PID 命名空间，agent 若杀掉 slapd 或这个 Python 进程，沙箱内除 PID 1 外的进程都会被终止。下一条命令或判定前的 `ensure-services` 会重新拉起全部服务，判定不受影响，但 agent 当时正在执行的命令会被中断。正常运行时不会触发；为不改动后端命令，本转换只记录这一风险。
9. **本仓库开发沙箱的限制（与 bundle 无关）。** 该沙箱的出网代理拦截 GitHub API 与 codeload 下载，原 Dockerfile 中经 composer 从 GitHub 下载依赖的题（如 cve-2021-4259）无法在此构建；Docker Hub 匿名拉取被限流，抽样实跑改走 `mirror.gcr.io`。在普通公网环境直接运行 `build.sh` 即可。
