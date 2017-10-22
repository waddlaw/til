# Well-Typed プログラムでも間違いが起きてしまう時

- 0除算
- key-value の構造で key が無い
- セグメンテーションフォールト
- ハートブリード

# リファインメント型

- 既存のHaskellの型システム + 述語
- SMT ソルバを利用する

# 必須依存関係

- Z3
- CVC4
- MathSat

上記のどれかをインストールしておく。

# stack を使ったインストール方法

# Dockerfile

# 停止しないプログラムの検査について

どちらかを使う。

- `liquid --no-termination` として実行
- `{-@ LIQUID "--no-termination" @-}` をソースファイルの先頭に記述
