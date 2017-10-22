# Well-Typed プログラムでも間違いが起きてしまう時

- 0除算
- key-value の構造で key が無い
- セグメンテーションフォールト
- ハートブリード

# リファインメント型

- 既存のHaskellの型システム + 述語
- SMT ソルバを利用する

# 必須依存関係

## [Z3](https://github.com/Z3Prover/z3)

```bash
$ sudo apt-get update
$ sudo apt-get install z3
$ z3 --version
Z3 version 4.4.1
```

## [CVC4](http://cvc4.cs.stanford.edu/web/)

- [github](https://github.com/CVC4/CVC4)
- [rnbdev/cvc4_install.sh](https://gist.github.com/rnbdev/0ec49d578abde036f459a0a75d6cedf6)

```bash
$ git clone https://github.com/cvc4/cvc4

# install cvc4 locally
$ mkdir -p cvc4pref
$ CVC4PREF=$HOME/cvc4pref

# change directory to checkout
$ cd cvc4/

# to build from github checkout
$ sudo apt-get install make autoconf libtool

# to build
$ sudo apt-get install gcc g++ libgmp3-dev libboost-dev g++-multilib gcc-multilib

$ ./autogen.sh
$ ./contrib/get-antlr-3.4
$ ./configure --with-antlr-dir=`pwd`/antlr-3.4 ANTLR=`pwd`/antlr-3.4/bin/antlr3 --prefix=$CVC4PREF
$ make
$ make check
$ make install
```

## MathSat

上記のどれかをインストールしておく。

# stack を使ったインストール方法

# Dockerfile

# 停止しないプログラムの検査について

どちらかを使う。

- `liquid --no-termination` として実行
- `{-@ LIQUID "--no-termination" @-}` をソースファイルの先頭に記述
