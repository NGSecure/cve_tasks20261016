#!/usr/bin/env python3
"""把 cve-verified-1497 里的 Harbor「打 patch」题目转换为新平台单镜像 patch bundle。

原则（不改变题目的难度与考察点）：
  * instruction.md、solution/、tests/test_*.py、漏洞代码与版本、原 Dockerfile 全部逐字保留；
  * 只改运行环境与判分管道：
      - 原 compose 的后端服务（如 mysql:5.7、redis:7，或由 Dockerfile.db 构建的后端）按原镜像 rootfs
        折叠进主镜像；原 compose 挂载给后端的初始化文件（initdb SQL 等）在构建期放到原挂载点，
        需初始化的后端（mysql/mariadb/postgres/mongo）构建期按原 environment 完成首次初始化；
      - 原 compose 的 main command / healthcheck / depends_on / restart 语义由 /opt/pb/ensure-services 复现；
      - tests/test.sh 只加平台适配前缀（建日志目录 + 判定前兜底拉起服务）；测试命令、依赖安装与判分逻辑
        照原样执行（与原题一致：agent 阶段断网，判定阶段联网，test.sh 在判定时在线安装 uv 与测试依赖）；
  * 生成 build.sh（构建 + 自检 Noop=0/Oracle=1）与 push.sh（直推 SWR + 回填 task.toml）。

用法：
  python3 convert_patch_bundle.py <原任务目录> <输出 bundle 目录> [--version v0.0.1] [--link]
  （批量转换见 convert_all.py；--link 以硬链接代替复制未改动的文件，仅为节省磁盘，内容不变）
"""
from __future__ import annotations

import argparse
import csv
import fnmatch
import json
import os
import re
import shlex
import shutil
import subprocess
import sys
from pathlib import Path

import yaml

HERE = Path(__file__).resolve().parent
RUNTIME = HERE / "runtime"
TEMPLATES = HERE / "templates"
IMAGE_CACHE = HERE / "image_configs.json"

HARBOR_SIDECARS = {"harbor-docker-egress-control-sidecar"}
HARBOR_VARS = {"TEST_DIR": "/tests"}
KEEPALIVE_RE = re.compile(r"^\s*(sleep\s+infinity|tail\s+-f\s+/dev/null)\s*$")

# 后端镜像族（按镜像名精确匹配，其余一律按 generic 处理）：
#   init    构建期以原镜像 entrypoint + 原 compose command/environment 完整跑一遍首次初始化
#           （建库、建用户、执行 /docker-entrypoint-initdb.d），数据目录随镜像固化
#   user    原 entrypoint 以 root 启动后降权（gosu/setpriv）到的用户。单镜像中直接以该用户运行，
#           跳过的只是“chown + 降权”这一步；None = 原容器即以镜像 USER（缺省 root）运行
#   datadir 构建期初始化后必须非空的数据目录（setup-image.sh 自检）
#   port    原 compose 无 healthcheck 时用于判断“已启动”的端口（命令行显式指定端口时以命令行为准）
BACKEND_FAMILIES = {
    "mysql":    {"init": True,  "user": "mysql",    "datadir": "/var/lib/mysql",           "port": 3306},
    "mariadb":  {"init": True,  "user": "mysql",    "datadir": "/var/lib/mysql",           "port": 3306},
    "postgres": {"init": True,  "user": "postgres", "datadir": "/var/lib/postgresql/data", "port": 5432},
    "mongo":    {"init": True,  "user": "mongodb",  "datadir": "/data/db",                 "port": 27017},
    "redis":    {"init": False, "user": "redis",    "datadir": None, "port": 6379},
    "couchdb":  {"init": False, "user": "couchdb",  "datadir": None, "port": 5984},
    "memcached": {"init": False, "user": None,      "datadir": None, "port": 11211},
    "registry": {"init": False, "user": None,       "datadir": None, "port": 5000},
    "openldap": {"init": False, "user": None,       "datadir": None, "port": 389},
    "docker-test-openldap": {"init": False, "user": None, "datadir": None, "port": 10389},
}
GENERIC_FAMILY = {"init": False, "user": None, "datadir": None, "port": None}
PORT_FLAGS = {
    "mysql": r"(?:--port[= ]|-P\s*)(\d+)",
    "mariadb": r"(?:--port[= ]|-P\s*)(\d+)",
    "postgres": r"(?:-p\s*|--port[= ]|-c\s*port=)(\d+)",
    "mongo": r"--port[= ](\d+)",
    "redis": r"--port\s+(\d+)",
    "memcached": r"(?:-p\s*|--port[= ])(\d+)",
}
# main 服务的运行权限（原 compose 中的特权设置）：转换后记录在 task.toml，并用于 build.sh 自检的 docker run
MAIN_PRIV_KEYS = ("privileged", "cap_add", "security_opt", "devices")

