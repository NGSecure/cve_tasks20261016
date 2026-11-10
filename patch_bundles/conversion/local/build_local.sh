#!/usr/bin/env bash
# 仅用于“出网经 TLS 中间人代理”的受限构建环境（例如本仓库的云端开发沙箱）：
# 在临时构建上下文里给每个构建阶段注入代理 CA（仅构建期 ARG 生效，不写入镜像 ENV），
# 用 host 网络与代理构建，产出与 build.sh 同名的本地镜像，随后可 `SKIP_BUILD=1 bash build.sh` 自检。
# 普通公网环境请直接用 bundle 自带的 build.sh，不需要本脚本；推送的镜像也不应由本脚本构建。
#   用法：build_local.sh <bundle_dir> [ca_bundle]
set -euo pipefail
B="$(cd "$1" && pwd)"
CA="${2:-${SSL_CERT_FILE:-/etc/ssl/certs/ca-certificates.crt}}"
IMG="$(grep -m1 '^IMG=' "$B/build.sh" | sed -E 's/^IMG="?([^"]+)"?.*/\1/')"
VER="$(grep -m1 '^VER=' "$B/build.sh" | cut -d= -f2)"
IMG="${IMG//\$\{VER\}/$VER}"
CTX="$(mktemp -d "${TMPDIR:-/tmp}/pb-ctx.XXXXXX")"
trap 'rm -rf "$CTX"' EXIT
cp -a "$B/environment/." "$CTX/"
cp "$CA" "$CTX/pb-local-ca.crt"
python3 - "$CTX/Dockerfile" <<'PY'
import re, sys
p = sys.argv[1]
ca = "/usr/local/share/pb-local-ca.crt"
inject = ["COPY pb-local-ca.crt " + ca] + [
    "ARG %s=%s" % (v, ca) for v in
    ("SSL_CERT_FILE", "CURL_CA_BUNDLE", "GIT_SSL_CAINFO", "PIP_CERT", "REQUESTS_CA_BUNDLE", "NODE_EXTRA_CA_CERTS")]
out = []
for line in open(p).read().splitlines():
    out.append(line)
    if re.match(r"^\s*FROM\s", line, re.I):
        out += inject
open(p, "w").write("\n".join(out) + "\n")
PY
echo "==> local build $IMG (CA-injected context $CTX)"
DOCKER_BUILDKIT=1 docker build --network host \
  --build-arg https_proxy="${https_proxy:-}" --build-arg HTTPS_PROXY="${HTTPS_PROXY:-}" \
  --build-arg no_proxy="${no_proxy:-}" --build-arg NO_PROXY="${NO_PROXY:-}" \
  -t "$IMG" -f "$CTX/Dockerfile" "$CTX"
echo "built $IMG"
