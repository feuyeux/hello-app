#!/usr/bin/env bash
# 无 root 的 Linux 上补齐 GPUI / NSH 需要的开发包，并为本仓库的两个 Rust 示例
# 生成 .cargo/config.toml（含本机路径，故不入库）。
#
# 什么时候跑：新机器首次构建 hello-gpui / hello-nsh 之前跑一次。
#
# 原理（不需要 sudo）：
#   1) apt download 把缺的 -dev 包下到 ~/.local/sysroot/debs
#   2) dpkg-deb -x 解包进 ~/.local/sysroot/
#   3) 改 .pc 文件前缀指向 sysroot；悬空的 .so 符号链接改指系统真实库
#   4) 写 hello-gpui/.cargo/config.toml 与 hello-nsh/.cargo/config.toml 的 PKG_CONFIG_PATH
#
# 有 root 的机器：直接 apt install 这些包，本脚本检测到后只写 config。
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
sysroot="$HOME/.local/sysroot"
libdir="$sysroot/usr/lib/x86_64-linux-gnu"
pcdir="$libdir/pkgconfig"

NEEDED=(libgtk-4-dev libgraphene-1.0-dev libxkbcommon-x11-dev libvulkan-dev vulkan-validationlayers)
EXTRA=(libgraphene-1.0-0)

if ! command -v pkg-config >/dev/null; then
  echo "缺少 pkg-config，请先安装：" >&2
  echo "  sudo apt install pkg-config" >&2
  exit 1
fi

missing=()
for p in "${NEEDED[@]}"; do
  dpkg -s "$p" >/dev/null 2>&1 || missing+=("$p")
done

# 1) 系统包齐全则跳过解包
if [ ${#missing[@]} -eq 0 ]; then
  echo "» 系统开发包齐全，无需 sysroot"
elif [ -d "$pcdir" ]; then
  echo "» sysroot 已存在：$sysroot（如需重建先删掉它）"
else
  echo "» 补齐无 root sysroot：${missing[*]}"
  mkdir -p "$sysroot/debs"
  (
    cd "$sysroot/debs"
    apt-get update -qq >/dev/null 2>&1 || true
    for p in "${missing[@]}" "${EXTRA[@]}"; do apt download "$p" >/dev/null; done
    for d in *.deb; do dpkg-deb -x "$d" "$sysroot/"; done
  )
  # .pc 前缀指向 sysroot
  find "$pcdir" -name '*.pc' -exec sed -i \
    -e "s|^libdir=/usr|libdir=$sysroot/usr|" \
    -e "s|^includedir=/usr|includedir=$sysroot/usr|" \
    -e "s|^exec_prefix=/usr|exec_prefix=$sysroot/usr|" \
    -e "s|^prefix=/usr|prefix=$sysroot/usr|" {} +
  # 悬空的 .so 符号链接改指系统里的真实库
  (
    cd "$libdir"
    for l in *.so; do
      [ -e "$l" ] && continue
      t=$(readlink "$l")
      [ -e "/usr/lib/x86_64-linux-gnu/$t" ] && ln -sf "/usr/lib/x86_64-linux-gnu/$t" "$l"
    done
  )
  echo "  ✓ sysroot 就绪：$sysroot"
fi

# 2) 为两个 Rust 示例写 cargo 配置（本机路径，故不入库）
for app in hello-gpui hello-nsh; do
  mkdir -p "$root/$app/.cargo"
  cat >"$root/$app/.cargo/config.toml" <<EOF
# 由 tools/ensure-env.sh 生成 —— 无 root Linux 的 sysroot 路径。
# 有系统开发包的机器可整段删除。
[env]
PKG_CONFIG_PATH = "$pcdir"
EOF
  echo "  ✓ $app/.cargo/config.toml"
done

echo "» 完成。现在可以直接：cd hello-gpui && cargo run"
