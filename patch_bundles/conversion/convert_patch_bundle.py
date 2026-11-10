#!/usr/bin/env python3
"""把 cve-verified-1497 里的 Harbor「打 patch」题目转换为新平台单镜像 patch bundle。

原则（不改变题目的难度与考察点）：
  * instruction.md、solution/、tests/test_*.py、漏洞代码与版本、原 Dockerfile 全部逐字保留；
  * 只改运行环境与判分管道：
      - 原 compose 的后端服务（如 mysql:5.7）按原镜像 rootfs 折叠进主镜像，构建期按原 environment 初始化；
      - 原 compose 的 main command / healthcheck / depends_on / restart 语义由 /opt/pb/ensure-services 复现；
      - tests/test.sh 只加平台适配前缀（离线依赖 + 服务兜底拉起）并给 uv 安装行加“已安装则跳过”守卫；
  * 生成 build.sh（构建 + 自检 Noop=0/Oracle=1）与 push.sh（直推 SWR + 回填 task.toml）。

用法：
  python3 convert_patch_bundle.py <原任务目录> <输出 bundle 目录> [--version v0.0.1]
"""
from __future__ import annotations

import argparse
import json
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

# 后端镜像族：构建期初始化就绪判据、运行身份（原 entrypoint 以 gosu 降权到该用户）、数据目录
BACKEND_FAMILIES = {
    "mysql": {"user": "mysql", "datadir": "/var/lib/mysql"},
    "mariadb": {"user": "mysql", "datadir": "/var/lib/mysql"},
    "postgres": {"user": "postgres", "datadir": "/var/lib/postgresql/data"},
}


class Unsupported(Exception):
    pass


# --------------------------------------------------------------------------- image configs
def image_config(ref: str) -> dict:
    cache = json.loads(IMAGE_CACHE.read_text()) if IMAGE_CACHE.exists() else {}
    if ref not in cache:
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


def final_stage_info(dockerfile: str) -> dict:
    dirs = dockerfile_directives(dockerfile)
    last_from = max(i for i, (k, _) in enumerate(dirs) if k == "FROM")
    base = dirs[last_from][1].split()[0]
    info = {"base": base, "entrypoint": None, "cmd": None, "user": None, "workdir": None, "expose": []}
    for k, v in dirs[last_from + 1:]:
        if k == "ENTRYPOINT":
            info["entrypoint"] = parse_exec_or_shell(v)
            info["cmd"] = None  # Dockerfile 语义：设置 ENTRYPOINT 会清空继承的 CMD
        elif k == "CMD":
            info["cmd"] = parse_exec_or_shell(v)
        elif k == "USER":
            info["user"] = v
        elif k == "WORKDIR":
            info["workdir"] = v if v.startswith("/") else str(Path(info["workdir"] or "/") / v)
        elif k == "EXPOSE":
            info["expose"] += [p.split("/")[0] for p in v.split()]
    return info


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
    name = image.split("/")[-1].split(":")[0].split("@")[0]
    for fam in BACKEND_FAMILIES:
        if name == fam or name.startswith(fam):
            return fam
    raise Unsupported(f"backend image family not supported yet: {image}")


# --------------------------------------------------------------------------- bash emitters
def q(s: str) -> str:
    return shlex.quote(s)


def bash_array(name: str, items: list[str]) -> str:
    if not items:
        return f"{name}=()"
    return f"{name}=(\n" + "".join(f"  {q(x)}\n" for x in items) + ")"


# --------------------------------------------------------------------------- test.sh
PREAMBLE = """\
# >>> [patch-bundle] 平台适配（不改测试命令与判分逻辑）：
#     ① 判定前按原 compose 语义确保服务在运行（只启动未运行的服务，不重启已运行的服务）；
#     ② 使用镜像内预装的 uv 0.7.13 与预热缓存，离线安装测试依赖。
mkdir -p /logs/verifier
if [ "$(id -u)" = 0 ]; then export HOME=/root; fi
export PATH="$HOME/.local/bin:$PATH" UV_OFFLINE=1
if [ -x /opt/pb/ensure-services ]; then /opt/pb/ensure-services || true; fi
# <<< [patch-bundle]
"""

UV_INSTALL_RE = re.compile(r"^(\s*)(curl\s+[^|]*astral\.sh/uv/[^|]*\|\s*sh\b.*)$")


