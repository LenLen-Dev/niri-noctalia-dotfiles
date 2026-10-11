# niri + Noctalia · Koru Fern（偏绿）

**中文** · [English](README.en.md)

![preview](screenshots/preview.png)

一套 **Arch Linux + [niri](https://github.com/YaLTeR/niri)（滚动平铺 Wayland 合成器）+
[Noctalia](https://noctalia.dev) v5（一体化桌面壳：状态栏 / 启动器 / 通知 / 剪贴板 / OSD / 壁纸 / 锁屏）**
的桌面配置，配色取自 **Koru Fern** 调色板并整体**向绿色偏移**：深绿炭黑底 + 蕨绿主色 + 柔黄强调。

> 本仓库是从一台正在使用的机器上导出的快照，包含配置 + 安装脚本 + 复刻文档。
> 字体不入库（体积大），由脚本下载。
> 顶部图片是按配色板绘制的**示意图**；补真实截图的方法见 [`screenshots/`](screenshots/README.md)。

---

## 目录

- [这套东西长什么样](#这套东西长什么样)
- [配色板](#配色板)
- [环境要求](#环境要求)
- [依赖](#依赖)
- [快速开始](#快速开始)
- [手动复刻（分步）](#手动复刻分步)
- [文件一览](#文件一览)
- [字体](#字体)
- [zsh](#zsh)
- [Noctalia 细节](#noctalia-细节)
- [niri 快捷键](#niri-快捷键)
- [niri 结构与动画](#niri-结构与动画)
- [已知事项 / 注意](#已知事项--注意)
- [可选：和 waybar 那套并存切换](#可选和-waybar-那套并存切换)
- [致谢与许可](#致谢与许可)

---

## 这套东西长什么样

- **合成器**：niri `26.04`（Wayland）。窗口带 12px 圆角区域、4px 间隙、全局毛玻璃（半透明 + 背景模糊）。
- **面板/壳**：Noctalia `5.2.1`，深色模式 + 自定义调色板 `KoruFern` + 毛玻璃下拉面板。
- **终端**：kitty（`FiraCode Nerd Font Mono` 14pt，背景不透明度 0.8，无窗口装饰）。
- **输入法**：fcitx5（rime）+ 自制 `koru-fern` 输入法主题。
- **壁纸**：`koru-fern.png` / `koru-logo.png`（仓库 `wallpapers/`）。
- **Shell**：zsh + oh-my-zsh + powerlevel10k（提示符配色同样是 Koru Fern）。
- **登录**：greetd（可选配合 `noctalia-greeter`）。
- **字体**：见 [`fonts/README.md`](fonts/README.md)。

> 没有附带截图。复刻后效果即上述配色 + 毛玻璃。

---

## 配色板

核心色（这是「偏绿版」Koru Fern，写死在 `config/niri/noctalia.kdl`、`config/noctalia/palettes/KoruFern.json`、
`config/kitty/themes/noctalia.conf`、`local/share/fcitx5/themes/koru-fern/theme.conf` 里）：

| 角色 | 值 | 用在哪 |
|---|---|---|
| 背景 `bg` / `mSurface` | `#16201A` | niri `layout background-color`、`overview backdrop-color`、终端背景 |
| 面板/表面 `surfaceVariant` | `#1F2E26` | 输入法面板底、非活动边框 |
| 主色 `accent` / `mPrimary` | `#85C57E` | 焦点边框、选中项、终端 color2 |
| 柔黄 `accent-yellow` / `mTertiary` | `#DDE07A` | 强调、终端 color3 |
| 边框 `border` / `mOutline` | `#3E5C46` | 输入法面板边框、分隔线 |
| 悬停 `mHover` | `#2F5138` | 选中背景（终端 selection） |
| 前景 `mOnSurface` | `#CFDFD0` | 文字 |
| 次要文字 `mOnSurfaceVariant` | `#A2B8A4` | 弱化文字 |
| 错误 `mError` | `#CC8F88` | urgent 边框、终端 color1 |

原始 Koru Fern 取自 `koru-nixos-dotfiles/system/theme.nix`，这里把所有色相朝绿偏移了一点。

---

## 环境要求

- **Arch Linux**（其他发行版也行，注意包名）。Wayland 会话。
- 显示器：本配置针对 `eDP-1 2560x1440@165Hz，scale 1.5` 调的。**换分辨率/缩放要改**
  `~/.config/niri/config.kdl` 里的 `output "eDP-1" { ... }`。
- 显卡：在 NVIDIA RTX 3050 Mobile 上使用（nvidia-drm `modeset=1`）。非 N 卡无需特殊处理。
- 登录：`greetd`。

---

## 依赖

### Arch 官方仓库

```bash
sudo pacman -S --needed \
    niri noctalia \
    kitty fuzzel swaylock playerctl nautilus \
    fcitx5 fcitx5-rime fcitx5-configtool fcitx5-gtk fcitx5-qt \
    pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber \
    xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk \
    xwayland-satellite \
    fontconfig curl unzip
```

可选：

```bash
sudo pacman -S --needed greetd noctalia-greeter-git   # 登录界面（可选）
```

### AUR

```bash
paru -S --needed mark-shot-bin        # 截图/录屏工具（Mod+Shift+S / Print 用到）
```

> - `swaylock`：本机其实**没装**（`Super+Alt+L` 目前是空绑定）。想锁屏就装上，或改用 Noctalia 自己的锁屏。
> - `xwayland-satellite`：给 QQ 等 X11 应用用（解决 QQ 剪贴板/屏幕共享的崩溃）。
> - `~/.local/bin` 需要在你登录会话的 `PATH` 里（本配置的 `Mod+Alt+W` 用到了 `niri-profile`）。

### zsh 环境（可选）

```bash
sudo pacman -S --needed zsh git bat eza zoxide fzf fastfetch wl-clipboard
paru -S --needed mise        # 可选：管理 node / java / bun / zig 等工具链（见 mise.jdx.dev）
```

然后运行 [`./zsh/install-zsh.sh`](zsh/install-zsh.sh) 装 oh-my-zsh + powerlevel10k + 3 个插件。
细节见 [zsh](#zsh)。

---

## 快速开始

```bash
git clone <这个仓库的地址> ~/dotfiles
cd ~/dotfiles

# 1) 装依赖（见上面「依赖」一节）

# 2) 拷贝配置（已存在的会备份到 ~/.dotfiles-backup-<时间>）
./install.sh

# 3) 字体（~250MB，装到 ~/.local/share/fonts）
./fonts/install-fonts.sh
fc-cache -f

# 4) zsh 环境（oh-my-zsh + powerlevel10k + 插件）
./zsh/install-zsh.sh
chsh -s "$(command -v zsh)"

# —— 或者一步到位 ——
# ./install.sh --extras

# 5) 设壁纸
noctalia msg wallpaper-set "$HOME/Pictures/Wallpapers/koru-logo.png"

# 6) 重新登录（或重启 niri / Noctalia）让配置生效
```

---

## 手动复刻（分步）

### 1. 装依赖

见上面 [依赖](#依赖)。

### 2. 装字体

```bash
./fonts/install-fonts.sh
fc-cache -f
fc-list | grep -i 'Nerd Font'    # 验证
```

细节和「哪个程序用哪个字体」见 [`fonts/README.md`](fonts/README.md)。

### 3. 拷贝配置

把 `config/` 里的东西分别放到 `~/.config/`，`local/` 放到 `~/.local/`：

```bash
DOT=~/dotfiles            # 改成你的仓库路径
cp "$DOT/config/niri/config.kdl"                   ~/.config/niri/config.kdl
cp "$DOT/config/niri/noctalia.kdl"                 ~/.config/niri/noctalia.kdl
cp "$DOT/config/noctalia/config.toml"              ~/.config/noctalia/config.toml
cp "$DOT/config/noctalia/palettes/KoruFern.json"   ~/.config/noctalia/palettes/KoruFern.json
cp "$DOT/config/kitty/kitty.conf"                  ~/.config/kitty/kitty.conf
cp "$DOT/config/kitty/themes/noctalia.conf"        ~/.config/kitty/themes/noctalia.conf
cp "$DOT/config/fcitx5/conf/classicui.conf"        ~/.config/fcitx5/conf/classicui.conf
cp "$DOT/config/fontconfig/fonts.conf"             ~/.config/fontconfig/fonts.conf
cp "$DOT/config/mark-shot/config.json"             ~/.config/mark-shot/config.json
cp "$DOT/config/code-flags.conf"                   ~/.config/code-flags.conf
cp "$DOT/local/bin/niri-profile"                   ~/.local/bin/niri-profile && chmod +x ~/.local/bin/niri-profile
mkdir -p ~/.local/share/fcitx5/themes
cp -r "$DOT/local/share/fcitx5/themes/koru-fern"   ~/.local/share/fcitx5/themes/koru-fern
```

（`./install.sh` 就是自动做这些。）

### 4. 壁纸

```bash
mkdir -p ~/Pictures/Wallpapers
cp "$DOT/wallpapers/"*.png ~/Pictures/Wallpapers/
noctalia msg wallpaper-set "$HOME/Pictures/Wallpapers/koru-logo.png"
```

### 5. Noctalia 设置

Noctalia 的**运行时状态**在 `~/.local/state/noctalia/settings.toml`（本仓库没直接放它，因为含机器相关路径）。
在 Noctalia 设置界面里对应勾选：

- **主题**：`source = 自定义`，自定义调色板选 `KoruFern`，`mode = dark`。
- **模板 (templates)**：启用 `niri`、`kitty`、`foot`、`gtk3`、`gtk4`、`qt`、`kcolorscheme`、`starship`、`btop`
  → Noctalia 会自动把配色写到这些应用的配置里（niri 的 `noctalia.kdl` 就是这么来的）。
- **壁纸**：选 `~/Pictures/Wallpapers/koru-logo.png`。
- 参考片段见 [`extras/noctalia-settings.reference.toml`](extras/noctalia-settings.reference.toml)。

`config/noctalia/config.toml` 里额外做了：**毛玻璃**（`transparency_mode = "glass"`、状态栏/胶囊/通知/OSD 半透明 + 合成器模糊）。

### 6. niri

- 主配置 `~/.config/niri/config.kdl`（结构、快捷键、窗口规则、动画）。
- 颜色由 Noctalia 模板生成并 `include "noctalia.kdl"` 在文件末尾。
- `config.kdl` 里 `spawn-at-startup` 会拉起 `noctalia` 和 `mark-shot --tray`。

改完用 `niri msg action load-config-file` 热重载（niri 26.04 的命令；旧版是 `reload-config`）。

### 7. kitty

`config/kitty/kitty.conf`：字体、`background_opacity 0.8`、`hide_window_decorations yes`、
`confirm_os_window_close 0`、`shell /usr/bin/zsh`。
颜色在 `config/kitty/themes/noctalia.conf`（由 Noctalia 生成，`include` 进来）。

### 8. fcitx5

- 主题文件 `~/.local/share/fcitx5/themes/koru-fern/`（含 4 个 svg）。
- `~/.config/fcitx5/conf/classicui.conf` 里 `Theme=koru-fern`。

### 9. 其它

- `~/.config/code-flags.conf`：VSCode 的 Wayland 启动参数。
- `~/.config/mark-shot/config.json`：截图工具配置（全局热键置空，改用托盘 + niri 快捷键触发）。

---

## 文件一览

仓库内 → 目标位置：

| 仓库 | 目标 | 说明 |
|---|---|---|
| `config/niri/config.kdl` | `~/.config/niri/config.kdl` | niri 主配置 |
| `config/niri/noctalia.kdl` | `~/.config/niri/noctalia.kdl` | Noctalia 生成的颜色（被上面 include） |
| `config/noctalia/config.toml` | `~/.config/noctalia/config.toml` | Noctalia 手写配置（调色板 + 毛玻璃） |
| `config/noctalia/palettes/KoruFern.json` | `~/.config/noctalia/palettes/KoruFern.json` | Koru Fern 调色板定义 |
| `config/kitty/kitty.conf` | `~/.config/kitty/kitty.conf` | kitty 主配置 |
| `config/kitty/themes/noctalia.conf` | `~/.config/kitty/themes/noctalia.conf` | kitty 颜色（Noctalia 生成） |
| `config/fcitx5/conf/classicui.conf` | `~/.config/fcitx5/conf/classicui.conf` | 输入法 UI 用哪个主题 |
| `local/share/fcitx5/themes/koru-fern/` | `~/.local/share/fcitx5/themes/koru-fern/` | 输入法主题 |
| `config/fontconfig/fonts.conf` | `~/.config/fontconfig/fonts.conf` | 等宽 / 中文字体回退 |
| `config/mark-shot/config.json` | `~/.config/mark-shot/config.json` | 截图工具配置 |
| `config/code-flags.conf` | `~/.config/code-flags.conf` | VSCode Wayland 参数 |
| `home/.zshrc` | `~/.zshrc` | zsh 主配置（oh-my-zsh + p10k + 别名/函数/代理） |
| `home/.p10k.zsh` | `~/.p10k.zsh` | powerlevel10k 主题（颜色由 `.zshrc` 覆盖成 Koru Fern） |
| `config/mise/config.toml` | `~/.config/mise/config.toml` | mise 工具链版本（可选） |
| `local/bin/niri-profile` | `~/.local/bin/niri-profile` | 桌面档案切换脚本（Mod+Alt+W，可选） |
| `wallpapers/*.png` | `~/Pictures/Wallpapers/` | 壁纸 |
| `fonts/` | — | 字体脚本 + 清单（字体本体不在这里） |
| `zsh/` | — | zsh 环境安装脚本 |

---

## 字体

见 [`fonts/README.md`](fonts/README.md)。摘要：

- **正在使用**：kitty → `FiraCode Nerd Font Mono`；系统等宽 → `FantasqueSansM Nerd Font Mono`；中文 → `LXGW Neo Xi Hei Plus`。
- **已装备用**：CommitMono、Go-Mono、ComicShannsMono、GoogleSansCode（Nerd Font 补丁版）。
- 一键脚本：`./fonts/install-fonts.sh`（从官方源下载，无需 root）。

---

## zsh

配置是 `home/.zshrc` + `home/.p10k.zsh`，基于 **oh-my-zsh + powerlevel10k**，提示符配色也换成了 Koru Fern。

### 安装

```bash
sudo pacman -S --needed zsh git bat eza zoxide fzf fastfetch wl-clipboard
paru -S --needed mise           # 可选

./zsh/install-zsh.sh            # oh-my-zsh + powerlevel10k + 插件（幂等，不覆盖 ~/.zshrc）
chsh -s "$(command -v zsh)"     # 设默认 shell（需要密码）
```

`install-zsh.sh` 会装：

| 组件 | 来源 | 用途 |
|---|---|---|
| oh-my-zsh | ohmyzsh/ohmyzsh | 框架 |
| powerlevel10k | romkatv/powerlevel10k | 提示符主题（`ZSH_THEME="powerlevel10k/powerlevel10k"`） |
| zsh-autosuggestions | zsh-users | 历史自动建议 |
| zsh-syntax-highlighting | zsh-users | 语法高亮 |
| fzf-tab | Aloxaf | Tab 补全走 fzf |

### `.zshrc` 里都有什么

- **插件**：`git sudo colored-man-pages extract copyfile copypath fzf-tab zsh-autosuggestions zsh-syntax-highlighting`
  （`copyfile` / `copypath` 需要 `wl-clipboard`）。
- **选项**：自动 `cd`、目录栈、共享历史、去重等。
- **代理**：默认 `127.0.0.1:7897`（Clash Verge mixed 端口），并提供 `proxyon` / `proxyoff`。
- **命令替换**：`bat`→`cat`、`eza`→`ls/l/la`、`zoxide`、`fzf` 键位、`fastfetch`。
- **自定义函数**：`ll [深度] [路径]`（eza 树）、`lt`、`topdf <输入> <目标>`（需 LibreOffice）。
- **主题色**：文件末尾用 `POWERLEVEL9K_*` 变量把 p10k 颜色覆盖成 Koru Fern
  （`#85C57E` / `#CFDFD0` / `#DDE07A` …），所以重跑 `p10k configure` 也不会破坏配色。
- **mise**：装了才 `eval "$(mise activate zsh)"`。
- **时区**：`export TZ='Asia/Shanghai'`。

### 注意

- `copyfile` / `copypath` 需要 `wl-clipboard`（Wayland 剪贴板）。
- `topdf` 需要 `libreoffice-fresh`（没装就不会定义该函数）。
- kitty 里把 `Super+J/K/L` 转成 `ESC j/k/l`（Meta），这是 `.zshrc` 里 fzf 历史/文件/`cd` 键位的来源；换其它终端就不生效。
- 代理端口 `7897` 按需改成你自己的。

---

## Noctalia 细节

- **调色板**：`config/noctalia/palettes/KoruFern.json`，在 `config.toml` 里通过
  `[theme] source="custom"` + `custom_palette="KoruFern"` 启用。
- **毛玻璃**：
  ```toml
  [shell.panel]      transparency_mode = "glass"
  [bar.default]      background_opacity = 0.55 / capsule_opacity = 0.65 / compositor_blur = true
  [notification]     background_opacity = 0.7
  [osd]              background_opacity = 0.7
  ```
- **模板**：Noctalia 会把当前调色板写进它支持的各个应用配置。启用的模板（`builtin_ids`）：
  `btop, foot, gtk3, gtk4, kcolorscheme, kitty, niri, qt, starship`。
  所以 **niri 的边框色、kitty 的终端色都不是手写的**，而是 Noctalia 生成后再被 `include`/`include themes/...` 引进来。
  想让主题改动生效，改调色板即可，不必手动同步这些文件。
- **常用命令**（也用作快捷键）：
  ```bash
  noctalia msg panel-toggle launcher        # 启动器
  noctalia msg panel-toggle control-center  # 控制中心
  noctalia msg panel-toggle clipboard       # 剪贴板
  noctalia msg settings-toggle              # 设置
  noctalia msg window-switcher hold         # 窗口切换器
  noctalia msg volume-up / volume-down / volume-mute
  noctalia msg brightness-up / brightness-down
  noctalia msg wallpaper-set <path>
  ```

---

## niri 快捷键

> `Mod` = 超级键（Super）。完整列表见 `config/niri/config.kdl` 的 `binds {}`。

### 启动 / 壳

| 快捷键 | 作用 |
|---|---|
| `Mod+T` / `Mod+Return` | 打开终端（kitty） |
| `Mod+Slash` | 临时浮动终端（kitty `--class scratch`） |
| `Mod+E` | 文件管理器（Nautilus） |
| `Mod+D` | 启动器（fuzzel） |
| `Mod+Space` | Noctalia 启动器 |
| `Mod+S` | Noctalia 控制中心 |
| `Mod+Comma` | Noctalia 设置 |
| `Mod+V` | Noctalia 剪贴板 |
| `Mod+Alt+Tab` | Noctalia 窗口切换器 |
| `Alt+Tab` | niri 内建最近窗口切换器（带实时预览） |
| `Mod+Tab` | 概览 Overview |
| `Super+Alt+L` | 锁屏（swaylock，需自行安装） |
| `Mod+Alt+W` | 切换桌面档案（noctalia ↔ waybar，见后文） |

### 窗口 / 列

| 快捷键 | 作用 |
|---|---|
| `Mod+Q` | 关闭窗口 |
| `Mod+Left/Down/Up/Right`、`Mod+H/J/K/L` | 焦点：列左 / 窗口下 / 窗口上 / 列右 |
| `Mod+Ctrl+方向键`、`Mod+Ctrl+H/J/K/L` | 移动列 / 移动窗口 |
| `Mod+R` / `Mod+Shift+R` | 切换列宽预设（正向/反向） |
| `Mod+F` / `Mod+Shift+F` | 最大化列 / 全屏 |
| `Mod+M` | 最大化到边缘 |
| `Mod+Ctrl+F` | 扩展到可用宽度 |
| `Mod+C` / `Mod+Ctrl+C` | 居中列 / 居中可见列 |
| `Mod+Minus` / `Mod+Equal` | 列宽 −10% / +10% |
| `Mod+Shift+Minus` / `Mod+Shift+Equal` | 窗口高 −10% / +10% |
| `Mod+BracketLeft/Right` | 吞并/弹出窗口（进/出当前列） |
| `Mod+W` | 列内标签式显示切换 |
| `Mod+Shift+V` | 在浮动 / 平铺间切换焦点 |
| `Mod+Shift+E`、`Ctrl+Alt+Delete` | 退出 niri |

### 工作区 / 显示器

| 快捷键 | 作用 |
|---|---|
| `Mod+Page_Down/Up`、`Mod+U/I` | 焦点：工作区下 / 上 |
| `Mod+Ctrl+Page_Down/Up`、`Mod+Ctrl+U/I` | 把列移到：工作区下 / 上 |
| `Mod+Shift+Page_Down/Up`、`Mod+Shift+U/I` | 移动工作区下 / 上 |
| `Mod+1`…`Mod+9` | 切到工作区 1–9 |
| `Mod+Ctrl+1`…`9` | 把列移到工作区 1–9 |
| `Mod+Shift+方向键`、`Mod+Shift+H/J/K/L` | 焦点：显示器左/下/上/右 |
| `Mod+Shift+Ctrl+方向键` | 把列移到相邻显示器 |
| `Mod+WheelScroll…` | 滚轮：切工作区 / 列 |

### 音量 / 亮度 / 媒体

| 快捷键 | 作用 |
|---|---|
| `XF86AudioRaiseVolume/LowerVolume/Mute` | 音量± / 静音（走 Noctalia OSD） |
| `XF86AudioMicMute` | 麦克风静音（wpctl） |
| `XF86AudioPlay/Stop/Prev/Next` | 媒体控制（playerctl） |
| `XF86MonBrightnessUp/Down` | 亮度±（走 Noctalia） |

### 截图 / 其它

| 快捷键 | 作用 |
|---|---|
| `Print` / `Mod+Shift+S` | mark-shot 截图 |
| `Ctrl+Print` | niri 截整屏 |
| `Alt+Print` | niri 截当前窗口 |
| `Mod+Shift+Slash` | 显示快捷键教程 |
| `Mod+Escape` | 切换「屏蔽快捷键」 |
| `Mod+Shift+P` | 关闭显示器 |

---

## niri 结构与动画

摘要在 `config/niri/config.kdl` 里都有注释，关键设置：

- **布局**：`gaps 4`；`struts` 上下左右 `-4`（外边缘 = 4 − 4 = 0，窗口贴边铺满）；
  `center-focused-column "never"`；列宽预设 1/3、1/2、2/3。
- **背景**：`layout background-color "#16201A"`；`overview { backdrop-color "#16201A"; zoom 0.5 }`。
- **无客户端装饰**：`prefer-no-csd`（让 GNOME 系应用去掉圆角 CSD）。
- **全局毛玻璃**（窗口规则）：
  ```kdl
  window-rule {
      background-effect { blur true }
      opacity 0.9
      draw-border-with-background false
  }
  ```
- **窗口规则**：Firefox 默认最大化（PiP 保持浮动）；QQ 的「图片查看器 / 转发的聊天记录」浮动；
  `scratch`（`Mod+Slash`）浮动居中 60%；WezTerm 修正列宽 bug。
- **动画**（`animations {}`）：
  - `window-open`：**自定义 shader**，从中心 70% 放大 + 淡入（250ms，`ease-out-expo`）。
  - `window-close`：**自定义 shader**，向中心缩到 85% + 淡出（200ms，`ease-out-cubic`）。
  - 其余（工作区切换、窗口移动/缩放、概览、最近窗口）用弹簧。
  - 自定义 shader 需要 niri ≥ 0.1.6；接口不保证向后兼容。
- **其他**：`recent-windows` 预览高亮色用 Koru Fern 绿；`hotkey-overlay` 启动时不弹；
  截图存到 `~/Pictures/Screenshots/`。

---

## 已知事项 / 注意

1. **显示器**：`output "eDP-1"` 写死了 mode/scale/position。换机器务必改，否则缩放/分辨率不对。
2. **`swaylock` 未安装**：`Super+Alt+L` 目前无效果。装 `swaylock` 或改用 Noctalia 锁屏。
3. **mark-shot** 在 AUR（`mark-shot-bin`），`Print` / `Mod+Shift+S` 依赖它。
4. **`Mod+Alt+W`** 调的是 `~/.local/bin/niri-profile`，需要一个「第二套档案」才有意义（见下一节）。
5. **Noctalia 版本**：配置按 `5.2.x` 写。升级后若配置键名变了，以官方文档为准。
6. **NVIDIA**：本机 nvidia-drm `modeset=1`。A 卡/Intel 无需额外设置；N 卡若 GTK 应用启动慢，
   `config.kdl` 的 `environment { GSK_RENDERER "gl" }` 有帮助。
7. **颜色别手改**：niri/kitty 的颜色由 Noctalia 模板生成（`noctalia.kdl`、`themes/noctalia.conf`），
   重跑 Noctalia 会被覆盖。要改颜色就改 `palettes/KoruFern.json`。
8. **几个硬编码路径**：`config/kitty/kitty.conf` 里 `shell /usr/bin/zsh`（假定 zsh 装在这）；
   `config/mark-shot/config.json` 里录屏/gif 输出目录是 `~/Pictures/mark-shot/...`。
   换机器时按需改成自己的路径。
9. `extras/noctalia-settings.reference.toml` 只是**参考片段**，里面的路径是本机的，别直接复制。
10. `home/.zshrc` 里 mise 那行，在原机是硬编码 `/home/leesyuu/.local/bin/mise`，
    这里改成了 `[ -x "$HOME/.local/bin/mise" ] && eval ...` 以便移植（行为一致）。

---

## 可选：和 waybar 那套并存切换

本机的 `config/niri/config.kdl` 里带了 `Mod+Alt+W`，它调用 `~/.local/bin/niri-profile`，
在两套「桌面档案」之间来回切：

- `~/.config/niri` 是一个**符号链接**，指向 `~/.config/niri-profiles/<档案>`；
- 切换 = 停旧档案的组件 → 改符号链接 → `niri msg action load-config-file` → 起新档案的组件。

本仓库只包含 **noctalia 档案**。想启用切换，需要再放一套「第二档案」到
`~/.config/niri-profiles/waybar/`（例如 [SHORiN-KiWATA/shorin-arch-setup](https://github.com/SHORiN-KiWATA/shorin-arch-setup)
的 `minimal-niri-dotfiles`，niri + waybar）。脚本用法：

```bash
niri-profile toggle     # 来回切
niri-profile noctalia   # 切到 noctalia
niri-profile waybar     # 切到 waybar
niri-profile status     # 看当前
```

> 如果不用切换，把 `config.kdl` 里那条 `Mod+Alt+W` 绑定删掉即可，其它不受影响。

---

## 致谢与许可

- 调色板 **Koru Fern** 来自 `koru-nixos-dotfiles/system/theme.nix`（本仓库做了偏绿调整）。
- **niri** — https://github.com/YaLTeR/niri
- **Noctalia** — https://noctalia.dev
- 字体版权归各自作者，随字体文件附带其 `LICENSE` / `OFL.txt`；本仓库不分发字体本体。
- 本仓库的配置文件可自由使用/修改。
