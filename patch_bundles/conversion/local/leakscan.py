#!/usr/bin/env python3
"""对已构建的 patch bundle 镜像做泄漏检查（本地自检工具，不随 bundle 分发）。

检查项：
  1. 镜像内是否残留 .git 目录（可能携带修复提交历史）；
  2. 镜像内是否存在隐藏测试 / 参考解（按文件名与内容指纹）；
  3. 修复指纹扫描：在断网容器里执行 solution/solve.sh，用 `docker diff` 找出参考解改动的文件，
     取“修复后新增、修复前不存在”的特征行，到原始镜像全盘 grep。命中位于转换新增内容
     （/opt/pb）即判为可疑；命中位于原题环境内的单独列出，供人工对照原题；
  4. 应用目录内的 *.orig / *.rej / *.patch / *.diff / *.bak 文件：转换新增的（/opt/pb）或内容涉及参考解所改文件的
     判为可疑；源码仓库自带、与修复无关的列入 patch_like_files_unrelated 备查。
用法：leakscan.py <bundle_dir>    结果打印为 JSON；发现可疑项时退出码为 1。
"""
from __future__ import annotations

import difflib
import hashlib
import json
import re
import subprocess
import sys
import tempfile
from pathlib import Path

EXCLUDE_DIRS = ["/proc", "/sys", "/dev", "/run", "/tmp", "/var/log", "/var/cache", "/var/lib/apt",
                "/logs", "/tests", "/solution", "/root/.cache", "/opt/pb/backends"]
GIT_ALLOW = ("/root/.cache/", "/usr/share/", "/opt/pb/backends/")


def sh(*args, check=True, **kw) -> str:
    r = subprocess.run(list(args), capture_output=True, text=True, **kw)
    if check and r.returncode != 0:
        raise RuntimeError(f"{args}: {r.stderr[-2000:]}")
    return r.stdout


def image_of(bundle: Path) -> str:
    text = (bundle / "build.sh").read_text()
    ver = re.search(r"^VER=(\S+)", text, re.M).group(1)
    img = re.search(r'^IMG="([^"]+)"', text, re.M).group(1)
    return img.replace("${VER}", ver)


