# 問題点

- 複数プロジェクトを開けない問題
  - [Add support for opening multiple project folders in same window #396](https://github.com/Microsoft/vscode/issues/396)

- サイドバーのフォントサイズが変更できない問題
  - [Allow to change the font size and font of the workbench #519](https://github.com/Microsoft/vscode/issues/519)

# まとめ
## 拡張機能
- Haskell Language Server
- Haskell Syntax Highlighting
- Material Icon Theme
- Zenkaku
- Haskell GHCi debug viewer Phoityne

## 設定

```json
{
    "editor.insertSpaces": true,
    "editor.renderIndentGuides": true,
    "editor.renderWhitespace": "all",
    "editor.tabSize": 2,
    "editor.wordWrap": "on",
    "extensions.autoUpdate": true,
    "files.autoSave": "afterDelay",
    "files.trimTrailingWhitespace": true,
    "workbench.startupEditor": "newUntitledFile",
    "workbench.iconTheme": "material-icon-theme"
}
```

# 空白の設定
- `editor.renderWhitespace: "all"` を設定して半角の空白を可視化する
- [`zenkaku`](https://marketplace.visualstudio.com/items?itemName=mosapride.zenkaku) という拡張機能を使って全角の空白を可視化する

## 参考
- [VS Code でドキュメントの空白文字を見やすくしてみる](https://qiita.com/satokaz/items/cb45d82f6f8f1e24c0d6)

# マークダウンのプレビュー
> Markdownのファイルを開いているときに、command+shift+VでMarkdownをプレビューすることが出来ます。

- [Visual Studio Code を使って Markdown のプレビュー](https://qiita.com/poemn/items/8094c04bba86bd4fbe54)
- [Visual Studio Code を Markdown プレビュー付きエディタとして使う方法](https://qiita.com/akira6592/items/da5271a4987eab2c7a5a)

# テーマ

個人的には [Material Icon Theme](https://marketplace.visualstudio.com/items?itemName=PKief.material-icon-theme) が良い。

- [テーマ](https://vscode-doc-jp.github.io/docs/getstarted/themes.html)
- [VS Code Marketplace](https://marketplace.visualstudio.com/search?target=vscode&category=Themes&sortBy=Downloads)

# プラグイン

プラグイン名 | やれること | 備考
--------|------- |------
[Auto-Open Markdown Preview](https://marketplace.visualstudio.com/items?itemName=hnw.vscode-auto-open-markdown-preview) | 自動でプレビューしたり、パネルを閉じたりする | コードの差分を表示する際に markdown のプレビューが表示されるので、使えない！
