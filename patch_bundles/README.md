# CVE「打 patch」题 → 新平台单镜像 patch bundle（试点）

来源：`cve-verified-1497/`（Harbor 打 patch 题，只读，未改动）。本目录把其中的题目直接转换为新平台的 **patch bundle**，不再转成打 PoC。试点 4 题，覆盖四类典型环境。

## 1. 判定模型

原题的判定方式是：agent 在漏洞环境里**原地修改代码**（需要时自己重启服务或重新编译），任务结束后，在**同一环境**里运行 `tests/test.sh`：

- `test_vuln.py` 相当于标准 PoC，是一组攻击请求，修复后必须全部被挡住；
- `test_func.py` 是回归测试，原有功能必须仍然可用，用来排除“删功能”“停服务”之类的伪修复；
- 两组测试全部通过时 reward=1。

所以 patch 题**只需要漏洞版这一个环境**：不需要 fix 环境，也不需要 task-server。测试文件只在判定时上传，agent 工作期间看不到。

| | 打 PoC（旧转换） | 打 patch（本目录） |
|---|---|---|
| agent 产出 | 一个能触发漏洞的输入 | 对漏洞代码的原地修改 |
| 需要的环境 | vul + fix（fix 由 solve.sh 构造） | 只要 vul |
| 谁打谁 | agent 的 PoC 打 vul 和 fix | 标准 PoC（test_vuln）打 agent 修过的环境 |
| 通过条件 | vul 被触发，fix 不被触发 | 攻击全部被挡住，功能测试全部通过 |
| 在哪里判定 | 独立的 task-server | 同一个沙箱（单镜像） |

单镜像 = 原 Dockerfile（逐字保留）+ 折叠进来的 compose 后端（如 mysql:5.7）+ 一层平台适配，对应 `task.toml` 的 `[environment].docker_image`。

## 2. 目录结构

```
patch_bundles/
├── conversion/
│   ├── convert_patch_bundle.py   # 生成器：原题目录 → bundle
│   ├── runtime/                  # 拷进每个 bundle 的 environment/pb/，构建进镜像 /opt/pb/
│   │   ├── ensure-services       # 按原 compose 语义拉起服务（幂等，不重启已运行的服务）
│   │   ├── supervise             # 复现 restart: unless-stopped
│   │   ├── init / autostart.sh   # 镜像 CMD / BASH_ENV 兜底（平台不执行 CMD 时由首条 bash 命令拉起服务）
│   │   ├── backend-init.sh       # 构建期在后端原镜像内按原 environment 完成首次初始化
│   │   └── setup-image.sh        # 构建期：环境快照、预装 uv 并预热测试依赖缓存、后端自检
│   ├── templates/                # task.toml / build.sh / push.sh 模板
│   ├── image_configs.json        # 基础镜像与后端镜像的 Entrypoint/Cmd/Env 缓存（生成可复现）
│   └── local/                    # 本地工具，不随 bundle 分发
│       ├── build_local.sh        # 仅用于出网经 TLS 中间人代理的受限环境（注入构建期 CA）；不要用它构建要推送的镜像
│       └── leakscan.py           # 泄漏扫描
└── tasks/<cve>-patch/
    ├── task.toml  instruction.md  build.sh  push.sh
    ├── environment/{Dockerfile, task-deps/, pb/}
    ├── solution/solve.sh
    └── tests/{test.sh, test_func.py, test_vuln.py, run-tests.sh}
```

## 3. 用法

```bash
# Phase 1：公网环境，构建 + 断网自检（Noop=0 / Oracle=1，且 pytest 条数须与审计记录一致）
bash patch_bundles/tasks/cve-2012-0973-patch/build.sh
SELF_CHECK_FULL=1 bash patch_bundles/tasks/cve-2012-0973-patch/build.sh   # 另以“执行镜像 CMD”的方式再跑一遍

# Phase 2：上传网络，直推 SWR 并回填 task.toml（与 arvo bundle 同一套）
docker login swr-coder-data-platform-wce1sr.swr-pro.myhuaweicloud.com
export NEWPLATFORM_DIR=/path/to/VulAgent/new_platform_harbor
bash patch_bundles/tasks/cve-2012-0973-patch/push.sh

# 重新生成某题
python3 patch_bundles/conversion/convert_patch_bundle.py cve-verified-1497/<cve> patch_bundles/tasks/<cve>-patch
```

## 4. 与原题的全部差异

原则：**题面、参考解、测试用例、漏洞代码与版本一律不动**，只改运行环境与判分管道。

