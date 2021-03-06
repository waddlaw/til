# Polymorphism

```shell
$ liquid
LiquidHaskell Version 0.8.2.2, Git revision 82f5baa2e8e9eb70171d9cd49bde4297e94c2029 (dirty) (8382 commits) Copyright 2013-17 Regents of the University of California. All Rights Reserved.
```

## Exercise 4.1 (Vector Head)

`head''` の `undefined` を入力の `vec` が空でない時のみ値を返すような実装に置き換えよ。

```haskell
head'' :: Vector a -> Maybe a
head'' vec = undefined
```

### LiquidHaskell の結果

上記のコードを `LiquidHaskell` にかけると `SAFE` となる。

### 解答

```haskell
import Prelude hiding (head, null)
import Data.Vector

{-@ head' :: Vector a -> Maybe a @-}
head'' :: Vector a -> Maybe a
head'' vec
  | null vec  = Nothing
  | otherwise = Just $ head vec
```

## Exercise 4.2 (Unsafe Lookup)

`unsafeLookup` 関数は `(!)` 演算子の引数を反転させた関数である。

以下の実装が `LiquidHaskell` で受理されるように `unsafeLookup` 関数の仕様を変更せよ。

```haskell
{-@ unsafeLookup :: Int -> Vector a -> a @-}
unsafeLookup index vec = vec ! index
```

### LiquidHaskell の結果

```shell
Error: Liquid Type Mismatch

 7 | unsafeLookup index vec = vec ! index
                              ^^^^^^^^^^^

   Inferred type
     VV : {v : Int | v == index}

   not a subtype of Required type
     VV : {VV : Int | VV >= 0
                      && VV < vlen vec}

   In Context
     vec : {vec : (Vector a) | 0 <= vlen vec}

     index : Int
```

### 解答

```haskell
import Data.Vector

-- Exercise 4.2
{-@ unsafeLookup :: x:Nat -> {v:Vector a | x < vlen v} -> a @-}
unsafeLookup :: Int -> Vector a -> a
unsafeLookup index vec = vec ! index
```

## Exercise 4.3 (Safe Lookup)

ベクターの要素にアクセスする前に境界値チェックを実行したい。

関数 `ok` を適切に実装し、`safeLookup` の実装を完成させよ。

```haskell
{-@ safeLookup :: Vector a -> Int -> Maybe a @-}
safeLookup :: Vector a -> Int -> Maybe a
safeLookup x i
    | ok        = Just (x ! i)
    | otherwise = Nothing
    where
      ok        = undefined
```

### LiquidHaskell の結果

上記のコードは `SAFE` である。

### 解答

```haskell
import Prelude hiding (length)
import Data.Vector

{-@ safeLookup :: Vector a -> Int -> Maybe a @-}
safeLookup :: Vector a -> Int -> Maybe a
safeLookup x i
    | ok        = Just (x ! i)
    | otherwise = Nothing
    where
      ok        = 0 <= i && i < length x
```

## Exercise 4.4 (Guards)

以下の `vectorSum` の実装で `i < sz` を `i <= sz` にすると何が起きるか？

```haskell
import Prelude hiding (length)
import Data.Vector

{-@ vectorSum :: {v:Vector Int | 0 <= vlen v} -> Int @-}
vectorSum ::  Vector Int -> Int
vectorSum vec = go 0 0
  where
    {-@ lazy go @-}
    {-@ go :: Int -> i:{n:Nat | n <= vlen vec} -> Int @-}
    go acc i
      | i < sz = go (acc + (vec ! i)) (i + 1)
      | otherwise = acc
    sz = length vec
```

### LiquidHaskell の結果

`i < sz` の場合は当然 `SAFE` である。

`i <= sz` の場合、以下のメッセージが表示される。

```shell
Error: Liquid Type Mismatch

 11 |       | i <= sz = go (acc + (vec ! i)) (i + 1)
                                   ^^^^^^^

   Inferred type
     VV : {v : Int | v >= 0
                     && v <= vlen vec
                     && v == i}

   not a subtype of Required type
     VV : {VV : Int | VV >= 0
                      && VV < vlen vec}

   In Context
     vec : {vec : (Vector Int) | 0 <= vlen vec}

     i : {i : Int | i >= 0
                    && i <= vlen vec}


Error: Liquid Type Mismatch

 11 |       | i <= sz = go (acc + (vec ! i)) (i + 1)
                                              ^^^^^

   Inferred type
     VV : {v : Int | v == i + ?a
                     && v == ?b}

   not a subtype of Required type
     VV : {VV : Int | VV >= 0
                      && VV <= vlen vec}

   In Context
     ?b : {?b : Int | ?b == i + ?a}

     vec : {vec : (Vector Int) | 0 <= vlen vec}

     ?a : {?a : Int | ?a == (1 : int)}

     i : {i : Int | i >= 0
                    && i <= vlen vec}
```