# 原题 tests/test.sh 的已知缺陷与最小修复。只收录审计记录（cve-verified-1497/manifest.csv）已注明、
# 修复后测试命令与判分语义不变的问题：(原文片段, 修复后片段, 说明)，原文片段须恰好出现一次。
KNOWN_TEST_FIXES = {
    "cve-2022-21685": [(
        'echo "=========================================\n\n_EXIT_CODE=$?',
        'echo "========================================="\n\n_EXIT_CODE=$?',
        "第 89 行 echo 缺右引号：bash 读到文件末尾报语法错误，判分语句从不执行、恒记 0；补上引号恢复原意"
        "（set -e 下 pytest 失败即退出记 0，全部通过记 1）",
    )],
}


class Unsupported(Exception):
    pass


# --------------------------------------------------------------------------- image configs
def image_config(ref: str) -> dict:
    cache = json.loads(IMAGE_CACHE.read_text()) if IMAGE_CACHE.exists() else {}
    if ref not in cache:
        if os.environ.get("PB_NO_PULL") == "1":
            raise Unsupported(f"image config not cached in image_configs.json: {ref}")

        def inspect():
            return subprocess.run(["docker", "image", "inspect", ref, "--format", "{{json .Config}}"],
                                  capture_output=True, text=True)
        r = inspect()
        if r.returncode != 0:
            subprocess.run(["docker", "pull", "-q", ref], check=True, stdout=sys.stderr)
            r = inspect()
        cfg = json.loads(r.stdout)
        cache[ref] = {k: cfg.get(k) for k in ("Entrypoint", "Cmd", "Env", "User", "WorkingDir", "Volumes")}
        IMAGE_CACHE.write_text(json.dumps(cache, indent=2, sort_keys=True) + "\n")
    return cache[ref]


# --------------------------------------------------------------------------- Dockerfile helpers
def dockerfile_directives(text: str) -> list[tuple[str, str]]:
    """(指令, 参数) 列表，处理续行与注释。"""
    out, buf = [], ""
    for line in text.splitlines():
        s = line.strip()
        if not buf and (not s or s.startswith("#")):
            continue
        if buf and (not s or s.startswith("#")):
            continue  # 续行中间的空行与注释行（与 BuildKit 一致，跳过）
        if s.endswith("\\"):
            buf += s[:-1] + " "
            continue
        buf += s
        m = re.match(r"(\w+)\s+(.*)", buf, re.S)
        if m:
            out.append((m.group(1).upper(), m.group(2).strip()))
        buf = ""
    return out


def parse_exec_or_shell(arg: str) -> list[str]:
    arg = arg.strip()
    if arg.startswith("["):
        return json.loads(arg)
    return ["/bin/sh", "-c", arg]


def parse_env(arg: str) -> list[str]:
    """ENV 指令 → ["K=V", ...]（支持 K=V 多对形式与旧式 `ENV K V`）。"""
    arg = arg.strip()
    head = arg.split(None, 1)
    if not head:
        return []
    if "=" in head[0]:
        try:
            return [t for t in shlex.split(arg) if "=" in t]
        except ValueError:
            return []
    k, _, v = arg.partition(" ")
    return [f"{k}={v.strip()}"]


def merge_env(base: list[str], over: list[str]) -> list[str]:
    keys = {kv.split("=", 1)[0] for kv in over}
    return [kv for kv in base if kv.split("=", 1)[0] not in keys] + list(over)


def final_stage_info(dockerfile: str) -> dict:
    """最终构建阶段的 base 与镜像配置（cmd: None = 继承 base；[] = 被本阶段的 ENTRYPOINT 清空）。"""
    dirs = dockerfile_directives(dockerfile)
    last_from = max(i for i, (k, _) in enumerate(dirs) if k == "FROM")
    base = [t for t in dirs[last_from][1].split() if not t.startswith("--")][0]
    info = {"base": base, "entrypoint": None, "cmd": None, "user": None, "workdir": None, "expose": [], "env": []}
    for k, v in dirs[last_from + 1:]:
        if k == "ENTRYPOINT":
            info["entrypoint"] = parse_exec_or_shell(v)
            info["cmd"] = []  # Dockerfile 语义：设置 ENTRYPOINT 会清空继承的 CMD
        elif k == "CMD":
            info["cmd"] = parse_exec_or_shell(v)
        elif k == "USER":
            info["user"] = v
        elif k == "WORKDIR":
            info["workdir"] = v if v.startswith("/") else str(Path(info["workdir"] or "/") / v)
        elif k == "EXPOSE":
            info["expose"] += [p.split("/")[0] for p in v.split()]
        elif k == "ENV":
            info["env"] = merge_env(info["env"], parse_env(v))
    return info


