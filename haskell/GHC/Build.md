# GHC

- [Resources for newcomers to GHC](https://ghc.haskell.org/trac/ghc/wiki/Newcomers)
- [Setting up a Linux system for building GHC](https://ghc.haskell.org/trac/ghc/wiki/Building/Preparation/Linux)
- [Fast rebuilding](https://ghc.haskell.org/trac/ghc/wiki/Building/Using#HowtomakeGHCbuildquickly)

## ビルド方法

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
$ sudo make install
```

GHC のビルド用の Dockerfile が用意されている。(今回は使ってない)

- [gregwebs/ghc-docker-dev](https://github.com/gregwebs/ghc-docker-dev)

## 高速リビルド
- `mk/build.mk` で以下の行のコメントを外す

```make
BuildFlavour = devel2
stage=2
```

- サブディレクトリで `make` を実行する。
- `make` ではなく `make fast` にする。

## ビルド時間

プロジェクトルートにて、ビルド時間の計測は以下のコマンドで行った。(`ghc-8.2.2-rc3` ブランチ)

```bash
$ time make -jN
```

`OS` は `Ubuntu 16.04 LTS`

### 初回ビルド

結論: 初回ビルド時 `-j` オプションは必須

#### 変更なし

```makefile
ifneq "$(BuildFlavour)" ""
include mk/flavours/$(BuildFlavour).mk
endif

STRIP_CMD = :
```

##### n1-standard-8 (Broadwell) + SSD (20GB)

time | -j |
-----|----|
real | |
user | |
sys	 | |

##### n1-standard-16 (Broadwell) + SSD (20GB)

time | -j | -j64 | -j32 | -j16 | -j8 | none |
-----|----|------|------|------|-----|------|
real | 25m43.549s | 25m41.320s | 25m49.189s | 25m27.498s | 26m33.077s | 104m57.999s |
user | 136m2.388s | 135m16.192s | 135m28.380s | 128m10.044s | 112m56.304s | 98m43.048s |
sys	 | 6m28.216s  | 6m25.296s | 6m16.864s | 5m57.400s | 5m16.548s | 4m31.972s |

##### n1-highcpu-16 (Broadwell) + SSD (20GB)

time | -j | -j64 | -j32 | -j16 | -j8 | none |
-----|----|------|------|------|-----|------|
real | 29m11.533s | | | | | |
user | 151m2.040s | | | | | |
sys	 | 8m21.668s | | | | | |

##### n1-highcpu-16 (Skylake) + SSD (20GB)

time | -j | -j64 | -j32 | -j16 | -j8 | none |
-----|----|------|------|------|-----|------|
real | | | | | | |
user | | | | | | |
sys	 | | | | | | |

##### custom (Skylake) + SSD (20GB)

- CPU: 64
- memory: 416GB

time | -j | -j64 | -j32 | -j16 | -j8 | none |
-----|----|------|------|------|-----|------|
real | | | | | | |
user | | | | | | |
sys	 | | | | | | |


#### V=0

結論: 初回ビルドでは効果無さそう

```makefile
V=0

ifneq "$(BuildFlavour)" ""
include mk/flavours/$(BuildFlavour).mk
endif

STRIP_CMD = :
```

##### n1-standard-16 (Broadwell) + SSD (20GB)

time | -j | -j64 | -j32 | -j16 | -j8 | none |
-----|----|------|------|------|-----|------|
real | 26m1.493s | | | | | |
user | 135m14.612s | | | | | |
sys	 | 6m13.868s | | | | | |


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
