# 截图 / Screenshots

仓库里目前只有一张 **配色示意图** `preview.png`：

- 它不是真实截图，是按配色板画的。
- 源文件是 `preview.svg`，改完用：
  ```bash
  rsvg-convert -w 1600 -h 900 -o preview.png preview.svg
  ```

## 补真实截图

本配置自带截图能力：

| 快捷键 | 工具 |
|---|---|
| `Print` / `Mod+Shift+S` | mark-shot（框选 / 延时 / 录屏） |
| `Ctrl+Print` | niri 截整屏 |
| `Alt+Print` | niri 截当前窗口 |

截图默认存到 `~/Pictures/Screenshots/`。

### 建议拍这几张

1. `01-desktop.png` — 桌面全景（状态栏 + 一两个窗口）
2. `02-control-center.png` — Noctalia 控制中心
3. `03-launcher.png` — Noctalia 启动器
4. `04-overview.png` — niri 概览（`Mod+Tab`）
5. `05-terminal.png` — kitty 终端配色
6. `06-fcitx5.png` — fcitx5 输入法候选窗

拍完放进本目录，再在根 `README.md` 顶部引用，例如：

```markdown
![desktop](screenshots/01-desktop.png)
```