def dockerignored(env_dir: Path, rel: str) -> bool:
    """保守判断构建上下文中的 rel 是否被 environment/.dockerignore 排除（宁可误报，由报告暴露）。"""
    f = env_dir / ".dockerignore"
    if not f.exists():
        return False
    parts = rel.strip("/").split("/")
    ignored = False
    for raw in f.read_text(errors="replace").splitlines():
        pat = raw.strip()
        if not pat or pat.startswith("#"):
            continue
        neg = pat.startswith("!")
        pat = pat.lstrip("!").strip().strip("/")
        if any(fnmatch.fnmatchcase("/".join(parts[:i]), pat) for i in range(1, len(parts) + 1)):
            ignored = not neg
    return ignored


# --------------------------------------------------------------------------- compose helpers
def as_list_cmd(v) -> list[str] | None:
    if v is None:
        return None
    if isinstance(v, str):
        return shlex.split(v)
    return [str(x) for x in v]


def compose_env(v) -> list[str]:
    if not v:
        return []
    items = v if isinstance(v, list) else [f"{k}={'' if val is None else val}" for k, val in v.items()]
    out = []
    for kv in items:
        kv = str(kv)
        for var, val in HARBOR_VARS.items():
            kv = kv.replace("${%s}" % var, val).replace("$%s" % var, val)
        if "${" in kv:
            continue  # Harbor 注入的其它变量（CPUS/MEMORY 等），与服务运行无关
        out.append(kv)
    return out


def healthcheck(svc: dict) -> tuple[str, list[str], int]:
    hc = svc.get("healthcheck") or {}
    test = hc.get("test")
    timeout = 30
    if hc.get("timeout"):
        m = re.match(r"(\d+)s", str(hc["timeout"]))
        timeout = int(m.group(1)) if m else 30
    if not test or hc.get("disable"):
        return "", [], timeout
    if isinstance(test, str):
        return "CMD-SHELL", [test], timeout
    kind, rest = test[0], [str(x) for x in test[1:]]
    if kind == "CMD-SHELL":
        return "CMD-SHELL", [" ".join(rest)], timeout
    if kind == "CMD":
        return "CMD", rest, timeout
    return "", [], timeout


def family_of(image: str) -> str:
    name = image.split("@")[0].split("/")[-1].split(":")[0]
    return name if name in BACKEND_FAMILIES else "generic"


def backend_port(fam_name: str, argv: list[str], expose: list[str]) -> int | None:
    pat = PORT_FLAGS.get(fam_name)
    if pat:
        m = re.search(pat, " ".join(argv))
        if m:
            return int(m.group(1))
    port = BACKEND_FAMILIES.get(fam_name, GENERIC_FAMILY)["port"]
    if port:
        return port
    for p in expose:
        if p.isdigit():
            return int(p)
    return None


FROM_RE = re.compile(r"^(\s*FROM\s+)((?:--\S+\s+)*)(\S+)(\s+AS\s+\S+)?\s*$", re.I)


def inline_backend(env_dir: Path, sname: str, stage: str, build) -> dict:
    """原 compose 以 build 构建的后端：把其 Dockerfile 逐字内联为一个构建阶段（仅改 FROM 行的阶段名）。"""
    if isinstance(build, str):
        ctx, dfname, extra = build, "Dockerfile", {}
    else:
        ctx, dfname = build.get("context", "."), build.get("dockerfile", "Dockerfile")
        extra = {k: v for k, v in build.items() if k not in ("context", "dockerfile")}
    if extra:
        raise Unsupported(f"backend '{sname}' build options {sorted(extra)} not supported")
    if os.path.normpath(str(ctx)) != ".":
        raise Unsupported(f"backend '{sname}' build context '{ctx}' differs from environment/")
    text = (env_dir / dfname).read_text()
    kinds = [k for k, _ in dockerfile_directives(text)]
    if kinds.count("FROM") != 1 or kinds[0] != "FROM":
        raise Unsupported(f"backend '{sname}' {dfname} is multi-stage or has directives before FROM")
    out, done = [], False
    for line in text.rstrip("\n").splitlines():
        m = FROM_RE.match(line)
        if m and not done:
            line = f"{m.group(1)}{m.group(2)}{m.group(3)} AS {stage}"
            done = True
        out.append(line)
    if not done:
        raise Unsupported(f"backend '{sname}' {dfname}: FROM line not understood")
    return {"dockerfile": dfname, "text": "\n".join(out), "info": final_stage_info(text)}


