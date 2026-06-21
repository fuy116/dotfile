# dotfile

個人 macOS 設定檔備份。每個工具一個子資料夾，用 symlink 裝到對應路徑。

## 結構

```
dotfile/
├── aerospace/
│   └── .aerospace.toml    → ~/.aerospace.toml
└── install.sh             # 一鍵建立 symlink
```

## 安裝（新機 / clone 後）

```bash
git clone git@github.com:fuy116/dotfile.git ~/dotfile
cd ~/dotfile
./install.sh
```

AeroSpace 改完設定後：`Alt+Shift+R` reload，或 `aerospace reload-config`。

## Workspace 速查

| WS | 用途 | App |
|----|------|-----|
| 1 | 瀏覽 | Safari, Dia |
| 2 | 筆記 | Heptabase |
| 3 | 開發 | Cursor, cmux |
| 4 | 備考 | Anki |
| 5 | VS Code | Visual Studio Code |
| 6 | 聊天 | Discord, LINE |
| 7 | 雜項 | Spotify, Calendar |

詳細說明：`~/Documents/Note/knowledgebase/aerospace-guide.html`