### 解答

`i <= sz` に変更すると `vec` の長さを超えて要素を参照するので以下のように実行時エラーが発生する。

```shell
*Main> vectorSum (fromList [1, -2, 3])
*** Exception: ./Data/Vector/Generic.hs:245 ((!)): index out of bounds (3,3)
CallStack (from HasCallStack):
  error, called at ./Data/Vector/Internal/Check.hs:87:5 in vector-0.12.0.1-CnPH69pDwM4A5esizlXfXi:Data.Vector.Internal.Check
```

### 補足

`vectorSum` の内部関数 `go` に `lazy` キーワードを指定しない場合は以下のエラーが発生する。

```shell
Error: Liquid Type Mismatch

11 |       | i < sz = go (acc + (vec ! i)) (i + 1)
                           ^^^^^^^^^^^^^^^

   Inferred type
     VV : {v : Int | v == acc + ?b
                     && v == ?a}

   not a subtype of Required type
     VV : {VV : Int | VV < acc
                      && VV >= 0}

   In Context
     ?b : Int

     ?a : {?a : Int | ?a == acc + ?b}

     acc : Int
```

これは停止性の判定を `go` の第一引数で行なっているが、減少関数ではないためエラーが発生していると思われる。

`Int` ではなく `Num a` にすると、以下のように、また違うエラーメッセージが表示される。

```sell
Error: Liquid Type Mismatch

 23 |       | i < sz = go (acc + (vec ! i)) (i + 1)
                                             ^^^^^

   Inferred type
     VV : {v : Int | v == i + ?a
                     && v == ?b}

   not a subtype of Required type
     VV : {VV : Int | VV >= 0
                      && VV <= vlen vec
                      && VV < i}

   In Context
     ?b : {?b : Int | ?b == i + ?a}

     vec : {vec : (Vector a) | 0 <= vlen vec}

     ?a : {?a : Int | ?a == (1 : int)}

     i : {i : Int | i >= 0
                    && i <= vlen vec}
```

そのため、以下のような減少関数とすることで `lazy` キーワードを用いずに実装することも可能である。

```haskell
{-@ vectorSumDec :: {v:Vector Int | 0 < vlen v} -> Int @-}
vectorSumDec :: Vector Int -> Int
vectorSumDec vec = go 0 (sz - 1)
  where
    {-@ go :: Int -> {n:Nat | n < vlen vec} -> Int / [n] @-}
    go acc i
      | i == 0 = acc + (vec ! 0)
      | otherwise = go (acc + (vec ! i)) (i - 1)
    sz = length vec
```

## Exercise 4.5 (Absolute Sum)

ベクターの要素の絶対値の合計を計算する `absoluteSum` 関数を定義せよ。

```haskell
-- >>> absoluteSum (fromList [1, -2, 3])
-- 6
{-@ absoluteSum :: Vector Int -> Nat @-}
absoluteSum :: Vector Int -> Int
absoluteSum vec = undefined
```

### LiquidHaskell の結果

上記コードは `SAFE` である。

## 解答

```haskell
import Prelude hiding (length, abs)
import Data.Vector

{-@ abs :: Int -> Nat @-}
abs :: Int -> Int
abs n
  | 0 < n = n
  | otherwise = 0 - n

{-@ absoluteSum :: Vector Int -> Nat @-}
absoluteSum :: Vector Int -> Int
absoluteSum vec = go 0 0
  where
    {-@ lazy go @-}
    {-@ go :: Nat -> {n:Nat | n <= vlen vec} -> Nat @-}
    go acc i
      | i < sz = go (acc + abs (vec ! i)) (i + 1)
      | otherwise = acc
    sz = length vec
```

## 補足

`abs` は `Num` のメソッドだが、 `LiquidHaskell` では自分で定義する必要があるようだ。

## Exercise 4.6 (Off by one?)

なぜ、関数 `go` は `v < sz` ではなく `v <= sz` の型になるのか？

### LiquidHaskell の結果

無し。

### 解答

`go` の引数 `i` は `i == sz` のとき `otherwise` とマッチするため `v <= sz` となる。

## Exercise 4.7 (Using Higher-Order Loops)

以下の `absoluteSum'` 関数の実装を完成させよ。

また、`body` の型が、どのように推論されるか答えよ。

```haskell
-- >>> absoluteSum' (fromList [1, -2, 3])
-- 6
{-@ absoluteSum' :: Vector Int -> Nat @-}
absoluteSum' :: Vector Int -> Int
absoluteSum' vec = loop 0 n 0 body
  where
    body i acc = undefined
    n = length vec
```