def backend_mounts(env_dir: Path, sname: str, svc: dict) -> tuple[list[tuple[str, str]], list[str]]:
    """原 compose 给后端的挂载 → (构建期 COPY 的 bind 列表, 被忽略的命名卷列表)。"""
    binds, named = [], []
    for v in svc.get("volumes") or []:
        if isinstance(v, dict):
            typ, src, tgt = v.get("type", "volume"), v.get("source"), v.get("target")
        else:
            parts = str(v).split(":")
            if len(parts) == 1:
                typ, src, tgt = "volume", None, parts[0]
            else:
                src, tgt = parts[0], parts[1]
                typ = "bind" if src.startswith((".", "/", "~", "$")) else "volume"
        if typ == "volume":
            named.append(f"{src or '(anonymous)'}:{tgt}")
            continue
        if typ != "bind" or not src or not tgt:
            raise Unsupported(f"backend '{sname}' mount {v!r} not supported")
        if src.startswith(("/", "~", "$")):
            raise Unsupported(f"backend '{sname}' bind mount from outside environment/: {src}")
        p = (env_dir / src).resolve()
        try:
            rel = p.relative_to(env_dir.resolve()).as_posix()
        except ValueError:
            raise Unsupported(f"backend '{sname}' bind mount escapes environment/: {src}") from None
        if not p.exists():
            raise Unsupported(f"backend '{sname}' bind mount source missing: {src}")
        if dockerignored(env_dir, rel):
            raise Unsupported(f"backend '{sname}' bind mount source excluded by .dockerignore: {src}")
        if p.is_dir():
            binds.append((rel.rstrip("/") + "/", tgt.rstrip("/") + "/"))
        else:
            binds.append((rel, tgt))
    return binds, named


def backend_spec(env_dir: Path, sname: str, svc: dict) -> dict:
    key = re.sub(r"[^A-Za-z0-9_]", "_", sname)
    stage = f"pb-backend-{key.lower().replace('_', '-')}"
    inline, expose = None, []
    if "build" in svc:
        inline = inline_backend(env_dir, sname, stage, svc["build"])
        info = inline["info"]
        image = info["base"]
        cfg = dict(image_config(image))
        # 叠加该 Dockerfile 自身的镜像配置（Docker 的继承语义）
        if info["entrypoint"] is not None:
            cfg["Entrypoint"] = info["entrypoint"]
        if info["cmd"] is not None:
            cfg["Cmd"] = info["cmd"]
        if info["user"]:
            cfg["User"] = info["user"]
        if info["workdir"]:
            cfg["WorkingDir"] = info["workdir"]
        cfg["Env"] = merge_env(cfg.get("Env") or [], info["env"])
        expose = info["expose"]
        source = f"environment/{inline['dockerfile']}（原 compose build，逐字内联）"
    else:
        image = svc["image"]
        cfg = image_config(image)
        source = image
    fam_name = family_of(image)
    fam = BACKEND_FAMILIES.get(fam_name, GENERIC_FAMILY)
    entry = as_list_cmd(svc["entrypoint"]) if svc.get("entrypoint") is not None else (cfg.get("Entrypoint") or [])
    if svc.get("command") is not None:
        bcmd = as_list_cmd(svc["command"])
    elif svc.get("entrypoint") is not None:
        bcmd = []  # compose 语义：覆盖 entrypoint 会清空镜像 CMD
    else:
        bcmd = cfg.get("Cmd") or []
    cenv = compose_env(svc.get("environment"))
    env = merge_env(list(cfg.get("Env") or []), cenv)
    user = str(svc.get("user") or cfg.get("User") or fam["user"] or "root")
    hk, hv, ht = healthcheck(svc)
    if not hk:
        port = backend_port(fam_name, entry + bcmd, expose)
        hk, hv = ("TCP", [str(port)]) if port else ("NONE", [])
    binds, named = backend_mounts(env_dir, sname, svc)
    if any("\n" in x for x in cenv + entry + bcmd):
        raise Unsupported(f"backend '{sname}' has multi-line environment/command values")
    return {
        "name": sname, "key": key, "stage": stage, "image": image, "source": source, "inline": inline,
        "family": fam_name, "init": fam["init"], "datadir": fam["datadir"] if fam["init"] else None,
        "entry": entry, "cmd": bcmd, "env": env, "compose_env": cenv, "user": user,
        "workdir": cfg.get("WorkingDir") or "/", "health_kind": hk, "health": hv, "health_timeout": ht,
        "binds": binds, "named": named,
    }


