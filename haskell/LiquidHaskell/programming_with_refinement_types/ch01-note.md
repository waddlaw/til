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
$ sudo apt-get install make autoconf libtool gcc g++ libgmp3-dev libboost-dev g++-multilib gcc-multilib openjdk-8-jdk

$ ./autogen.sh
$ ./contrib/get-antlr-3.4
$ ./configure --with-antlr-dir=`pwd`/antlr-3.4 ANTLR=`pwd`/antlr-3.4/bin/antlr3 --prefix=$CVC4PREF
$ make
$ make check
$ make install

$ cvc4 -V    
This is CVC4 version 1.6-prerelease [git master 6b5c27d7]
compiled with GCC version 5.4.0 20160609
on Oct 22 2017 12:35:07

Copyright (c) 2009-2017 by the authors and their institutional
affiliations listed at http://cvc4.cs.stanford.edu/authors

CVC4 is open-source and is covered by the BSD license (modified).

THIS SOFTWARE IS PROVIDED AS-IS, WITHOUT ANY WARRANTIES.
USE AT YOUR OWN RISK.

CVC4 incorporates code from ANTLR3 (http://www.antlr.org).
See licenses/antlr3-LICENSE for copyright and licensing information.

This version of CVC4 is linked against the following third party
libraries covered by the LGPLv3 license.
See licenses/lgpl-3.0.txt for more information.

  GMP - Gnu Multi Precision Arithmetic Library
  See http://gmplib.org for copyright information.

See the file COPYING (distributed with the source code, and with
all binaries) for the full CVC4 copyright, licensing, and (lack of)
warranty information.
```

## MathSat

上記のどれかをインストールしておく。

# stack を使ったインストール方法

# Dockerfile

# 停止しないプログラムの検査について

どちらかを使う。

- `liquid --no-termination` として実行
- `{-@ LIQUID "--no-termination" @-}` をソースファイルの先頭に記述
