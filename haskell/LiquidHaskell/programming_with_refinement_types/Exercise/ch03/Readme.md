# Refinement Types

```haskell
$ liquid
LiquidHaskell Version 0.8.2.2, Git revision 0eab6e5be11b889d5e2c83190594161120542c74 (dirty)
Copyright 2013-18 Regents of the University of California. All Rights Reserved.
```

## Exercise 3.1 (List Average)

`avg` 関数について以下の問いに答えよ。

1. なぜ `LiquidHaskell` は `n` に対してエラーを出すのか？
1. コードを変更して `LiquidHaskell` が `SAFE` となるようにせよ。

```haskell
avg :: [Int] -> Int
avg xs = divide total n
  where
    total = sum xs
    n     = length xs
```

### LiquidHaskell の結果

```shell
Error: Liquid Type Mismatch

 14 | avg xs = divide total n
               ^^^^^^^^^^^^^^

   Inferred type
     VV : {v : Int | v >= 0
                     && v == len xs
                     && v == n}

   not a subtype of Required type
     VV : {VV : Int | VV /= 0}

   In Context
     xs : {v : [Int] | len v >= 0}

     n : {n : Int | n >= 0
                    && n == len xs}
```

### 解答

入力に空リストが与えられると `n` が `0` になるためエラーとなる。

```haskell
{-@ type NonZero = { v:Int | v /= 0 } @-}

{-@ die :: { v:String | false } -> a @-}
die msg = error msg

{-@ divide :: Int -> NonZero -> Int @-}
divide :: Int -> Int -> Int
divide n 0 = die "divide by zero"
divide n d = n `div` d

avg :: [Int] -> Int
avg [] = 0
avg xs = divide total n
  where
    total = sum xs
    n     = length xs
```

## Exercise 3.2 (Propositions)

`isPositive` の型を削除したらどうなるだろうか？`LiquidHaskell` の結果を `SAFE` に保ったまま、`isPositive` の型を変更できるだろうか？ (つまり、別の型を書くということである)

### LiquidHaskell の結果

なし

### 解答

`isPositive` の型を削除すると、次のようなエラーが出る。

```shell
Error: Liquid Type Mismatch

 12 |   | isPositive d = "Result = " ++ show (n `divide` d)
                                              ^^^^^^^^^^^^

   Inferred type
     VV : {v : Int | v == d}

   not a subtype of Required type
     VV : {VV : Int | VV /= 0}

   In Context
     d : Int
```

```haskell
{-@ type NonZero = { v:Int | v /= 0 } @-}

{-@ die :: { v:String | false } -> a @-}
die msg = error msg

{-@ divide :: Int -> NonZero -> Int @-}
divide :: Int -> Int -> Int
divide n 0 = die "divide by zero"
divide n d = n `div` d

{-@ result :: Int -> NonZero -> String @-}
result :: Int -> Int -> String
result n d
  | isPositive d = "Result = " ++ show (n `divide` d)
  | otherwise    = "Humph, please enter positive denominator!"

isPositive :: Int -> Bool
isPositive x = x > 0
```












