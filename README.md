# dotfile

個人 macOS 設定檔備份。每個工具一個子資料夾，用 symlink 裝到對應路徑。

## 結構

```
dotfile/
├── aerospace/
│   └── .aerospace.toml       → ~/.aerospace.toml
├── oh-my-posh/
│   └── theme.omp.json        → ~/.config/oh-my-posh/theme.omp.json
├── ghostty/
│   └── config                → ~/.config/ghostty/config
├── SketchyBar/
│   ├── sketchybarrc          → ~/.config/sketchybar/sketchybarrc
│   └── plugins/              → ~/.config/sketchybar/plugins/
└── install.sh
```

## 安裝（新機 / clone 後）

```bash
git clone git@github.com:fuy116/dotfile.git ~/dotfile
cd ~/dotfile
./install.sh
```

## 各工具 reload

| 工具 | 生效方式 |
|------|----------|
| AeroSpace | `Alt+Shift+R` 或 `aerospace reload-config` |
| Ghostty | 重開視窗 / 新開 tab |
| oh-my-posh | `exec zsh` 或新開 terminal |
| SketchyBar | `brew services restart sketchybar` |

## AeroSpace Workspace 速查

| WS | 用途 | App |
|----|------|-----|
| 1 | 瀏覽 | Safari, Dia |
| 2 | 筆記 | Heptabase |
| 3 | 開發 | Cursor, cmux |
| 5 | VS Code | Visual Studio Code |
| 6 | 聊天 | Discord, LINE |
| 7 | 雜項 | Spotify, Calendar |

詳細說明：`~/Documents/Note/knowledgebase/aerospace-guide.html`
