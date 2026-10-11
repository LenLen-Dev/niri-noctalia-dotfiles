# 字体

字体一共约 **250 MB**，不适合放进 Git 仓库，所以这里只记录「装了什么、各自用在哪」，
并提供一键下载脚本。

```bash
./fonts/install-fonts.sh          # 下载全部字体到 ~/.local/share/fonts/ 并刷新缓存
```

脚本从官方源拉取（都无需 root）：

| 来源 | 地址 |
|---|---|
| 6 个 Nerd Font | `https://github.com/ryanoasis/nerd-fonts/releases/latest/download/<Font>.zip` |
| 中文 CJK 字体 | `https://github.com/lxgw/LxgwNeoXiHei/releases/latest/download/LXGWNeoXiHeiPlus.ttf` |

也可以自己用 `paru -S ttf-firacode-nerd` 之类的 AUR 包装。

---

## 安装了哪些字体

| 目录 (`~/.local/share/fonts/`) | 字号族 (fc-list) | 体积 | 来源 | 用途 |
|---|---|---|---|---|
| `FiraCode/` | `FiraCode Nerd Font` / `... Mono` / `... Propo` | 48M | Nerd Fonts | ✅ **kitty 终端**（`FiraCode Nerd Font Mono` 14pt） |
| `FantasqueSansMono/` | `FantasqueSansM Nerd Font` / `... Mono` / `... Propo` | 31M | Nerd Fonts | ✅ **fontconfig monospace 首选**（代码/等宽） |
| `LXGWNeoXiHeiPlus/` | `LXGW Neo Xi Hei Plus` | 8.7M | lxgw/LxgwNeoXiHei | ✅ **中文 / CJK 回退** |
| `CommitMono/` | `CommitMono Nerd Font` / `... Mono` / `... Propo` | 28M | Nerd Fonts | 已装，备用（未在配置里引用） |
| `Go-Mono/` | `GoMono Nerd Font` / `... Mono` / `... Propo` | 31M | Nerd Fonts | 已装，备用（未在配置里引用） |
| `ComicShannsMono/` | `ComicShannsMono Nerd Font` / `... Mono` / `... Propo` | 14M | Nerd Fonts | 已装，备用（未在配置里引用） |
| `GoogleSansCode/` | `GoogleSansCode Nerd Font` / `... Mono` / `... Propo` | 89M | Nerd Fonts | 已装，备用（未在配置里引用） |

> Nerd Fonts 的三种变体：`... Nerd Font`（带图标、连字）、`... Nerd Font Mono`（带图标、**单宽**，终端里对齐更整齐）、
> `... Nerd Font Propo`（带图标、比例宽度）。

## 各程序实际用的是哪个

| 程序 | 字体 | 由谁指定 |
|---|---|---|
| **kitty** | `FiraCode Nerd Font Mono` 14 | `config/kitty/kitty.conf` → `font_family` / `font_size` |
| **等宽文本（通用 monospace）** | `FantasqueSansM Nerd Font Mono` → 回退 `LXGW Neo Xi Hei Plus` | `config/fontconfig/fonts.conf` |
| **中文文本** | `LXGW Neo Xi Hei Plus` | `config/fontconfig/fonts.conf`（lang 含 `zh` 时 append + strong） |
| **fcitx5 输入法候选窗** | 默认（配置里留了可选的 FantasqueSansM 注释行） | `config/fcitx5/conf/classicui.conf` |
| **Noctalia 壳 UI** | Noctalia 默认（本配置未指定字体） | — |
| **VSCode** | VSCode 自己的设置（默认） | 不在本仓库 |

## 想换字体

- 终端：改 `~/.config/kitty/kitty.conf` 的 `font_family`（用上面任一 `... Nerd Font Mono`）。
- 系统等宽/中文：改 `~/.config/fontconfig/fonts.conf`，然后 `fc-cache -f`。

## 许可

各字体保留其原始许可（随各自的 `LICENSE` / `OFL.txt` 一起下载），**不要**把字体文件再打包进本仓库分发。