def main() -> int:
    bundle = Path(sys.argv[1]).resolve()
    img = image_of(bundle)
    out: dict = {"bundle": bundle.name, "image": img, "suspicious": []}
    prune = " -o ".join(f"-path {d}" for d in EXCLUDE_DIRS)

    # 1) .git 目录
    gits = sh("docker", "run", "--rm", "--user", "root", "--network", "none", "--entrypoint", "sh", img, "-c",
              f"find / \\( {prune} \\) -prune -o -name .git -print 2>/dev/null").split()
    out["git_dirs"] = gits
    out["suspicious"] += [f".git dir: {g}" for g in gits if not g.startswith(GIT_ALLOW)]

    # 2) 隐藏测试 / 参考解：文件名 + 内容 sha256
    hidden = [p for p in list((bundle / "tests").rglob("*")) + list((bundle / "solution").rglob("*")) if p.is_file()]
    names = sorted({p.name for p in hidden if p.name not in ("test.sh",)})
    sums = {hashlib.sha256(p.read_bytes()).hexdigest(): str(p.relative_to(bundle)) for p in hidden}
    name_expr = " -o ".join(f"-name {n}" for n in names)
    found = sh("docker", "run", "--rm", "--user", "root", "--network", "none", "--entrypoint", "sh", img, "-c",
               f"find / \\( {prune} \\) -prune -o \\( {name_expr} \\) -type f -print 2>/dev/null").split()
    out["hidden_name_hits"] = found
    if found:
        got = sh("docker", "run", "--rm", "--user", "root", "--network", "none", "--entrypoint", "sha256sum", img, *found, check=False)
        for line in got.splitlines():
            h, _, path = line.partition("  ")
            if h in sums:
                out["suspicious"].append(f"hidden file present in image: {path} == {sums[h]}")

    # 3) 修复指纹扫描
    c = f"pbleak-{bundle.name}"
    subprocess.run(["docker", "rm", "-f", c], capture_output=True)
    sh("docker", "run", "-d", "--name", c, "--network", "none", "--entrypoint", "tail", img, "-f", "/dev/null")
    try:
        # 与平台一致：建目录、授权等准备步骤以 root 执行，solve.sh 以镜像默认用户（agent 用户）执行
        sh("docker", "exec", "-u", "root", c, "bash", "-c",
           "mkdir -p /logs/agent /logs/verifier /solution && chmod 777 /logs/agent /logs/verifier")
        sh("docker", "cp", f"{bundle}/solution/.", f"{c}:/solution/")
        sh("docker", "exec", "-u", "root", c, "chmod", "+x", "/solution/solve.sh")
        sh("docker", "exec", "-e", "DEBIAN_FRONTEND=noninteractive", c, "bash", "-c",
           "/solution/solve.sh > /logs/agent/oracle.txt 2>&1", check=False)
        changed = []
        for line in sh("docker", "diff", c).splitlines():
            kind, path = line.split(" ", 1)
            if kind != "C" or any(path == d or path.startswith(d + "/") for d in EXCLUDE_DIRS):
                continue
            if re.search(r"(\.pyc|\.o|\.lo|\.a|\.so[.\d]*|\.bak|/__pycache__.*|\.pid|\.sock|\.log)$", path):
                continue
            changed.append(path)
        sigs: dict[str, str] = {}
        diffs = {}
        for path in changed:
            new = subprocess.run(["docker", "exec", "-u", "root", c, "cat", path], capture_output=True)
            old = subprocess.run(["docker", "run", "--rm", "--user", "root", "--network", "none", "--entrypoint", "cat", img, path],
                                 capture_output=True)
            if new.returncode or old.returncode or b"\0" in new.stdout[:4096] or b"\0" in old.stdout[:4096]:
                continue
            a = old.stdout.decode("utf-8", "replace").splitlines()
            b = new.stdout.decode("utf-8", "replace").splitlines()
            olds = {x.strip() for x in a}
            added = [x.strip() for x in b if x.strip() not in olds]
            if not added:
                continue
            diffs[path] = len(list(difflib.unified_diff(a, b, lineterm="")))
            for x in added:
                if len(re.sub(r"\W", "", x)) >= 16:
                    sigs.setdefault(x, path)
        out["oracle_changed_files"] = diffs
        out["fix_signatures"] = len(sigs)
        hits = {}
        if sigs:
            with tempfile.NamedTemporaryFile("w", delete=False, suffix=".pat") as f:
                f.write("\n".join(sigs) + "\n")
                pat = f.name
            excl = " ".join(f"--exclude-dir={d.lstrip('/').split('/')[-1]}" for d in ("/proc", "/sys", "/dev"))
            r = subprocess.run(["docker", "run", "--rm", "--user", "root", "--network", "none", "-v", f"{pat}:/pb.pat:ro",
                                "--entrypoint", "sh", img, "-c",
                                f"grep -rIlF {excl} -f /pb.pat / 2>/dev/null"], capture_output=True, text=True)
            for path in r.stdout.split():
                if path in changed or path == "/pb.pat":
                    continue
                hits[path] = True
            Path(pat).unlink()
        # 只有转换新增的内容（/opt/pb）里的命中才归因于转换；其余命中位于原题环境内，
        # 常见于“修复照抄同库中已正确实现的检查”，需人工对照原题确认（原题设计的一部分，不是转换引入）。
        ours = ("/opt/pb/",)
        out["fix_signature_hits_introduced"] = sorted(p for p in hits if p.startswith(ours))
        out["fix_signature_hits_preexisting"] = sorted(p for p in hits if not p.startswith(ours))
        out["suspicious"] += [f"fix signature in content added by conversion: {p}"
                              for p in out["fix_signature_hits_introduced"]]
    finally:
        subprocess.run(["docker", "rm", "-f", c], capture_output=True)

    # 4) 应用目录里的补丁 / 备份文件
    leftovers = sh("docker", "run", "--rm", "--user", "root", "--network", "none", "--entrypoint", "sh", img, "-c",
                   f"find / \\( {prune} -o -path /usr -o -path /etc -o -path /var/lib/dpkg \\) -prune -o -type f "
                   "\\( -name '*.orig' -o -name '*.rej' -o -name '*.patch' -o -name '*.diff' -o -name '*.bak' \\) -print "
                   "2>/dev/null").split()
    out["patch_like_files"] = leftovers
    # 源码仓库常自带与本题无关的 .patch/.diff（如 doc/、patches/ 下的历史补丁）：只有转换新增的（/opt/pb），
    # 或内容涉及参考解所改文件的，才判为可疑；其余单独列出备查。
    fixed = {Path(p).name for p in out.get("oracle_changed_files", {})}
    related, unrelated = [], []
    for p in leftovers:
        if p.startswith("/opt/pb/"):
            related.append(p)
            continue
        r = subprocess.run(["docker", "run", "--rm", "--user", "root", "--network", "none", "--entrypoint", "cat", img, p],
                           capture_output=True)
        text = r.stdout.decode("utf-8", "replace")
        touched = {Path(m.split()[0]).name for m in re.findall(r"^(?:\+\+\+|---|Index:|diff --git a/)\s*(\S+)", text, re.M)}
        if r.returncode or not fixed or touched & fixed or any(f in text for f in fixed if len(f) >= 6):
            related.append(p)
        else:
            unrelated.append(p)
    out["patch_like_files_unrelated"] = unrelated
    out["suspicious"] += [f"patch/backup file: {p}" for p in related]

    print(json.dumps(out, ensure_ascii=False, indent=2))
    return 1 if out["suspicious"] else 0


if __name__ == "__main__":
    sys.exit(main())