def patch_test_sh(text: str) -> tuple[str, list[str], list[str]]:
    lines = text.splitlines(keepends=True)
    notes: list[str] = []
    out: list[str] = []
    inserted = False
    guarded_by_if = False
    for i, line in enumerate(lines):
        if re.match(r"\s*if\s+!\s+command\s+-v\s+uv", line):
            guarded_by_if = True
        m = UV_INSTALL_RE.match(line)
        if m and not guarded_by_if and "command -v uv" not in line:
            line = f"{m.group(1)}command -v uv >/dev/null 2>&1 || {m.group(2)}" + ("\n" if line.endswith("\n") else "")
            notes.append("uv 安装行加守卫：已预装则跳过（避免判定期依赖外网）")
        out.append(line)
        if not inserted and line.startswith("trap ") and "EXIT" in line:
            out.append(PREAMBLE)
            inserted = True
    if not inserted:
        # 无兜底 trap 时插在 shebang 之后
        out.insert(1 if out and out[0].startswith("#!") else 0, PREAMBLE)
    notes.insert(0, "插入平台适配前缀（服务兜底拉起 + 离线依赖）")
    uv_sets = []
    for line in text.splitlines():
        m = re.match(r"\s*uv\s+add\s+(.+?)\s*(2>.*)?$", line)
        if m:
            uv_sets.append(" ".join(t for t in shlex.split(m.group(1)) if not t.startswith("-")))
    return "".join(out), notes, uv_sets