def backend_stage(b: dict) -> list[str]:
    lines = [f"# ===== [patch-bundle] ① 后端 '{b['name']}' <- {b['source']}"]
    if b["inline"]:
        lines.append(b["inline"]["text"])
    else:
        lines.append(f"FROM {b['image']} AS {b['stage']}")
    if b["binds"]:
        lines.append("# 原 compose 挂载给该服务的文件（如 initdb 脚本），构建期放到原挂载点，内容逐字相同")
        lines += [f"COPY {json.dumps([s, t])}" for s, t in b["binds"]]
    if b["init"]:
        envs = " ".join(q(kv) for kv in b["compose_env"])
        argv = " ".join(q(x) for x in b["entry"] + b["cmd"])
        lines += [
            "# 构建期按原 environment/command 完成首次初始化，数据目录随镜像固化",
            "COPY pb/backend-init.sh /pb-backend-init.sh",
            f"RUN env {envs} /pb-backend-init.sh {b['family']} {argv} \\",
            "    && rm -f /pb-backend-init.sh",
        ]
    return lines + [""]


def docker_run_flags(main: dict) -> list[str]:
    flags = []
    if main.get("privileged"):
        flags.append("--privileged")
    for c in main.get("cap_add") or []:
        flags += ["--cap-add", str(c)]
    for s in main.get("security_opt") or []:
        s = str(s)
        k, sep, val = s.partition(":")
        if sep and "=" not in k:
            s = f"{k}={val}"  # compose 的 apparmor:unconfined 写法 → docker run 的 apparmor=unconfined
        flags += ["--security-opt", s]
    for d in main.get("devices") or []:
        flags += ["--device", str(d)]
    return flags


# --------------------------------------------------------------------------- bash emitters
def q(s: str) -> str:
    return shlex.quote(s)


def bash_array(name: str, items: list[str]) -> str:
    if not items:
        return f"{name}=()"
    return f"{name}=(\n" + "".join(f"  {q(x)}\n" for x in items) + ")"


# --------------------------------------------------------------------------- test.sh
PREAMBLE = """\
# >>> [patch-bundle] 平台适配（测试命令、依赖安装与判分逻辑均不改）：
#     判定前按原 compose 语义确保服务在运行（只启动未运行的服务，不重启已运行的服务）。
#     与原题一致，判定阶段联网，下方原有的 uv / pip 等安装步骤照原样在线执行。
mkdir -p /logs/verifier
if [ "$(id -u)" = 0 ]; then export HOME=/root; fi
if [ -x /opt/pb/ensure-services ]; then /opt/pb/ensure-services || true; fi
# <<< [patch-bundle]
"""


def patch_test_sh(text: str) -> tuple[str, list[str]]:
    """只插入平台适配前缀：放在原有兜底 trap 之后（保证中途退出仍记 0），无 trap 时放在 shebang 之后。"""
    lines = text.splitlines(keepends=True)
    out: list[str] = []
    inserted = False
    for line in lines:
        out.append(line)
        if not inserted and line.startswith("trap ") and "EXIT" in line:
            out.append(PREAMBLE)
            inserted = True
    if not inserted:
        out.insert(1 if out and out[0].startswith("#!") else 0, PREAMBLE)
    return "".join(out), ["插入平台适配前缀（建日志目录 + 判定前兜底拉起服务），其余逐字不变"]


# --------------------------------------------------------------------------- main conversion
def _copier(link: bool):
    """复制函数：link=True 时用硬链接（同一文件系统内，内容逐字相同），失败则退回复制。"""
    if not link:
        return shutil.copy2

    def _link(a, b):
        try:
            os.link(a, b)
        except OSError:
            shutil.copy2(a, b)
        return b
    return _link