| 项目 | 处理 | 为什么不影响难度和考察点 |
|---|---|---|
| `instruction.md`、`solution/solve.sh`、`tests/test_*.py`、`tests/run-tests.sh`、`environment/task-deps/` | 逐字节相同 | 题面、参考解、判据完全不变 |
| 原 `environment/Dockerfile` | 逐字嵌入新 Dockerfile 的中段 | 应用、漏洞代码、依赖版本不变 |
| `tests/test.sh` | 只加 8 行前缀（建 `/logs/verifier`、离线使用预装 uv、判定前调用 `ensure-services`），并给 uv 安装行加“已安装则跳过”守卫 | pytest 命令与判分逻辑一字未改 |
| compose 后端（如 `mysql:5.7`） | 用**同一个上游镜像**的完整 rootfs 折叠进主镜像；构建期以原 environment/command 完成首次初始化；运行期以原 entrypoint + command、原用户身份在 chroot 中运行；服务名 `db` 解析到 127.0.0.1 | 后端版本、配置、初始数据与原环境一致，只是从“另一个容器”变成“同一沙箱内的进程” |
| 服务启动语义 | `ensure-services` 复现 depends_on(service_healthy) + healthcheck + restart: unless-stopped；**只启动未运行的服务，绝不重启已运行的服务** | agent 若改了需要重启才生效的代码却没重启，判的仍是旧代码，与原环境一致 |
| 无 healthcheck 的主服务 | 以端口连续 10 秒可用为就绪 | 原 entrypoint 常先起临时实例做初始化（如 CherryMusic 先 `timeout 5` 跑一次再建管理员账号）；原环境里这段时间被 agent 运行和联网装依赖自然覆盖，离线化后须显式等待，才能和原环境的就绪状态一致 |
| 镜像入口 | `CMD ["/opt/pb/init"]`；`ENV BASH_ENV=/opt/pb/autostart.sh`；基础镜像有 ENTRYPOINT 时置空（并入主服务命令，如 `docker-php-entrypoint /entrypoint.sh`） | OpenSandbox 默认以 `tail -f /dev/null` 为入口、不执行镜像 CMD，命令经 `bash -c` 执行；BASH_ENV 让沙箱内第一条 bash 命令同步拉起服务，等价于原环境“容器启动即服务就绪” |
| 判定依赖 | 构建期用与 test.sh 相同的官方脚本预装 uv 0.7.13，并用相同的 `uv init` + `uv add …` 预热缓存（安装脚本改写的 shell 启动文件随即还原） | 判定阶段无需联网；agent 本就无网络，不受影响 |
| `environment/docker-compose.yaml` | 移除（服务定义已转为 `environment/pb/services.sh`） | 单镜像，TaskHub 的 Oracle/Noop 不支持 compose |

agent 能看到的环境差异仅有：`/opt/pb/`（服务脚本与后端 rootfs）、环境变量 `BASH_ENV`、`ps` 中的 supervise/chroot 进程、`~/.local/bin/uv` 与 uv 缓存。这些都不包含答案信息。

## 5. 试点验证结果

全部在本地以断网容器实跑，按平台流程执行：首条命令建日志目录 → （Oracle）执行 solve.sh → 上传 tests 并运行 test.sh。每题分别在“平台式启动（入口为 `tail -f /dev/null`）”和“执行镜像 CMD”两种方式下各跑一遍，结果相同。

| 题目 | 环境类型 | Noop | Oracle | 与审计记录对比 | 泄漏扫描 |
|---|---|---|---|---|---|
| cve-2012-0973（OSClass） | PHP 5.6 + MySQL 5.7 后端 | 0（12 failed, 12 passed） | 1（24 passed） | 一致 | 无异常 |
| cve-2015-8309（CherryMusic） | Python 常驻服务，修复后需重启 | 0（7 failed, 7 passed） | 1（14 passed） | 一致 | 无异常 |
| cve-2021-4236（ecnepsnai/web） | Go 服务，修复后需重新编译 | 0（7 failed, 10 passed） | 1（17 passed） | 一致 | 无异常 |
| cve-2014-0238（file/libmagic） | C 库 / CLI，无常驻服务 | 0（3 failed, 10 passed） | 1（13 passed） | 一致 | 无异常 |

Noop 失败的用例恰好是全部 `test_vuln` 用例，`test_func` 全部通过。

泄漏扫描覆盖：`.git` 目录、隐藏测试与参考解（按文件名与内容哈希）、补丁/备份文件，以及“修复指纹”（参考解新增的特征行在镜像别处是否出现）。指纹在原题环境内有两处命中，均已人工确认属于原题设计，不是泄漏：cve-2021-4236 的修复照抄同一库 `api.go`/`http.go` 中已有的鉴权检查（题面本就提示 HTTP 端点鉴权正确）；cve-2012-0973 仅方法签名 `public function findBySlug($slug)` 与 `Field.php` 同名。转换新增内容中无任何命中。

## 6. 需要平台确认的事项

1. 判定阶段是否有网络。本方案已做成离线可判，两种情况都能工作。
2. 平台是否执行镜像 CMD。按 Harbor 的 OpenSandbox 实现，默认不执行；本方案以 BASH_ENV 兜底，两种情况都已验证。
3. 沙箱是否保留 `CAP_SYS_CHROOT`、`CAP_MKNOD`，`/etc/hosts` 是否可写（Docker 与 K8s 默认均满足）。只影响带后端的题目（1497 题中 282 题）。
4. agent 与 verifier 是否以 root 运行（原题均为 root）。
5. 是否需要另行收集 agent 的补丁 diff 作留档。判分不依赖它。
6. 命名：`nwrc/<cve>-patch`，`[metadata] type = "patch"`。

## 7. 扩量前的已知事项

- 后端族目前支持 mysql / mariadb / postgres（试点实测了 mysql）。全量中还有 redis 28、mongo 18 等需补充；6 题的后端需从源码构建，生成器会报 UNSUPPORTED，需单独处理。
- 漏洞本身涉及“内外网/主机名区分”的题（如 SSRF 打内网服务），后端改为 127.0.0.1 后需逐题复核。
- 判定在 agent 的沙箱内进行，这是 Harbor patch 题的固有设计：拥有 root 的 agent 理论上能篡改测试工具链，离线缓存让这一点略为容易。建议在轨迹审查中留意。
- 批量构建时 Docker Hub 匿名拉取会被限流，需要登录或使用镜像源。
- 运行时脚本依赖 util-linux / coreutils（`flock`、`setsid`、`chroot --userspec`）。试点 4 题均为 Debian 系镜像；转换 Alpine / busybox 系镜像前需补充降级处理。
