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

### 補足

`die` を無くした方がスッキリする。

```haskell
{-@ type NonZero = { v:Int | v /= 0 } @-}

{-@ divide :: Int -> NonZero -> Maybe Int @-}
divide :: Int -> Int -> Maybe Int
divide _ 0 = Nothing
divide x n = Just $ x `div` n

{-@ measure notEmpty @-}
notEmpty :: [a] -> Bool
notEmpty [] = False
notEmpty (_:_) = True

{-@ size :: xs:[a] -> { v:Nat | notEmpty xs => v > 0} @-}
size :: [a] -> Int
size [] = 0
size (_:xs) = 1 + size xs

{-@ average' :: [Int] -> Maybe Int @-}
average' :: [Int] -> Maybe Int
average' [] = Nothing
average' xs = divide (sum xs) $ size xs
```

## Exercise 6.2 (Debugging Specifications)

`LiquidHaskell` のような形式検証ツールにとって重要なことは、あなたの実装だけでなく、より重要な仕様についても性質を保証するための手助けをしてくれます。それを踏まえた上で、以下の `size` の変種がなぜ `LiquidHaskell` によって拒否されるかわかりますか？

```haskell
{-@ size1 :: xs:NEList a -> Pos @-}
size1 [] = 0
size1 (_:xs) = 1 + size1 xs

{-@ size2 :: xs:[a] -> { v:Int | notEmpty xs => v > 0} @-}
size2 [] = 0
size2 (_:xs) = 1 + size2 xs
```

### LiquidHaskell の結果

`size1` についての結果。

```shell
Error: Liquid Type Mismatch

 12 | size1 (_:xs) = 1 + size1 xs
                         ^^^^^^^^

   Inferred type
     VV : {v : [a] | len v >= 0
                     && v == xs}

   not a subtype of Required type
     VV : {VV : [a] | Main.notEmpty VV
                      && len VV < len ?a
                      && len VV >= 0}

   In Context
     xs : {v : [a] | len v >= 0}

     ?a : {?a : [a] | Main.notEmpty ?a
                      && len ?a >= 0}
```

`size2` についての結果。

```shell
Error: Liquid Type Mismatch

 17 | size2 (_:xs) = 1 + size2 xs
                     ^^^^^^^^^^^^

   Inferred type
     VV : {v : Int | v == ?c + ?b}

   not a subtype of Required type
     VV : {VV : Int | Main.notEmpty ?a => VV > 0}

   In Context
     xs : {v : [a] | len v >= 0}

     ?c : {?c : Int | ?c == (1 : int)}

     ?b : {?b : Int | Main.notEmpty xs => ?b > 0}

     ?a : {?a : [a] | len ?a >= 0}
```

### 解答

**size1**

`size1` の第1引数は `NEList a` だが、 `1 + size1 xs` で `xs` が空リストになるため。

**size2**

`size2` の返り値の型は `notEmpty xs` が成り立たない場合に負の数も取りうる （`Int`） ため、`1 + size2 xs` で怒られる。
`Int` の代わりに `Nat` であれば、 `notEmpty xs` が成り立たない場合でも `v > 0` であることが保証される。

## Exercise 6.3 (Safe Head)

`safeHead` が正しく動作するように `null` の仕様を書け。ただし、`null` が非空の入力のみをとるように強制する方法は目的に沿わないため不可とする。その代わり、型を変更することで、任意のリストについて動作し、入力が空でなければ `True` を返すようにせよ。(その逆もまた然り)

```haskell
safeHead :: [a] -> Maybe a
safeHead xs
  | null xs = Nothing
  | otherwise = Just $ head xs

null       :: [a] -> Bool
null []    = True
null (_:_) = False
```

### LiquidHaskell の結果

```shell
Error: Liquid Type Mismatch

 26 |   | otherwise = Just $ head xs
                             ^^^^^^^

   Inferred type
     VV : {v : [a] | len v >= 0
                     && v == xs}

   not a subtype of Required type
     VV : {VV : [a] | Main.notEmpty VV}

   In Context
     xs : {v : [a] | len v >= 0}
```

### 解答

