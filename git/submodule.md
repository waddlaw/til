# submodule

## サブモジュールの更新

```bash
$ cd <submodule dir>
$ git checkout <commit>
$ cd ../
$ git add <submodule name>
$ git commit -m "Update submodule: Bootstrap"
```

## コマンド

`.git/config` のサブモジュールの `URL` を変更した後には `git submodule sync` を実行しないと反映されない。

```bash
# サブモジュール追加
$ git submodule add <repo> <submodule name>
$ git submodule add --force <repo> <submodule name># URLの同期

$ git submodule sync

# init と update
$ git submodule update -i
$ git submodule update --init --recursive

# サブモジュールの削除
$ git submodule deinit foo/bar
$ git rm foo/bar .git/modules/foo/bar
```

## 参考
- [submodule の向き先 url を変更する](https://qiita.com/8mamo10/items/fd11d8c7a2d928b39173)
- [Git submodule の基礎](https://qiita.com/sotarok/items/0d525e568a6088f6f6bb)
- [Git submoduleの抑えておきたい理解ポイントのまとめ](https://qiita.com/kinpira/items/3309eb2e5a9a422199e9)
- [git submodule の削除](http://fd0.hatenablog.jp/entry/2017/02/08/013327)
- [自分が必要とする最低限の git submodule の知識](https://qiita.com/ma2saka/items/4bd00ef6f8c240847807)
