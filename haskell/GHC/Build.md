# GHC

とても参考になります。

- [Resources for newcomers to GHC](https://ghc.haskell.org/trac/ghc/wiki/Newcomers)
- [Setting up a Linux system for building GHC](https://ghc.haskell.org/trac/ghc/wiki/Building/Preparation/Linux)
- [Fast rebuilding](https://ghc.haskell.org/trac/ghc/wiki/Building/Using#HowtomakeGHCbuildquickly)
- [Haskell GHCをソースからビルドする手順](https://qiita.com/takenobu-hs/items/c1309b93ca17b87e5955)

## ビルド方法

- 今回は `ghc-8.2.2-rc3` を対象にした。

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

GHC ビルド用の Dockerfile が用意されている。(今回は使ってない)

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

##### n1-standard-16 (Broadwell) + SSD (20GB) + asia-northeast1-a	

time | -j | -j64 | -j32 | -j16 | -j8 | none |
-----|----|------|------|------|-----|------|
real | 25m43.549s | 25m41.320s | 25m49.189s | 25m27.498s | 26m33.077s | 104m57.999s |
user | 136m2.388s | 135m16.192s | 135m28.380s | 128m10.044s | 112m56.304s | 98m43.048s |
sys	 | 6m28.216s  | 6m25.296s | 6m16.864s | 5m57.400s | 5m16.548s | 4m31.972s |

##### 色々なマシンタイプでビルドした結果 (`-j` オプション + SSD: 20GB + us-west1)

machine type | real | user | sys |
-----|------|------|-----|
n1-standard-8 (Broadwell) | 43m38.673s | 207m49.560s | 9m4.836s |
n1-standard-16 (Broadwell) | 33m35.458s | 181m44.796s | 9m18.284s |
n1-standard-32 (Broadwell) | 30m36.038s | 151m20.468s | 9m8.224s |
n1-standard-64 (Broadwell) | 21m3.820s | 101m32.456s | 6m52.124s |

machine type | real | user | sys |
-----|------|------|-----|
n1-standard-8 (Skylake) | 35m7.448s | 163m34.492s | 7m49.996s |
n1-standard-16 (Skylake) | 28m4.200s | 143m38.128s | 8m4.736s |
n1-standard-32 (Skylake) | 24m58.640s | 123m3.324s | 7m28.076s |
n1-standard-64 (Skylake) | 22m18.017s | 107m47.708s | 7m12.376s |

machine type | real | user | sys |
-----|------|------|-----|
n1-highmem-8 (Broadwell) | 32m0.106s | 148m31.856s | 7m9.996s |
n1-highmem-16 (Broadwell) | 29m11.533s | 151m2.040s | 8m21.668s |
n1-highmem-32 (Broadwell) | 23m24.097s | 115m29.908s | 7m2.080s |
n1-highmem-64 (Broadwell) | 24m3.772s | 117m12.660s | 8m5.072s |

machine type | real | user | sys |
-----|------|------|-----|
n1-highmem-8 (Skylake) | 32m56.001s | 152m16.408s | 7m17.568s |
n1-highmem-16 (Skylake) | 30m42.682s | 156m32.500s | 8m45.136s |
n1-highmem-32 (Skylake) | 26m6.185s | 128m45.560s | 8m0.376s |
n1-highmem-64 (Skylake) | 25m22.220s | 124m37.780s | 8m14.612s |

machine type | real | user | sys |
-----|------|------|-----|
n1-highcpu-8 (Broadwell) | 28m25.893s | 133m1.192s | 6m23.972s |
n1-highcpu-16 (Broadwell) | 24m35.758s | 125m35.276s | 6m55.000s |
n1-highcpu-32 (Broadwell) | | | |
n1-highcpu-64 (Broadwell) | | | |

machine type | real | user | sys |
-----|------|------|-----|
n1-highcpu-8 (Skylake) | | | |
n1-highcpu-16 (Skylake) | | | |
n1-highcpu-32 (Skylake) | | | |
n1-highcpu-64 (Skylake) | | | |

machine type | real | user | sys |
-----|------|------|-----|
n1-standard-96 | 21m42.379s | 104m57.016s | 7m34.600s |
n1-highmem-96 | 21m51.841s | 105m14.448s | 7m31.348s |
n1-highcpu-96 | 21m51.931s | 105m10.492s | 7m32.024s |


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
