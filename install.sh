#!/usr/bin/env bash
# install.sh —— 把本仓库的配置安装到 $HOME
#
#   ./install.sh            # 只拷贝配置（已存在的文件会先备份）
#   ./install.sh --fonts    # 顺带下载安装字体
#   ./install.sh --zsh      # 顺带安装 oh-my-zsh / powerlevel10k / 插件
#   ./install.sh --extras   # 以上两个都做
#
# 安装位置（逐个文件拷贝，不会删掉你同目录下的其它文件）：
#   config/*                → ~/.config/
#   home/*                  → ~/            (.zshrc / .p10k.zsh)
#   local/bin/niri-profile  → ~/.local/bin/
#   local/share/...         → ~/.local/share/
#   wallpapers/*.png        → ~/Pictures/Wallpapers/   (已存在则不覆盖)

set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
HAD_BACKUP=0

backup() {  # 备份已存在的文件/目录
    local d="$1"
    [ -e "$d" ] || [ -L "$d" ] || return 0
    local rel="${d#"$HOME"/}"
    mkdir -p "$BACKUP/$(dirname "$rel")"
    cp -a "$d" "$BACKUP/$rel"
    HAD_BACKUP=1
}

put_file() {  # put_file <源文件> <目标文件>
    local s="$1" d="$2"
    backup "$d"
    mkdir -p "$(dirname "$d")"
    cp -a "$s" "$d"
    echo "  + ${d#"$HOME"/}"
}

put_dir() {   # put_dir <源目录> <目标目录>（整目录替换）
    local s="$1" d="$2"
    backup "$d"
    rm -rf "$d"
    mkdir -p "$(dirname "$d")"
    cp -a "$s" "$d"
    echo "  + ${d#"$HOME"/}/  (目录)"
}

echo "==> 备份目录（如有覆盖）: $BACKUP"

echo "==> niri"
put_file "$SRC/config/niri/config.kdl"   "$HOME/.config/niri/config.kdl"
put_file "$SRC/config/niri/noctalia.kdl" "$HOME/.config/niri/noctalia.kdl"

echo "==> Noctalia"
put_file "$SRC/config/noctalia/config.toml"              "$HOME/.config/noctalia/config.toml"
put_file "$SRC/config/noctalia/palettes/KoruFern.json"   "$HOME/.config/noctalia/palettes/KoruFern.json"

echo "==> kitty"
put_file "$SRC/config/kitty/kitty.conf"              "$HOME/.config/kitty/kitty.conf"
put_file "$SRC/config/kitty/themes/noctalia.conf"    "$HOME/.config/kitty/themes/noctalia.conf"

echo "==> fcitx5"
put_file "$SRC/config/fcitx5/conf/classicui.conf"    "$HOME/.config/fcitx5/conf/classicui.conf"
put_dir  "$SRC/local/share/fcitx5/themes/koru-fern"  "$HOME/.local/share/fcitx5/themes/koru-fern"

echo "==> fontconfig"
put_file "$SRC/config/fontconfig/fonts.conf"         "$HOME/.config/fontconfig/fonts.conf"

echo "==> 截图 / VSCode"
put_file "$SRC/config/mark-shot/config.json"         "$HOME/.config/mark-shot/config.json"
put_file "$SRC/config/code-flags.conf"               "$HOME/.config/code-flags.conf"

echo "==> zsh"
put_file "$SRC/home/.zshrc"                          "$HOME/.zshrc"
put_file "$SRC/home/.p10k.zsh"                       "$HOME/.p10k.zsh"

echo "==> mise"
put_file "$SRC/config/mise/config.toml"              "$HOME/.config/mise/config.toml"

echo "==> niri-profile（桌面档案切换脚本，Mod+Alt+W 用）"
put_file "$SRC/local/bin/niri-profile"               "$HOME/.local/bin/niri-profile"
chmod +x "$HOME/.local/bin/niri-profile"

echo "==> 壁纸"
mkdir -p "$HOME/Pictures/Wallpapers"
for w in "$SRC"/wallpapers/*.png; do
    name="$(basename "$w")"
    if [ -e "$HOME/Pictures/Wallpapers/$name" ]; then
        echo "  = ~/Pictures/Wallpapers/$name (已存在，跳过)"
    else
        cp -a "$w" "$HOME/Pictures/Wallpapers/$name"
        echo "  + ~/Pictures/Wallpapers/$name"
    fi
done

for arg in "$@"; do
    case "$arg" in
        --fonts|--extras) echo "==> 字体"; "$SRC/fonts/install-fonts.sh" ;;
        --zsh|--extras)   echo "==> zsh 环境"; "$SRC/zsh/install-zsh.sh" ;;
    esac
done

echo
echo "==> 配置安装完成！"
[ "$HAD_BACKUP" = 1 ] && echo "    原文件备份在: $BACKUP"
echo
echo "接下来（需要你自己执行）："
echo "  1) 装依赖（见 README.md『依赖』一节）"
echo "  2) 装字体:            ./fonts/install-fonts.sh"
echo "  3) 装 zsh 环境:       ./zsh/install-zsh.sh"
echo "  4) 刷新字体缓存:      fc-cache -f"
echo "  5) 设壁纸:            noctalia msg wallpaper-set \"\$HOME/Pictures/Wallpapers/koru-logo.png\""
echo "  6) 重新登录（或重启 Noctalia / niri）让配置生效"
