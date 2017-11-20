# submodule

## サブモジュールの更新

```bash
$ git checkout <branch name>
$ cd ..
$ git add <submodule name>
$ git commit -m "Update submodule: Bootstrap"
```

## コマンド

`.git/config` のサブモジュールの `URL` をした後には以下のコマンドを実行しないと反映されない。

```bash
$ git submodule sync

# init と update
$ git submodule update -i
```

## 参考
- [submodule の向き先 url を変更する](https://qiita.com/8mamo10/items/fd11d8c7a2d928b39173)
- [Git submodule の基礎](https://qiita.com/sotarok/items/0d525e568a6088f6f6bb)
- [Git submoduleの抑えておきたい理解ポイントのまとめ(https://qiita.com/kinpira/items/3309eb2e5a9a422199e9)
