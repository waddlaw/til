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
```

## [CVC4](http://cvc4.cs.stanford.edu/web/)

- [github](https://github.com/CVC4/CVC4)
- [rnbdev/cvc4_install.sh](https://gist.github.com/rnbdev/0ec49d578abde036f459a0a75d6cedf6)

## MathSat

上記のどれかをインストールしておく。

# stack を使ったインストール方法

# Dockerfile

# 停止しないプログラムの検査について

どちらかを使う。

- `liquid --no-termination` として実行
- `{-@ LIQUID "--no-termination" @-}` をソースファイルの先頭に記述