def convert(src: Path, dst: Path, version: str, link: bool = False) -> dict:
    cve = src.name
    name = f"{cve}-patch"
    img_repo = name.replace("-", "_") + "_main"
    img_tag = f"{img_repo}:{version}"
    env_dir = src / "environment"

    compose = yaml.safe_load((env_dir / "docker-compose.yaml").read_text())
    services = compose.get("services", {})
    main = services["main"]
    orig_df = (env_dir / "Dockerfile").read_text()
    fs = final_stage_info(orig_df)
    base_cfg = image_config(fs["base"])

    report = {"task": cve, "bundle": name, "image": img_tag, "changes": [], "backends": [], "flags": []}

    if any(k in main for k in ("volumes", "ports", "network_mode")):
        raise Unsupported("main uses volumes/ports/network_mode; review manually")
    if dockerignored(env_dir, "pb/services.sh"):
        raise Unsupported("environment/.dockerignore would exclude the pb/ runtime directory")

    # ---- main service
    eff_entry = fs["entrypoint"] if fs["entrypoint"] is not None else (base_cfg.get("Entrypoint") or [])
    if main.get("entrypoint") is not None:
        eff_entry = as_list_cmd(main["entrypoint"]) or []
    cmd = as_list_cmd(main.get("command"))
    if cmd is None:
        cmd = fs["cmd"] if fs["cmd"] is not None else (base_cfg.get("Cmd") or [])
    joined = " ".join(cmd[2:]) if cmd[:2] in (["sh", "-c"], ["/bin/sh", "-c"], ["bash", "-c"], ["/bin/bash", "-c"]) else " ".join(cmd)
    has_main = not KEEPALIVE_RE.match(joined)
    main_cmd = eff_entry + cmd
    hk, hv, ht = healthcheck(main)
    if not hk and has_main:
        if fs["expose"]:
            hk, hv = "TCP", [fs["expose"][0]]
        else:
            hk, hv = "NONE", []
    workdir = main.get("working_dir") or fs["workdir"] or base_cfg.get("WorkingDir") or "/"
    main_user = str(fs["user"] or base_cfg.get("User") or "root")
    non_root = main_user.split(":")[0] not in ("root", "0")
    main_env = merge_env(list(base_cfg.get("Env") or []), fs["env"])
    explicit_home = next((kv.split("=", 1)[1] for kv in reversed(main_env) if kv.startswith("HOME=")), "")
    run_flags = docker_run_flags(main)
    priv = {k: main[k] for k in MAIN_PRIV_KEYS if main.get(k)}

    # ---- backends
    backends = []
    aliases: list[str] = []
    for sname, svc in services.items():
        if sname == "main" or sname in HARBOR_SIDECARS:
            continue
        b = backend_spec(env_dir, sname, svc)
        if any(x["key"] == b["key"] or x["stage"] == b["stage"] for x in backends):
            raise Unsupported(f"backend name collision after sanitising: {sname}")
        backends.append(b)
        aliases.append(sname)
        desc = f"{sname}: {b['source']}（{b['family']}，以 {b['user']} 身份 chroot 运行"
        desc += "，构建期初始化" if b["init"] else ""
        desc += f"，挂载文件 {len(b['binds'])} 个构建期放入" if b["binds"] else ""
        desc += f"，命名卷 {len(b['named'])} 个忽略（数据随镜像）" if b["named"] else ""
        report["backends"].append(desc + "）")
    for svc in services.values():
        for eh in (svc.get("extra_hosts") or []):
            host, _, ip = str(eh).partition(":")
            if ip == "127.0.0.1" and host not in aliases:
                aliases.append(host)
    if non_root and backends:
        raise Unsupported("main runs as a non-root USER and has backends; review manually")

    # ---- test.sh
    raw_test = (src / "tests/test.sh").read_text()
    fix_notes = []
    for before, after, why in KNOWN_TEST_FIXES.get(cve, []):
        if raw_test.count(before) != 1:
            raise Unsupported(f"known test.sh fix no longer applies: {why}")
        raw_test = raw_test.replace(before, after)
        fix_notes.append(f"原题缺陷最小修复：{why}")
    test_sh, test_notes = patch_test_sh(raw_test)
    test_notes += fix_notes
    if fix_notes:
        report["flags"].append("orig-test-fix")

    # ---- write bundle
    if dst.exists():
        shutil.rmtree(dst)
    (dst / "environment").mkdir(parents=True)
    cp = _copier(link)
    cp(src / "instruction.md", dst / "instruction.md")
    shutil.copytree(src / "solution", dst / "solution", copy_function=cp)
    shutil.copytree(src / "tests", dst / "tests", copy_function=cp)
    t = dst / "tests/test.sh"
    mode = t.stat().st_mode
    t.unlink()  # 先断开（可能是指向原题的硬链接），再写入新内容，原题文件不受影响
    t.write_text(test_sh)
    t.chmod(mode)
    for p in env_dir.iterdir():
        if p.name in ("Dockerfile", "docker-compose.yaml"):
            continue
        if p.is_dir():
            shutil.copytree(p, dst / "environment" / p.name, copy_function=cp)
        else:
            cp(p, dst / "environment" / p.name)

    pb = dst / "environment/pb"
    pb.mkdir()
    for f in ("ensure-services", "supervise", "init", "autostart.sh", "setup-image.sh", "backend-init.sh"):
        shutil.copy2(RUNTIME / f, pb / f)

    sv = [
        "# [patch-bundle] 由 convert_patch_bundle.py 依据原 docker-compose.yaml 生成，勿手改。",
        f"# 来源：cve-verified-1497/{cve}/environment/docker-compose.yaml",
        bash_array("PB_HOST_ALIASES", aliases),
        bash_array("PB_BACKENDS", [b["key"] for b in backends]),
    ]
    for b in backends:
        n = b["key"]
        sv += [
            f"# backend '{b['name']}' <- {b['source']}",
            f"PB_{n}_name={q(b['name'])}",
            f"PB_{n}_root={q('/opt/pb/backends/' + n)}",
            f"PB_{n}_user={q(b['user'])}",
            f"PB_{n}_workdir={q(b['workdir'])}",
            f"PB_{n}_datadir={q(b['datadir'] or '')}",
            bash_array(f"PB_{n}_env", b["env"]),
            bash_array(f"PB_{n}_cmd", b["entry"] + b["cmd"]),
            f"PB_{n}_health_kind={b['health_kind']}",
            bash_array(f"PB_{n}_health", b["health"]),
            f"PB_{n}_health_timeout={b['health_timeout']}",
        ]
    sv += [
        "# service 'main'（原 compose 的 command；镜像 ENTRYPOINT 已并入）",
        f"PB_MAIN={1 if has_main else 0}",
        f"PB_MAIN_USER={q(main_user)}",
        f"PB_MAIN_HOME={q(explicit_home)}",
        f"PB_main_workdir={q(workdir)}",
        bash_array("PB_main_cmd", main_cmd if has_main else []),
        f"PB_main_health_kind={hk or 'NONE'}",
        bash_array("PB_main_health", hv),
        f"PB_main_health_timeout={ht}",
        bash_array("PB_MAIN_COMPOSE_ENV", compose_env(main.get("environment"))),
    ]
    (pb / "services.sh").write_text("\n".join(sv) + "\n")

    # ---- Dockerfile
    df = [
        f"# [patch-bundle] {cve} 单镜像 patch bundle 的主镜像（= task.toml [environment].docker_image）。",
        "# 结构：①折叠的后端阶段（原 compose 后端镜像，构建期按原 environment 初始化）",
        "#       ②原 Dockerfile（逐字保留）  ③单镜像适配层（不触碰应用与漏洞代码）",
        "# 需 BuildKit（DOCKER_BUILDKIT=1，build.sh 已设置）。",
        "",
    ]
    for b in backends:
        df += backend_stage(b)
    df += [f"# ===== [patch-bundle] ② 原 Dockerfile（cve-verified-1497/{cve}/environment/Dockerfile，逐字保留）",
           orig_df.rstrip("\n"), "",
           "# ===== [patch-bundle] ③ 单镜像适配层"]
    if non_root:
        df.append("USER root")
    for b in backends:
        df.append(f"COPY --from={b['stage']} / /opt/pb/backends/{b['key']}/")
    df += [
        "COPY pb/ /opt/pb/",
        "RUN chmod +x /opt/pb/ensure-services /opt/pb/supervise /opt/pb/init /opt/pb/setup-image.sh \\",
        "    && /opt/pb/setup-image.sh",
    ]
    if has_main or backends:
        if eff_entry:
            df.append("ENTRYPOINT []")
        df += [
            "# 平台不执行镜像 CMD 时（OpenSandbox 默认入口为 tail -f /dev/null），由沙箱内第一条 bash 命令拉起服务",
            "ENV BASH_ENV=/opt/pb/autostart.sh",
            'CMD ["/opt/pb/init"]',
        ]
        report["changes"].append("服务拉起：镜像 CMD=/opt/pb/init；兜底 ENV BASH_ENV=/opt/pb/autostart.sh（首条 bash 命令同步拉起）")
    else:
        if eff_entry:
            df.append("ENTRYPOINT []")
        df.append("CMD " + json.dumps(cmd))
        report["changes"].append("本题无常驻服务：CMD 取原 compose 的 command（保活）")
    if non_root:
        df.append(f"USER {main_user}")
        report["flags"].append(f"non-root:{main_user}")
        report["changes"].append(f"镜像 USER 保持原题的 {main_user}；主服务以该用户运行（以 root 调用时降权）")
    (dst / "environment/Dockerfile").write_text("\n".join(df) + "\n")

    # ---- task.toml / build.sh / push.sh
    orig_toml = (src / "task.toml").read_text()
    meta_diff = re.search(r'difficulty\s*=\s*"([^"]+)"', orig_toml)
    meta_cat = re.search(r'category\s*=\s*"([^"]+)"', orig_toml)
    meta_tags = re.search(r"tags\s*=\s*\[(.*?)\]", orig_toml, re.S)
    tags = [x.strip().strip('"') for x in meta_tags.group(1).split(",") if x.strip()] if meta_tags else []
    v_to = re.search(r"\[verifier\][^\[]*?timeout_sec\s*=\s*([\d.]+)", orig_toml, re.S)
    a_to = re.search(r"\[agent\][^\[]*?timeout_sec\s*=\s*([\d.]+)", orig_toml, re.S)
    cpus = re.search(r"\bcpus\s*=\s*(\d+)", orig_toml)
    mem = re.search(r"memory_mb\s*=\s*(\d+)", orig_toml)
    expect = {"nop_pytest": "", "oracle_pytest": ""}
    manifest = src.parent / "manifest.csv"
    if manifest.exists():
        for row in csv.DictReader(manifest.open()):
            if row["task"] == cve:
                expect = row
                break
    extra_meta = ""
    if priv:
        extra_meta = (
            "# 原 docker-compose.yaml 中 main 服务的运行权限。平台须以同等权限启动沙箱（本地自检见 build.sh 的 RUN_FLAGS），\n"
            "# 否则漏洞的可触发条件或修复的可验证条件会改变。\n"
            f"sandbox_privileged = {'true' if priv.get('privileged') else 'false'}\n"
            f"sandbox_cap_add = {json.dumps([str(x) for x in priv.get('cap_add', [])])}\n"
            f"sandbox_security_opt = {json.dumps([str(x) for x in priv.get('security_opt', [])])}\n"
            f"sandbox_devices = {json.dumps([str(x) for x in priv.get('devices', [])])}\n"
        )
        report["flags"].append("privileged" if priv.get("privileged") else "cap_add")
        report["changes"].append("main 的特权设置记入 task.toml [metadata] sandbox_*，build.sh 自检以同等权限运行")
    subst = {
        "@@EXPECT_NOOP@@": expect.get("nop_pytest", ""), "@@EXPECT_ORACLE@@": expect.get("oracle_pytest", ""),
        "@@NAME@@": name, "@@CVE@@": cve, "@@CVE_UPPER@@": cve.upper(), "@@IMG_REPO@@": img_repo,
        "@@VER@@": version, "@@IMG_TAG@@": img_tag,
        "@@DIFFICULTY@@": meta_diff.group(1) if meta_diff else "medium",
        "@@CATEGORY@@": meta_cat.group(1) if meta_cat else "bug-fix",
        "@@TAGS@@": ", ".join(json.dumps(x) for x in tags),
        "@@KEYWORDS@@": ", ".join(json.dumps(x) for x in ["cve", cve, "patch", "vulnerability-repair"] + tags),
        "@@VERIFIER_TIMEOUT@@": v_to.group(1) if v_to else "1200.0",
        "@@AGENT_TIMEOUT@@": a_to.group(1) if a_to else "3600.0",
        "@@CPUS@@": cpus.group(1) if cpus else "2",
        "@@MEMORY_MB@@": mem.group(1) if mem else "4096",
        "@@EXTRA_METADATA@@\n": extra_meta,
        "@@RUN_FLAGS@@": " ".join(q(x) for x in run_flags),
    }
    for tpl, out, mode in (("task.toml", "task.toml", 0o644), ("build.sh", "build.sh", 0o755), ("push.sh", "push.sh", 0o755)):
        s = (TEMPLATES / tpl).read_text()
        for k, v in subst.items():
            s = s.replace(k, v)
        (dst / out).write_text(s)
        (dst / out).chmod(mode)

    for b in backends:
        if b["inline"]:
            report["flags"].append(f"inline-backend:{b['name']}")
        if b["binds"]:
            report["flags"].append(f"backend-files:{b['name']}={len(b['binds'])}")
        if b["family"] == "generic":
            report["flags"].append(f"generic-backend:{b['name']}")
    report["changes"] += [f"tests/test.sh：{n}" for n in test_notes]
    report["changes"].append("移除 environment/docker-compose.yaml（单镜像；服务定义已转为 environment/pb/services.sh）")
    report["main"] = {"enabled": has_main, "cmd": main_cmd if has_main else None, "health": [hk] + hv,
                      "workdir": workdir, "user": main_user}
    return report


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("src", type=Path)
    ap.add_argument("dst", type=Path)
    ap.add_argument("--version", default="v0.0.1")
    ap.add_argument("--link", action="store_true", help="hardlink unchanged files instead of copying")
    a = ap.parse_args()
    try:
        rep = convert(a.src.resolve(), a.dst.resolve(), a.version, link=a.link)
    except Unsupported as e:
        print(f"UNSUPPORTED {a.src.name}: {e}", file=sys.stderr)
        return 3
    print(json.dumps(rep, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
