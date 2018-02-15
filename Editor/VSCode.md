# VSCode

- [Visual Studio Code (VS Code) Docsの日本語訳](https://vscode-doc-jp.github.io/)

## 問題点

- サイドバーのフォントサイズが変更できない問題 => [Allow to change the font size and font of the workbench #519](https://github.com/Microsoft/vscode/issues/519)
- haskell-ide-engine でプロジェクトごとに hie のビルドが必要な問題 => [Matching hie GHC version to the project GHC version #439](https://github.com/haskell/haskell-ide-engine/issues/439)

## テーマ

個人的には [Material Icon Theme](https://marketplace.visualstudio.com/items?itemName=PKief.material-icon-theme) が良い。

- [テーマ](https://vscode-doc-jp.github.io/docs/getstarted/themes.html)
- [VS Code Marketplace](https://marketplace.visualstudio.com/search?target=vscode&category=Themes&sortBy=Downloads)


## 推奨プラグイン
- Haskell Language Server
- Haskell Syntax Highlighting
- Material Icon Theme
- [zenkaku](https://marketplace.visualstudio.com/items?itemName=mosapride.zenkaku)
- Haskell GHCi debug viewer Phoityne
- [stylish-haskell](https://marketplace.visualstudio.com/items?itemName=vigoo.stylish-haskell)
- Git History

`stylish-haskell` は保存時の自動適用より、コマンドパレットから実行する方が良い。

### 気に入らなかったプラグイン

プラグイン名 | やれること | 備考
--------|------- |------
[Auto-Open Markdown Preview](https://marketplace.visualstudio.com/items?itemName=hnw.vscode-auto-open-markdown-preview) | 自動でプレビューしたり、パネルを閉じたりする | コードの差分を表示する際に markdown のプレビューが表示されるので、使えない！
[vim](https://github.com/VSCodeVim/Vim) | vim の操作が可能になる | 入れたらめっちゃ重かった。

## 設定

### 共通設定

```
{
    "editor.fontSize": 14,
    "editor.insertSpaces": true,
    "editor.renderIndentGuides": true,
    "editor.tabSize": 2,
    "editor.wordWrap": "on",
    "extensions.autoUpdate": true,
    "files.autoSave": "afterDelay",
    "files.trimTrailingWhitespace": true,
    "workbench.startupEditor": "newUntitledFile",
    "workbench.iconTheme": "material-icon-theme",
    "window.zoomLevel": 0,
    "material-icon-theme.showUpdateMessage": false,
    "explorer.confirmDelete": false,
    "explorer.confirmDragAndDrop": false,
    "git.autofetch": true,
    "stylishHaskell.showConsoleOnError": false,
    "stylishHaskell.runOnSave": false,
    "editor.suggestSelection": "recentlyUsedByPrefix",
    "terminal.integrated.copyOnSelection": true,
    
    // zenkaku
    "editor.renderWhitespace": "all",
    
    // stylish-haskell
    "stylishHaskell.showConsoleOnError": false,
    "stylishHaskell.runOnSave": false
}
```

### macOS のみ

```json
"workbench.fontAliasing": "auto"
```

### 必要な人だけ

```json
// ターミナルを更新したらパスが変更されたので追加
"terminal.integrated.shell.osx": "/usr/local/Cellar/bash/4.4.18/bin/bash"
```

## 参考
- [VS Code でドキュメントの空白文字を見やすくしてみる](https://qiita.com/satokaz/items/cb45d82f6f8f1e24c0d6)

# マークダウンのプレビュー
> Markdownのファイルを開いているときに、command+shift+VでMarkdownをプレビューすることが出来ます。

- [Visual Studio Code を使って Markdown のプレビュー](https://qiita.com/poemn/items/8094c04bba86bd4fbe54)
- [Visual Studio Code を Markdown プレビュー付きエディタとして使う方法](https://qiita.com/akira6592/items/da5271a4987eab2c7a5a)
