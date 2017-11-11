# GHC

- [Resources for newcomers to GHC](https://ghc.haskell.org/trac/ghc/wiki/Newcomers)

## ビルド方法

今は GHC のビルド用の Dockerfile が用意されている。

- [gregwebs/ghc-docker-dev](https://github.com/gregwebs/ghc-docker-dev)

```bash
$ git config --global url."git://github.com/ghc/packages-".insteadOf git://github.com/ghc/packages/
$ git clone --recursive git://github.com/ghc/ghc
$ cd ghc
$ git checkout ghc-8.2
$ git submodule update --init
$ cp mk/build.mk.sample mk/build.mk
```

以下のコマンドでビルドする。

```bash
$ ./boot
$ ./configure
$ make -j8
```


## 高速リビルド
`mk/build.mk` で以下の行のコメントを外す

```make
BuildFlavour = devel2
stage=2
```