```haskell
import Prelude hiding (head, null)

{-@ die :: {v:_ | false} -> a @-}
die msg = error msg

{-@ measure notEmpty @-}
notEmpty :: [a] -> Bool
notEmpty [] = False
notEmpty (_:_) = True

{-@ type NEList a = { v:[a] | notEmpty v} @-}

{-@ head :: NEList a -> a @-}
head :: [a] -> a
head [] = die "Fear not! 'twill ne'er come to pass"
head (x:_) = x

{-@ null :: xs:[a] -> { v:Bool | notEmpty xs <=> not v } @-}
null :: [a] -> Bool
null [] = True
null (_:_) = False

safeHead :: [a] -> Maybe a
safeHead xs
  | null xs = Nothing
  | otherwise = Just $ head xs
```

## Exercise 6.4 (Weighted Average)

以下の関数は与えられた入力の加重平均を計算する。しかし、`LiquidHaskell` はこれを拒否する。

なぜエラーとなるか答えよ。また、コードまたは仕様を適切に修正せよ。

```haskell
{-@ wtAverage :: NEList (Pos, Pos) -> Int @-}
wtAverage :: [(Int, Int)] -> Int
wtAverage wxs = divide totElems totWeight
  where
    elems     = map (\(w, x) -> w * x) wxs
    weights   = map (\(w, _) -> w  ) wxs
    totElems  = sum elems
    totWeight = sum weights
    sum = foldl1 (+)
    
map :: (a -> b) -> [a] -> [b]
map _ [] = []
map f (x:xs) = f x : map f xs
```

### LiquidHaskell の結果

```haskell
Error: Liquid Type Mismatch

 35 |     totElems  = sum elems
                      ^^^^^^^^^

   Inferred type
     VV : {v : [Int] | len v >= 0
                       && v == elems}

   not a subtype of Required type
     VV : {VV : [{v : Int | v > 0
                            && v /= 0
                            && v >= 0}] | Main.notEmpty VV}

   In Context
     elems : {elems : [Int] | len elems >= 0}


Error: Liquid Type Mismatch

 36 |     totWeight = sum weights
                      ^^^^^^^^^^^

   Inferred type
     VV : {v : [Int] | len v >= 0
                       && v == weights}

   not a subtype of Required type
     VV : {VV : [{v : Int | v > 0
                            && v /= 0
                            && v >= 0}] | Main.notEmpty VV}

   In Context
     weights : {weights : [Int] | len weights >= 0}
```

### 解答

`wxs` は `NEList (Pos, Pos)` であるので `elems` と `weights` は `NEList (Pos, Pos)` であることが予想されるが、
`map` は空リストを返す可能性があるため `sum elems` と `sum weights` で怒られる．

#### 仕様を修正

```haskell
import Prelude hiding (map, foldl, foldl1)

{-@ type NonZero = { v:Int | v /= 0 } @-}
{-@ type Pos = { v:Int | v > 0 } @-}

{-@ measure notEmpty @-}
notEmpty :: [a] -> Bool
notEmpty [] = False
notEmpty (_:_) = True

{-@ type NEList a = { v:[a] | notEmpty v} @-}

{-@ die :: {v:_ | false} -> a @-}
die msg = error msg

{-@ divide :: Int -> NonZero -> Int @-}
divide :: Int -> Int -> Int
divide _ 0 = die "divide-by-zero"
divide x n = x `div` n

{-@ foldl1 :: (a -> a -> a) -> NEList a -> a @-}
foldl1 f (x:xs)    = foldl f x xs
foldl1 _ []        = die "foldl1"

foldl              :: (a -> b -> b) -> b -> [a] -> b
foldl _ acc []     = acc
foldl f acc (x:xs) = foldl f (f x acc) xs

{-@ wtAverage :: NEList (Pos, Pos) -> Int @-}
wtAverage :: [(Int, Int)] -> Int
wtAverage wxs = divide totElems totWeight
  where
    elems     = map (\(w, x) -> w * x) wxs
    weights   = map (\(w, _) -> w  ) wxs
    totElems  = sum elems
    totWeight = sum weights
    sum = foldl1 (+)

{-@ map :: (a -> b) -> xs:[a] -> { ys:[b] | notEmpty xs => notEmpty ys } @-}
map :: (a -> b) -> [a] -> [b]
map _ [] = []
map f (x:xs) = f x : map f xs
```
