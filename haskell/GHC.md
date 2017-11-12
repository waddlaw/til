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
  && stack install --ghc-options="-j" happy alex cabal-install --install-ghc

$ git config --global url."git://github.com/ghc/packages-".insteadOf git://github.com/ghc/packages/
$ git clone --recursive git://github.com/ghc/ghc \
  && cd ghc \
  && git checkout refs/tags/ghc-8.2.2-rc3 \
  && git submodule update --init \
  && cp mk/build.mk.sample mk/build.mk

$ ./boot && ./configure
$ make -j
```

## 高速リビルド
- `mk/build.mk` で以下の行のコメントを外す

```make
BuildFlavour = devel2
stage=2
```

- サブディレクトリで `make` を実行する。
- `make` ではなく `make fast` にする。

## ビルド時間

プロジェクトルートにて、ビルド時間の計測は以下のコマンドで行った。(`ghc-8.2` ブランチ)

```bash
$ time make -jN
```

`OS` は `Ubuntu 16.04 LTS`

### 初回ビルド

#### 変更なし

```makefile
ifneq "$(BuildFlavour)" ""
include mk/flavours/$(BuildFlavour).mk
endif

STRIP_CMD = :
```

##### n1-standard-16 + SSD

time | -j | -j64 | -j32 | -j16 | -j8 | none |
-----|----|------|------|------|-----|------|
real | 25m43.549s | | | | | |
user | 136m2.388s | | | | | |
sys	 | 6m28.216s  | | | | | |

#### V=0

```makefile
V=0

ifneq "$(BuildFlavour)" ""
include mk/flavours/$(BuildFlavour).mk
endif

STRIP_CMD = :
```

##### n1-standard-16 + SSD

time | -j | -j64 | -j32 | -j16 | -j8 | none |
-----|----|------|------|------|-----|------|
real | | | | | | |
user | | | | | | |
sys	 | | | | | | |


### リビルド

#### 変更なし

```makefile
ifneq "$(BuildFlavour)" ""
include mk/flavours/$(BuildFlavour).mk
endif

STRIP_CMD = :
```

###### n1-standard-16 + SSD

time | -j | -j64 | -j32 | -j16 | -j8 | none |
-----|----|------|------|------|-----|------|
real | | | | | | |
user | | | | | | |
sys	 | | | | | | |

#### devel2

```makefile
BuildFlavour = devel2

ifneq "$(BuildFlavour)" ""
include mk/flavours/$(BuildFlavour).mk
endif

STRIP_CMD = :
```
##### n1-standard-16 + SSD

time | -j | -j64 | -j32 | -j16 | -j8 | none |
-----|----|------|------|------|-----|------|
real | | | | | | |
user | | | | | | |
sys	 | | | | | | |


#### devel2 + stage=2

```makefile
BuildFlavour = devel2

ifneq "$(BuildFlavour)" ""
include mk/flavours/$(BuildFlavour).mk
endif

stage=2

STRIP_CMD = :
```

##### n1-standard-16 + SSD

time | -j | -j64 | -j32 | -j16 | -j8 | none |
-----|----|------|------|------|-----|------|
real | | | | | | |
user | | | | | | |
sys	 | | | | | | |


#### devel2 + stage=2 + make fast

```makefile
BuildFlavour = devel2

ifneq "$(BuildFlavour)" ""
include mk/flavours/$(BuildFlavour).mk
endif

stage=2

STRIP_CMD = :
```

##### n1-standard-16 + SSD

time | -j | -j64 | -j32 | -j16 | -j8 | none |
-----|----|------|------|------|-----|------|
real | | | | | | |
user | | | | | | |
sys	 | | | | | | |
