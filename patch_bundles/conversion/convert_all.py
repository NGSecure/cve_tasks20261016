#!/usr/bin/env python3
"""批量转换：cve-verified-1497/<cve> → patch_bundles/tasks/<cve>-patch，并写出转换报告。

  python3 convert_all.py [--src ../../cve-verified-1497] [--out ../tasks] [--jobs 4] [--link] [--only cve-a,cve-b]

报告：patch_bundles/conversion_report.csv（每题一行：status = ok / unsupported / error 及原因）。
转换失败的题不会留下半成品目录。环境变量 PB_NO_PULL=1 时不为缺失的镜像配置执行 docker pull。
"""
from __future__ import annotations

import argparse
import csv
import json
import shutil
import sys
import traceback
from concurrent.futures import ProcessPoolExecutor
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import convert_patch_bundle as cv  # noqa: E402


def one(job):
    src, dst, version, link = job
    src, dst = Path(src), Path(dst)
    row = {"task": src.name, "bundle": dst.name, "status": "ok", "reason": "", "backends": "", "main_service": "",
           "base_image": "", "user": "", "flags": ""}
    try:
        fs = cv.final_stage_info((src / "environment/Dockerfile").read_text(errors="replace"))
        row["base_image"], row["user"] = fs["base"], fs["user"] or ""
        rep = cv.convert(src, dst, version, link=link)
        row["backends"] = ";".join(b.split(":")[0] + "=" + b.split(": ", 1)[1].split("（")[0] for b in rep["backends"])
        row["main_service"] = "yes" if rep["main"]["enabled"] else "no"
        row["user"] = rep["main"]["user"]
        row["flags"] = ";".join(rep["flags"])
    except cv.Unsupported as e:
        row["status"], row["reason"] = "unsupported", str(e)
    except Exception as e:  # noqa: BLE001
        row["status"], row["reason"] = "error", f"{type(e).__name__}: {e}"
        traceback.print_exc()
    if row["status"] != "ok" and dst.exists():
        shutil.rmtree(dst)
    return row


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--src", type=Path, default=HERE.parent.parent / "cve-verified-1497")
    ap.add_argument("--out", type=Path, default=HERE.parent / "tasks")
    ap.add_argument("--report", type=Path, default=HERE.parent / "conversion_report.csv")
    ap.add_argument("--version", default="v0.0.1")
    ap.add_argument("--jobs", type=int, default=4)
    ap.add_argument("--link", action="store_true")
    ap.add_argument("--only", default="")
    a = ap.parse_args()
    only = {x for x in a.only.split(",") if x}
    tasks = sorted(p for p in a.src.iterdir() if p.is_dir() and p.name.startswith("cve-") and (not only or p.name in only))
    a.out.mkdir(parents=True, exist_ok=True)
    jobs = [(str(t), str(a.out / f"{t.name}-patch"), a.version, a.link) for t in tasks]
    with ProcessPoolExecutor(a.jobs) as ex:
        rows = list(ex.map(one, jobs, chunksize=8))
    fields = ["task", "bundle", "status", "reason", "backends", "main_service", "base_image", "user", "flags"]
    if only and a.report.exists():  # 局部重跑：合并进已有报告
        old = {r["task"]: {k: r.get(k, "") for k in fields} for r in csv.DictReader(a.report.open())}
        old.update({r["task"]: r for r in rows})
        rows = [old[k] for k in sorted(old)]
    with a.report.open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        w.writerows(rows)
    st = {}
    for r in rows:
        st[r["status"]] = st.get(r["status"], 0) + 1
    print(json.dumps(st))
    return 0


if __name__ == "__main__":
    sys.exit(main())
