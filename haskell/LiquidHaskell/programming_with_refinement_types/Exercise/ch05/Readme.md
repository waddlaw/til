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

`SAFE` となる。

### 解答

```haskell
import Data.Maybe (fromJust)

{-@ type Btwn Lo Hi = { v:Int | Lo <= v && v < Hi} @-}

{-@ data Sparse a = SP
  { spDim :: Nat
  , spElems :: [(Btwn 0 spDim, a)]
  }
@-}
data Sparse a = SP
  { spDim :: Int
  , spElems :: [(Int, a)]
  } deriving Show

{-@ type SparseN a N = { v:Sparse a | spDim v == N } @-}

{-@ fromList :: d:Nat -> [(Int, a)] -> Maybe (SparseN a d) @-}
fromList :: Int -> [(Int, a)] -> Maybe (Sparse a)
fromList dim elts = SP dim <$> mapM check elts
  where
    check (x, y)
      | 0 <= x && x < dim = Just (x,y)
      | otherwise = Nothing

{-@ test1 :: SparseN String 3 @-}
test1 :: Sparse String
test1 = fromJust $ fromList 3 [(1, "cat"), (2, "mouse")]
```

## Exercise 5.2 (Addition)

同じ次元の `Sparse` ベクター同士を足し合わせる関数 `plus` の仕様と実装を定義せよ。

出来上がった関数に対して型チェックが通ることを確認せよ。

```haskell
plus :: (Num a) => Sparse a -> Sparse a -> Sparse a
plus x y = undefined

{-@ test2 :: SparseN Int 3 @-}
test2 :: Sparse Int
test2 = plus vec1 vec2
  where
    vec1 = SP 3 [(0, 12), (2, 9)]
    vec2 = SP 3 [(0, 8), (1, 100)]
```

### LiquidHaskell の結果

```shell
Error: Liquid Type Mismatch

 33 | test2 = plus vec1 vec2
              ^^^^^^^^^^^^^^

   Inferred type
     VV : (Sparse Int)

   not a subtype of Required type
     VV : {VV : (Sparse Int) | Main.spDim VV == 3}

   In Context
```

### 解答

```haskell
{-@ type Btwn Lo Hi = { v:Int | Lo <= v && v < Hi} @-}

{-@
data Sparse a = SP
  { spDim :: Nat
  , spElems :: [(Btwn 0 spDim, a)]
  }
@-}
data Sparse a = SP
  { spDim :: Int
  , spElems :: [(Int, a)]
  } deriving Show

{-@ type SparseN a N = { v:Sparse a | spDim v == N } @-}

{-@ plus :: Num a => v1:Sparse a -> SparseN a (spDim v1) -> SparseN a (spDim v1) @-}
plus :: Num a => Sparse a -> Sparse a -> Sparse a
plus (SP d x) (SP _ y) = SP d (x' ++ y' ++ xy)
  where
    xis = map fst x
    yjs = map fst y
    x'  = filter (\(i, _) -> i `notElem` yjs) x
    y'  = filter (\(i, _) -> i `notElem` xis) y
    xy  = [ (i, v+w) | (i, v) <- x , (j, w) <- y
                     , i == j ]

{-@ test2 :: SparseN Int 3 @-}
test2 :: Sparse Int
test2 = plus vec1 vec2
  where
    vec1 = SP 3 [(0, 12), (2, 9)]
    vec2 = SP 3 [(0, 8), (1, 100)]
```

### 補足

`Peals` でやっていたように条件を厳しくして高速化してみた。

```haskell
{-@ type Btwn Lo Hi = { v:Int | Lo <= v && v < Hi} @-}

{-@
data Sparse a = SP
  { spDim :: Nat
  , spElems :: [(Btwn 0 spDim, a)]
  }
@-}
data Sparse a = SP
  { spDim :: Int
  , spElems :: [(Int, a)]
  } deriving Show

{-@ type SparseN a N = { v:Sparse a | spDim v == N } @-}

-- 仮定その1: 昇順
-- 仮定その2: 重複しない
{-@ plus :: Num a => v:Sparse a -> SparseN a (spDim v) -> SparseN a (spDim v) @-}
plus :: (Num a) => Sparse a -> Sparse a -> Sparse a
plus (SP d xs) (SP _ ys) = SP d $ plus' xs ys
  where
    {-@ plus' :: xs:_ -> ys:_ -> zs:_ / [len xs, len ys] @-}
    plus' xs [] = xs
    plus' [] ys = ys
    plus' xs@((i1, v1):xs') ys@((i2, v2):ys')
      | i1 == i2 = (i1, v1 + v2) : plus' xs' ys'
      | i1 < i2 = (i1, v1) : plus' xs' ys
      | otherwise = (i2, v2) : plus' xs ys'

{-@ test2 :: SparseN Int 3 @-}
test2 :: Sparse Int
test2 = plus vec1 vec2
  where
    vec1 = SP 3 [(0, 12), (2, 9)]
    vec2 = SP 3 [(0, 8), (1, 100)]
```

コメントの仮定は `LiquidHaskell` で書けそう。あとで試す。





