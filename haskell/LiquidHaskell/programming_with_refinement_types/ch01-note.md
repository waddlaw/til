# Well-Typed なプログラムでも間違いが起きてしまう例

- 0除算
- key-value の構造で key が無い
- セグメンテーションフォールト
- ハートブリード

# リファインメント型

- 既存のHaskellの型システム + 述語
- SMT ソルバを利用する

# 停止しないプログラムの検査について

どちらかを使う。

- `liquid --no-termination` として実行
- `{-@ LIQUID "--no-termination" @-}` をソースファイルの先頭に記述


# SMT について

- [SAT/SMTソルバの仕組み](https://www.slideshare.net/sakai/satsmt)

## liquid コマンドについて

`liquid` コマンドを実行するとカレントディレクトリに `.liquid` ディレクトリが生成される。これがアノテーションのファイル。

```bash
$ tree .liquid/
.liquid/
|-- 01-intro.lhs.bak
|-- 01-intro.lhs.bspec
|-- 01-intro.lhs.cst.html
|-- 01-intro.lhs.err
|-- 01-intro.lhs.html
|-- 01-intro.lhs.json
|-- 01-intro.lhs.smt2
|-- 01-intro.lhs.vim.annot
`-- liquid.css
```

# 環境構築

`Dockerfile` を用意したので詳しくはそっちを見てください。OS は `ubuntu:16.04 LTS` です。

アプリケーション | バージョン
------ | -----
stack | 1.5.1
z3 | 4.4.1
cvc4 | 1.6-prerelease [git master 6b5c27d7]
mathsat | 5.4.1 (3ca22be05d13)
liquidhaskell | 2013-17
vim | VIM - Vi IMproved 7.4 (2013 Aug 10, compiled Nov 24 2016 16:44:48)
emacs | GNU Emacs 24.5.1


## stack を使った liquidhaskell (git master) のインストール

```bash
# hint パッケージでこけるのでインストール
$ sudo apt-get install libtinfo-dev

$ git clone https://github.com/ucsd-progsys/liquidhaskell.git
$ cd liquidhaskell
$ stack setup
$ stack build
$ stack install

$ liquid --version
LiquidHaskell Copyright 2013-17 Regents of the University of California. All Rights Reserved.
```

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

## [MathSat5](http://mathsat.fbk.eu/download.html)

```bash
$ curl -L http://mathsat.fbk.eu/download.php?file=mathsat-5.4.1-linux-x86_64.tar.gz -o mathsat-5.4.1-linux-x86_64.tar.gz
$ tar xvf mathsat-5.4.1-linux-x86_64.tar.gz
$ cp mathsat-5.4.1-linux-x86_64/bin/mathsat /usr/local/bin/
$ mathsat -version
MathSAT5 version 5.4.1 (3ca22be05d13) (May 11 2017 17:18:01, gmp 6.1.0, gcc 4.8.5, 64-bit)
```

## プラグイン
### emacs 
- [Emacs’ flycheck plugin](https://github.com/ucsd-progsys/liquid-types.el)
- [2015年Emacsパッケージ事情](https://qiita.com/tadsan/items/6c658cc471be61cbc8f6)
- [cask/cask](https://github.com/cask/cask)
- [package.elから Caskに切り替えました](http://syohex.hatenablog.com/entry/20140424/1398310931)
- [rdallasgray/pallet](https://github.com/rdallasgray/pallet)

```bash
$ sudo apt-get install python
$ curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
$ export PATH="/root/.cask/bin:$PATH"
$ cd ~/.emacs.d
$ cask init
$ cask install
```

### vim
- [Vim’s syntastic checker](https://github.com/ucsd-progsys/liquid-types.vim)
- [vimコマンドを端末から実行する](https://qiita.com/yoan/items/6216646324f68e54809d)
- [dein.vimで設定したプラグインをシェルからインストール](https://qiita.com/junkjunctions/items/69964c81bd5b93379e71)
- [syntax - Vim日本語ドキュメント](http://vim-jp.org/vimdoc-ja/syntax.html)
- [vim-syntastic/syntastic](https://github.com/vim-syntastic/syntastic)
- [panagosg7/vim-annotations](https://github.com/panagosg7/vim-annotations)
- [begriffs/haskell-vim-now](https://github.com/begriffs/haskell-vim-now)
