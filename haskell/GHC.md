# GHC

- [Resources for newcomers to GHC](https://ghc.haskell.org/trac/ghc/wiki/Newcomers)
- [Setting up a Linux system for building GHC](https://ghc.haskell.org/trac/ghc/wiki/Building/Preparation/Linux)
- [Fast rebuilding](https://ghc.haskell.org/trac/ghc/wiki/Building/Using#HowtomakeGHCbuildquickly)

## ビルド方法

今は GHC のビルド用の Dockerfile が用意されている。(今回は使ってない)

- [gregwebs/ghc-docker-dev](https://github.com/gregwebs/ghc-docker-dev)

```bash
$ sudo apt update && sudo apt upgrade -y \
  && sudo apt build-dep -y ghc \
  && sudo apt install -y git autoconf automake libtool make gcc g++ libgmp-dev ncurses-dev libtinfo-dev python3 xz-utils linux-tools-generic xutils-dev \
  && curl -sSL https://get.haskellstack.org/ | sh \
  && stack install happy alex cabal-install --install-ghc

$ git config --global url."git://github.com/ghc/packages-".insteadOf git://github.com/ghc/packages/ \
$ git clone --recursive git://github.com/ghc/ghc \
  && cd ghc \
  && git checkout ghc-8.2 \
  && git update submodule --init \
  && cp mk/build.mk.sample mk/build.mk

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

## ビルド時間

プロジェクトルートにて、ビルド時間の計測は以下のコマンドで行った。(`ghc-8.2` ブランチ)

```bash
$ time make -jN
```

`OS` は `Ubuntu 16.04 LTS`

### 初回ビルド

マシンタイプ | ディスクタイプ | -j | -j32 | -j16 | -j8 | none |
-----------|-------------|----|-----|------|-----|------|
n1-standard-16 （vCPU x 16、メモリ 60 GB） | SSD | | | | | |
