#!/usr/bin/env bash
# install-zsh.sh —— 安装 zsh 环境：oh-my-zsh + powerlevel10k 主题 + 3 个插件
#
# 只装依赖，不改你的 ~/.zshrc（`KEEP_ZSHRC=yes`），也不动默认 shell。
# 装完把本仓库 home/.zshrc、home/.p10k.zsh 放到位即可（./install.sh 会做）。

set -euo pipefail

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

command -v zsh  >/dev/null 2>&1 || { echo "!! 先装 zsh: sudo pacman -S zsh" >&2; exit 1; }
command -v git  >/dev/null 2>&1 || { echo "!! 先装 git: sudo pacman -S git" >&2; exit 1; }

# 1) oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo ">> oh-my-zsh 已存在，跳过"
else
    echo ">> 安装 oh-my-zsh ..."
    RUNZSH=no KEEP_ZSHRC=yes CHSH=no \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

mkdir -p "$ZSH_CUSTOM/plugins" "$ZSH_CUSTOM/themes"

clone() {
    local url="$1" dir="$2"
    if [ -d "$dir" ]; then
        echo ">> 已存在: $dir"
    else
        echo ">> clone: $url"
        git clone --depth=1 "$url" "$dir"
    fi
}

# 2) powerlevel10k（.zshrc 里 ZSH_THEME="powerlevel10k/powerlevel10k"）
clone https://github.com/romkatv/powerlevel10k.git \
      "$ZSH_CUSTOM/themes/powerlevel10k"

# 3) 插件（对应 .zshrc 的 plugins=(...)）
clone https://github.com/zsh-users/zsh-autosuggestions.git \
      "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
      "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone https://github.com/Aloxaf/fzf-tab.git \
      "$ZSH_CUSTOM/plugins/fzf-tab"

echo
echo "完成。"
echo "把它设为默认 shell（需要密码）:  chsh -s \"\$(command -v zsh)\""
echo "然后重新登录 / 重开终端生效。"
