# Boolean Measures

## Exercise 6.1 (Average, Maybe)

空リストの際に `Nothing` を返す関数 `average'` の実装を完成させよ。

```haskell
average' :: [Int] -> Maybe Int
average' xs
  | ok = Just $ divide (sum xs) elems
  | otherwise = Nothing
  where
    elems = size xs
    ok = True
```

### LiquidHaskell の結果

```shell
Error: Liquid Type Mismatch

 28 |   | ok = Just $ divide (sum xs) elems
                      ^^^^^^^^^^^^^^^^^^^^^

   Inferred type
     VV : {v : Int | v >= 0
                     && (Main.notEmpty xs => v > 0)
                     && v == elems}

   not a subtype of Required type
     VV : {VV : Int | VV /= 0}

   In Context
     elems : {elems : Int | elems >= 0
                            && (Main.notEmpty xs => elems > 0)}

     xs : {v : [Int] | len v >= 0}
```

### 解答

```haskell
{-@ type NonZero = { v:Int | v /= 0 } @-}

{-@ die :: {v:_ | false} -> a @-}
die msg = error msg

{-@ divide :: Int -> NonZero -> Int @-}
divide :: Int -> Int -> Int
divide _ 0 = die "divide-by-zero"
divide x n = x `div` n

{-@ size :: xs:[a] -> { v:Nat | notEmpty xs => v > 0} @-}
size :: [a] -> Int
size [] = 0
size (_:xs) = 1 + size xs

{-@ measure notEmpty @-}
notEmpty :: [a] -> Bool
notEmpty [] = False
notEmpty (_:_) = True

{-@ average' :: [Int] -> Maybe Int @-}
average' :: [Int] -> Maybe Int
average' [] = Nothing
average' xs = Just $ divide (sum xs) $ size xs
```
