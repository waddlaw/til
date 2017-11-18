# HyperHaskell

- [HeinrichApfelmus/hyper-haskell](https://github.com/HeinrichApfelmus/hyper-haskell)

## Install (Ubuntu 16.04 LTS)

### Electron

- [electron/electron](https://github.com/electron/electron/)
- [ubuntu16.04LTS で electron を試してみる](https://qiita.com/pandaNO12/items/63fbc06db228fd0968f1)
- [[Electron] プロキシ環境下でUbuntuにElectronを導入する方法](https://qiita.com/takahiro_itazuri/items/be1099285d69edc62f75)

```bash
$ sudo apt install -y nodejs npm libappindicator1 libxss1 libgconf2-dev libnss3-dev libasound2-dev

# node のバージョン管理ツールらしい。
$ sudo npm -g install n

# 最新版の node をインストール
$ sudo n stable

# バージョン確認
$ sudo npm -v
5.5.1
$ sudo node -v
v9.2.0

# electron のインストール
$ sudo npm -g install electron --save-dev --save-exact --unsafe-perm=true --allow-root
$ electron -v
```

###

```bash
$ curl -sSL https://get.haskellstack.org/ | sh
```