### LiquidHaskell の結果

上記のコードを `LiquidHaskell` にかけると `SAFE` となる。

### 解答

```haskell
import Prelude hiding (length, abs)
import Data.Vector

{-@ type Btwn Lo Hi = { v:Int | Lo <= v && v < Hi} @-}

{-@ abs :: Int -> Nat @-}
abs :: Int -> Int
abs n
  | 0 < n = n
  | otherwise = 0 - n

{-@ loop :: lo:Nat -> hi:{ Nat | lo <= hi } -> a -> (Btwn lo hi -> a -> a) -> a @-}
loop :: Int -> Int -> a -> (Int -> a -> a) -> a
loop lo hi base f = go base lo
  where
    {-@ lazy go @-}
    go acc i
      | i < hi = go (f i acc) (i + 1)
      | otherwise = acc

{-@ absoluteSum' :: Vector Int -> Nat @-}
absoluteSum' :: Vector Int -> Int
absoluteSum' vec = loop 0 n 0 body
  where
    {-@ body :: {x:Nat | x < vlen vec} -> Nat -> Nat @-}
    body i acc = acc + abs (vec ! i)
    n = length vec
```

## Exercise 4.8 (Dot Product)

以下の `dotProduct` 関数は `loop` を使って定義されている。

```haskell
-- >>> dotProduct (fromList [1, 2, 3]) (fromList [4, 5, 6])
-- 32
{-@ dotProduct :: x:Vector Int -> y:Vector Int -> Int @-}
dotProduct :: Vector Int -> Vector Int -> Int
dotProduct x y = loop 0 sz 0 body
  where
    body i acc = acc + (x ! i) * (y ! i)
    sz = length x
```

`LiquidHaskell` でエラーが発生する理由を述べよ。また、コードか仕様を修正し `LiquidHaskell` の 結果を`SAFE` にせよ。

### LiquidHaskell の結果

```shell
Error: Liquid Type Mismatch

 19 |     body i acc = acc + (x ! i) * (y ! i)
                                        ^^^^^

   Inferred type
     VV : {v : Int | v /= sz
                     && v <= sz
                     && v <= vlen x
                     && v < vlen x
                     && v < sz
                     && v >= 0
                     && v == i}

   not a subtype of Required type
     VV : {VV : Int | VV >= 0
                      && VV < vlen y}

   In Context
     sz : {sz : Int | sz >= 0
                      && sz == vlen x}

     x : {v : (Vector Int) | 0 <= vlen v}

     i : {i : Int | i /= sz
                    && i <= sz
                    && i <= vlen x
                    && i < vlen x
                    && i < sz
                    && i >= 0}

     y : {y : (Vector Int) | 0 <= vlen y}
```


### 解答

`length x > length y` の可能性があるため。

### コードを修正したバージョン

```haskell
import Prelude hiding (length)
import Data.Vector

{-@ type Btwn Lo Hi = { v:Int | Lo <= v && v < Hi} @-}

{-@ loop :: lo:Nat -> hi:{ Nat | lo <= hi } -> a -> (Btwn lo hi -> a -> a) -> a @-}
loop :: Int -> Int -> a -> (Int -> a -> a) -> a
loop lo hi base f = go base lo
  where
    {-@ lazy go @-}
    go acc i
      | i < hi = go (f i acc) (i + 1)
      | otherwise = acc
      
{-@ dotProduct :: Vector Int -> Vector Int -> Maybe Int @-}
dotProduct :: Vector Int -> Vector Int -> Maybe Int
dotProduct x y
  | length x == length y = Just $ loop 0 sz 0 body
  | otherwise = Nothing
  where
    body i acc = acc + (x ! i) * (y ! i)
    sz
      | length x > length y = length y
      | otherwise = length x
```

### 仕様を修正したバージョン

```haskell
import Prelude hiding (length)
import Data.Vector

{-@ type Btwn Lo Hi = { v:Int | Lo <= v && v < Hi} @-}

{-@ loop :: lo:Nat -> hi:{ Nat | lo <= hi } -> a -> (Btwn lo hi -> a -> a) -> a @-}
loop :: Int -> Int -> a -> (Int -> a -> a) -> a
loop lo hi base f = go base lo
  where
    {-@ lazy go @-}
    go acc i
      | i < hi = go (f i acc) (i + 1)
      | otherwise = acc
      
{-@ dotProduct :: x:Vector Int -> {y:Vector Int | vlen x == vlen y} -> Int @-}
dotProduct :: Vector Int -> Vector Int -> Int
dotProduct x y = loop 0 sz 0 body
  where
    body i acc = acc + (x ! i) * (y ! i)
    sz = length x
```