# --------------------------------------------------------------------------- main conversion
def convert(src: Path, dst: Path, version: str) -> dict:
    cve = src.name
    name = f"{cve}-patch"
    img_repo = name.replace("-", "_") + "_main"
    img_tag = f"{img_repo}:{version}"

    compose = yaml.safe_load((src / "environment/docker-compose.yaml").read_text())
    services = compose.get("services", {})
    main = services["main"]
    orig_df = (src / "environment/Dockerfile").read_text()
    fs = final_stage_info(orig_df)
    base_cfg = image_config(fs["base"])

    report = {"task": cve, "bundle": name, "image": img_tag, "changes": [], "backends": []}

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

    # ---- backends
    backends = []
    aliases: list[str] = []
    for sname, svc in services.items():
        if sname == "main" or sname in HARBOR_SIDECARS:
            continue
        if "image" not in svc or "build" in svc:
            raise Unsupported(f"backend '{sname}' is built from source; not supported in the pilot")
        image = svc["image"]
        fam = family_of(image)
        cfg = image_config(image)
        entry = as_list_cmd(svc["entrypoint"]) if svc.get("entrypoint") is not None else (cfg.get("Entrypoint") or [])
        bcmd = as_list_cmd(svc["command"]) if svc.get("command") is not None else (cfg.get("Cmd") or [])
        env = list(cfg.get("Env") or [])
        cenv = compose_env(svc.get("environment"))
        keys = {kv.split("=", 1)[0] for kv in cenv}
        env = [kv for kv in env if kv.split("=", 1)[0] not in keys] + cenv
        user = cfg.get("User") or BACKEND_FAMILIES[fam]["user"]
        bk, bv, bt = healthcheck(svc)
        if not bk:
            raise Unsupported(f"backend '{sname}' has no healthcheck")
        backends.append({
            "name": sname, "image": image, "family": fam, "entry": entry, "cmd": bcmd, "env": env,
            "compose_env": cenv, "user": user, "workdir": cfg.get("WorkingDir") or "/",
            "health_kind": bk, "health": bv, "health_timeout": bt,
            "datadir": BACKEND_FAMILIES[fam]["datadir"],
        })
        aliases.append(sname)
        report["backends"].append(f"{sname}: {image}（{fam}，以 {user} 身份 chroot 运行）")
    for svc in services.values():
        for eh in (svc.get("extra_hosts") or []):
            host, _, ip = str(eh).partition(":")
            if ip == "127.0.0.1" and host not in aliases:
                aliases.append(host)
    if any(k in main for k in ("volumes", "ports", "network_mode", "privileged", "cap_add")):
        raise Unsupported("main uses volumes/ports/network_mode/privileged/cap_add; review manually")

    # ---- test.sh
    test_sh, test_notes, uv_sets = patch_test_sh((src / "tests/test.sh").read_text())

    # ---- write bundle
    if dst.exists():
        shutil.rmtree(dst)
    (dst / "environment").mkdir(parents=True)
    shutil.copy2(src / "instruction.md", dst / "instruction.md")
    shutil.copytree(src / "solution", dst / "solution")
    shutil.copytree(src / "tests", dst / "tests")
    (dst / "tests/test.sh").write_text(test_sh)
    for p in (src / "environment").iterdir():
        if p.name in ("Dockerfile", "docker-compose.yaml"):
            continue
        (shutil.copytree if p.is_dir() else shutil.copy2)(p, dst / "environment" / p.name)

    pb = dst / "environment/pb"
    pb.mkdir()
    for f in ("ensure-services", "supervise", "init", "autostart.sh", "setup-image.sh", "backend-init.sh"):
        shutil.copy2(RUNTIME / f, pb / f)

    sv = [
        "# [patch-bundle] 由 convert_patch_bundle.py 依据原 docker-compose.yaml 生成，勿手改。",
        f"# 来源：cve-verified-1497/{cve}/environment/docker-compose.yaml",
        bash_array("PB_HOST_ALIASES", aliases),
        bash_array("PB_BACKENDS", [b["name"] for b in backends]),
    ]
    for b in backends:
        n = b["name"]
        sv += [
            f"# backend '{n}' <- {b['image']}",
            f"PB_{n}_root={q('/opt/pb/backends/' + n)}",
            f"PB_{n}_user={q(b['user'])}",
            f"PB_{n}_workdir={q(b['workdir'])}",
            f"PB_{n}_datadir={q(b['datadir'])}",
            bash_array(f"PB_{n}_env", b["env"]),
            bash_array(f"PB_{n}_cmd", b["entry"] + b["cmd"]),
            f"PB_{n}_health_kind={b['health_kind']}",
            bash_array(f"PB_{n}_health", b["health"]),
            f"PB_{n}_health_timeout={b['health_timeout']}",
        ]
    sv += [
        "# service 'main'（原 compose 的 command；镜像 ENTRYPOINT 已并入）",
        f"PB_MAIN={1 if has_main else 0}",
        f"PB_main_workdir={q(workdir)}",
        bash_array("PB_main_cmd", main_cmd if has_main else []),
        f"PB_main_health_kind={hk or 'NONE'}",
        bash_array("PB_main_health", hv),
        f"PB_main_health_timeout={ht}",
        bash_array("PB_MAIN_COMPOSE_ENV", compose_env(main.get("environment"))),
        "# tests/test.sh 中的 `uv add` 依赖集合（构建期据此预热 uv 缓存）",
        bash_array("PB_UV_ADD_SETS", uv_sets),
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
        envs = " ".join(q(kv) for kv in b["compose_env"])
        argv = " ".join(q(x) for x in b["entry"] + b["cmd"])
        df += [
            f"# ===== [patch-bundle] ① 后端 '{b['name']}' <- {b['image']}（原 compose 服务，原 environment/command）",
            f"FROM {b['image']} AS pb-backend-{b['name']}",
            "COPY pb/backend-init.sh /pb-backend-init.sh",
            f"RUN env {envs} /pb-backend-init.sh {b['family']} {argv} \\",
            "    && rm -f /pb-backend-init.sh",
            "",
        ]
    df += [f"# ===== [patch-bundle] ② 原 Dockerfile（cve-verified-1497/{cve}/environment/Dockerfile，逐字保留）",
           orig_df.rstrip("\n"), "",
           "# ===== [patch-bundle] ③ 单镜像适配层"]
    if fs["user"] and fs["user"] not in ("root", "0"):
        df.append("USER root")
    for b in backends:
        df.append(f"COPY --from=pb-backend-{b['name']} / /opt/pb/backends/{b['name']}/")
    df += [
        "COPY pb/ /opt/pb/",
        "# 构建网络受限时可通过 --build-arg 指定镜像源（未传则不生效）",
        "ARG UV_PYTHON_INSTALL_MIRROR",
        "ARG UV_DEFAULT_INDEX",
        "ARG UV_INSTALLER_GITHUB_BASE_URL",
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
    if fs["user"] and fs["user"] not in ("root", "0"):
        df.append(f"USER {fs['user']}")
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
        import csv
        for row in csv.DictReader(manifest.open()):
            if row["task"] == cve:
                expect = row
                break
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
    }
    for tpl, out, mode in (("task.toml", "task.toml", 0o644), ("build.sh", "build.sh", 0o755), ("push.sh", "push.sh", 0o755)):
        s = (TEMPLATES / tpl).read_text()
        for k, v in subst.items():
            s = s.replace(k, v)
        (dst / out).write_text(s)
        (dst / out).chmod(mode)

    report["changes"] += [f"tests/test.sh：{n}" for n in test_notes]
    report["changes"].append("移除 environment/docker-compose.yaml（单镜像；服务定义已转为 environment/pb/services.sh）")
    report["uv_add_sets"] = uv_sets
    report["main"] = {"enabled": has_main, "cmd": main_cmd if has_main else None, "health": [hk] + hv, "workdir": workdir}
    return report


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("src", type=Path)
    ap.add_argument("dst", type=Path)
    ap.add_argument("--version", default="v0.0.1")
    a = ap.parse_args()
    try:
        rep = convert(a.src.resolve(), a.dst.resolve(), a.version)
    except Unsupported as e:
        print(f"UNSUPPORTED {a.src.name}: {e}", file=sys.stderr)
        return 3
    print(json.dumps(rep, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
