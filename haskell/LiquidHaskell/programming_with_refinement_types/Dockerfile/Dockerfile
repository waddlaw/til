FROM ubuntu:16.04

# エディタのインストール
RUN apt-get update && apt-get install -y vim emacs

# stack のインストール
RUN apt-get install -y git curl
RUN curl -sSL https://get.haskellstack.org/ | sh

# SMT ソルバのインストール
## Z3
RUN apt-get install z3

## CVC4
RUN mkdir -p cvc4pref
RUN CVC4PREF=$HOME/cvc4pref
RUN apt-get install -y make autoconf libtool openjdk-8-jdk gcc g++ libgmp3-dev libboost-dev g++-multilib gcc-multilib
RUN git clone https://github.com/cvc4/cvc4
WORKDIR cvc4
RUN ./autogen.sh
RUN ./contrib/get-antlr-3.4
RUN ./configure --with-antlr-dir=`pwd`/antlr-3.4 ANTLR=`pwd`/antlr-3.4/bin/antlr3 --prefix=$CVC4PREF
RUN make
RUN make check
RUN make install
WORKDIR /

## MathSat5
RUN curl -L http://mathsat.fbk.eu/download.php?file=mathsat-5.4.1-linux-x86_64.tar.gz -o mathsat-5.4.1-linux-x86_64.tar.gz
RUN tar xvf mathsat-5.4.1-linux-x86_64.tar.gz
RUN cp mathsat-5.4.1-linux-x86_64/bin/mathsat /usr/local/bin/

# 最新版の LiquidHaskell をインストール
RUN apt-get install libtinfo-dev
RUN git clone --recursive https://github.com/ucsd-progsys/liquidhaskell.git
WORKDIR liquidhaskell
RUN stack setup
RUN stack build
RUN stack install
ENV PATH $PATH:/root/.local/bin

# エディタプラグインのインストール
## emacs
RUN apt-get install -y python
COPY emacs.d /root/.emacs.d/
WORKDIR /root/.emacs.d/
RUN git clone https://github.com/themattchan/liquid-tip.el.git
RUN curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
ENV PATH /root/.cask/bin:$PATH
WORKDIR /root/.emacs.d/
RUN cask install

## vim
WORKDIR /
RUN apt-get install -y sudo ctags
RUN curl -L https://git.io/haskell-vim-now > /tmp/haskell-vim-now.sh
RUN bash /tmp/haskell-vim-now.sh

COPY haskell-vim-now /root/.config/haskell-vim-now/
RUN vim +PlugInstall +qall

# sample コードの取得
WORKDIR /
RUN git clone https://github.com/ucsd-progsys/liquidhaskell-tutorial.git
WORKDIR liquidhaskell-tutorial/src
