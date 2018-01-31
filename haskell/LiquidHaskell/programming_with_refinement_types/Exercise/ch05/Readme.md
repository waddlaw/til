# Refined Datatypes

## Exercise 5.1 (Sanitization) *

私たちのプログラム内部の計算については不変条件が常に満たされています。一方で、**現実世界**からやってくるデータの正当性を保証するための唯一の方法は `Sparse` ベクターを構築する前に、不変条件が満たされているかどうか確認するためのサニタイザーを定義することです。

`fromList` サニタイザーの仕様と実装を定義し、以下の型チェックを通せ。

ヒント: `elts` に含まれる全てのインデックスが `dim` より小さいことをチェックする必要があります。もっとも簡単な方法は `Maybe [(Int, a)]` として計算してしまうことです。この時、妥当であれば `Just` で元の組を返し、そうでなければ `Nothing` とすれば良いでしょう。

```haskell
fromList :: Int -> [(Int, a)] -> Maybe (Sparse a)
fromList dim elts = undefined

{-@ test1 :: SparseN String 3 @-}
test1 :: Sparse String
test1 = fromJust $ fromList 3 [(1, "cat"), (2, "mouse")]
```

### LiquidHaskell の結果

### 解答

```haskell

```
