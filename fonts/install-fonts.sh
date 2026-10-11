#!/usr/bin/env bash
# install-fonts.sh —— 安装本配置用到的字体到 ~/.local/share/fonts（无需 root、不改系统）
#
# 包含：
#   6 个 Nerd Font（ryanoasis/nerd-fonts 的补丁版）
#   + LXGW Neo Xi Hei Plus（霞鹜新晰黑＋，中文 CJK 回退字体）
#
# 依赖：curl、unzip、fontconfig(fc-cache)

set -euo pipefail

DEST="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
mkdir -p "$DEST"

NERD_FONTS=(
    FiraCode               # 唯一「正在使用」的等宽字体：kitty 终端
    FantasqueSansMono      # fontconfig 里 monospace 的首选
    CommitMono
    Go-Mono
    ComicShannsMono
    GoogleSansCode
)

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

for f in "${NERD_FONTS[@]}"; do
    echo ">> 下载 Nerd Font: $f"
    curl -fL --retry 3 --retry-delay 2 \
        -o "$TMP/$f.zip" \
        "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$f.zip"
    mkdir -p "$DEST/$f"
    unzip -oq "$TMP/$f.zip" -d "$DEST/$f"
done

echo ">> 下载 CJK 字体: LXGW Neo Xi Hei Plus"
mkdir -p "$DEST/LXGWNeoXiHeiPlus"
curl -fL --retry 3 --retry-delay 2 \
    -o "$DEST/LXGWNeoXiHeiPlus/LXGWNeoXiHeiPlus.ttf" \
    "https://github.com/lxgw/LxgwNeoXiHei/releases/latest/download/LXGWNeoXiHeiPlus.ttf"

echo ">> 刷新字体缓存"
fc-cache -f "$DEST"

echo
echo "完成。已安装到: $DEST"
echo "验证：fc-list | grep -i 'Nerd Font'"
