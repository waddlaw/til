# GHC

- [Resources for newcomers to GHC](https://ghc.haskell.org/trac/ghc/wiki/Newcomers)
- [Setting up a Linux system for building GHC](https://ghc.haskell.org/trac/ghc/wiki/Building/Preparation/Linux)
- [Fast rebuilding](https://ghc.haskell.org/trac/ghc/wiki/Building/Using#HowtomakeGHCbuildquickly)

## ビルド方法

今は GHC のビルド用の Dockerfile が用意されている。

- [gregwebs/ghc-docker-dev](https://github.com/gregwebs/ghc-docker-dev)

### ソースコードの取得と設定

```bash
$ git config --global url."git://github.com/ghc/packages-".insteadOf git://github.com/ghc/packages/
$ git clone --recursive git://github.com/ghc/ghc
$ cd ghc
$ git checkout ghc-8.2
$ git update submodule --init
$ cp mk/build.mk.sample mk/build.mk

$ ./boot
$ ./configure
$ make -j16
```

## 高速リビルド
`mk/build.mk` で以下の行のコメントを外す

```make
BuildFlavour = devel2
stage=2
```

```bash
$ sudo docker run --rm -i -t -v `pwd`:/home/ghc gregweber/ghc-haskell-dev /bin/bash
$ sudo PATH=/opt/ghc/8.2.1/bin:$PATH make -j8
```
