# Elemental Measures

```haskell
$ liquid
LiquidHaskell Version 0.8.2.2, Git revision 0eab6e5be11b889d5e2c83190594161120542c74 (dirty)
Copyright 2013-18 Regents of the University of California. All Rights Reserved.
```

## Exercise 8.1 (Bounded Addition)

`QuickCheck` で証明できるように定理 `∀x,y. x < 100 ∧ y < 100 ⇒ x + y < 200` を実装せよ。

```haskell
{-@ prop_x_y_200 :: _ -> _ -> True @-}
prop_x_y_200 x y = False
```

### LiquidHaskell の結果

```shell
Error: Liquid Type Mismatch

 4 | prop_x_y_200 x y = False
     ^^^^^^^^^^^^

   Inferred type
     VV : {v : Bool | not v
                      && v == GHC.Types.False}

   not a subtype of Required type
     VV : {VV : Bool | VV}

   In Context
```

### 解答

```haskell
{-@ type True  = {v:Bool |     v} @-}
{-@ type Implies P Q = {v:_ | v <=> (P => Q)} @-}

{-@ implies :: p:Bool -> q:Bool -> Implies p q @-}
implies :: Bool -> Bool -> Bool
implies False _    = True
implies _     True = True
implies _     _    = False

{-@ prop_x_y_200 :: _ -> _ -> True @-}
prop_x_y_200 x y = (x < 100 && y < 100) `implies` (x + y < 200)
```

一応 `QuickCheck` にもかけてみた。

```shell
*Main> import Test.QuickCheck
*Main Test.QuickCheck> quickCheck prop_x_y_200
+++ OK, passed 100 tests.
```

## Exercise 8.2 (Set Difference)

なぜ以下の性質は失敗するか答えよ。

```haskell
{-@ prop_cup_dif_bad :: _ -> _ -> True @-}
prop_cup_dif_bad :: (Ord a) => Set a -> Set a -> Bool
prop_cup_dif_bad x y = pre `implies` (x == ((x `union` y) `difference` y))
  where
    pre = True
```

1. `QuickCheck`  (またはベン図的なもの) を使って `prop_cup_dif_bad` の反例を見つけよ。
1. 見つけた反例を用いて、性質を証明するように `pre` を実装せよ。

### LiquidHaskell の結果

```shell
Error: Liquid Type Mismatch

 14 | prop_cup_dif_bad x y = pre `implies` (x == ((x `union` y) `difference` y))
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   Inferred type
     VV : {v : Bool | v <=> (pre => ?a)}

   not a subtype of Required type
     VV : {VV : Bool | VV}

   In Context
     pre : {pre : Bool | pre
                         && pre == GHC.Types.True}

     ?c : {?c : (Set a##xo) | ?c == Set_cup x y}

     ?b : {?b : (Set a##xo) | ?b == Set_dif ?c y}

     x : (Set a##xo)

     ?a : {?a : Bool | ?a <=> x == ?b}

     y : (Set a##xo)
```

### 解答

`x` と `y` のどちらの集合にも含まれる要素がある場合に成り立たない。

**その1**

`QuickCheck` を適用すると以下のような反例が見つかる。

```haskell
*Main> import Test.QuickCheck
*** Failed! Falsifiable (after 3 tests):
fromList [()]
fromList [()]
```

**その2**

```haskell
import Data.Set (Set, difference, empty, intersection, union)

{-@ type True  = {v:Bool |     v} @-}
{-@ type Implies P Q = {v:_ | v <=> (P => Q)} @-}

{-@ implies :: p:Bool -> q:Bool -> Implies p q @-}
implies :: Bool -> Bool -> Bool
implies False _    = True
implies _     True = True
implies _     _    = False

{-@ prop_cup_dif_bad :: _ -> _ -> True @-}
prop_cup_dif_bad :: (Ord a) => Set a -> Set a -> Bool
prop_cup_dif_bad x y = pre `implies` (x == ((x `union` y) `difference` y))
  where
    pre = empty == intersection x y
```

## Exercise 8.3 (Reverse)

`reverse'` が `LiquidHaskell` で `SAEF` となるように `revHelper` の型をかけ。

```haskell
import Data.Set (Set, empty, singleton, union)

{-@ measure elts @-}
elts :: (Ord a) => [a] -> Set a
elts []     = empty
elts (x:xs) = singleton x `union` elts xs

{-@ type ListS a S = {v:[a] | elts v = S} @-}
{-@ type ListEq a X = ListS a {elts X} @-}
{-@ type ListUn a X Y = ListS a {Set_cup (elts X) (elts Y)} @-}

{-@ reverse' :: xs:[a] -> ListEq a xs @-}
reverse' xs = revHelper [] xs

revHelper acc []     = acc
revHelper acc (x:xs) = revHelper (x:acc) xs
```

### LiquidHaskell の結果

```shell
Error: Liquid Type Mismatch

 14 | reverse' xs = revHelper [] xs
                    ^^^^^^^^^^^^^^^

   Inferred type
     VV : {v : [a##xo] | len v >= 0}

   not a subtype of Required type
     VV : {VV : [a##xo] | Main.elts VV == Main.elts xs}

   In Context
     xs : {v : [a##xo] | len v >= 0}


Error: Liquid Type Mismatch

 19 | revHelper acc (x:xs) = revHelper (x:acc) xs
                             ^^^^^^^^^^^^^^^^^

   Inferred type
     VV : {v : [a##xo] | Main.elts v == Set_cup (Set_sng x) (Main.elts acc)
                         && listElts v == Set_cup (Set_sng x) (listElts acc)
                         && len v == 1 + len acc
                         && tail v == acc
                         && head v == x
                         && len v >= 0
                         && v == ?a}

   not a subtype of Required type
     VV : {VV : [a##xo] | len VV < len acc
                          && len VV >= 0}

   In Context
     x : a##xo

     ?a : {?a : [a##xo] | Main.elts ?a == Set_cup (Set_sng x) (Main.elts acc)
                          && listElts ?a == Set_cup (Set_sng x) (listElts acc)
                          && len ?a == 1 + len acc
                          && tail ?a == acc
                          && head ?a == x
                          && len ?a >= 0}

     acc : {acc : [a##xo] | len acc >= 0}
```

### 解答

```haskell
import Data.Set (Set, empty, singleton, union)

{-@ measure elts @-}
elts :: (Ord a) => [a] -> Set a
elts []     = empty
elts (x:xs) = singleton x `union` elts xs

{-@ type ListS a S = {v:[a] | elts v = S} @-}
{-@ type ListEq a X = ListS a {elts X} @-}
{-@ type ListUn a X Y = ListS a {Set_cup (elts X) (elts Y)} @-}

{-@ reverse' :: xs:[a] -> ListEq a xs @-}
reverse' :: [a] -> [a]
reverse' xs = revHelper [] xs

{-@ revHelper :: xs:[a] -> ys:[a] -> ListUn a xs ys / [len ys] @-}
revHelper :: [a] -> [a] -> [a]
revHelper acc []     = acc
revHelper acc (x:xs) = revHelper (x:acc) xs
```

## Exercise 8.4 (Halve) *

`prop_halve_append` が `LiquidHaskell` で成り立つように `halve` の仕様を書け。

```haskell
halve :: Int -> [a] -> ([a], [a])
halve 0 xs       = ([], xs)
halve n (x:y:zs) = (x:xs, y:ys) where (xs, ys) = halve (n-1) zs
halve _ xs       = ([], xs)

{-@ prop_halve_append :: _ -> _ -> True @-}
prop_halve_append n xs = elts xs == elts xs'
  where
    xs'      = append' ys zs
    (ys, zs) = halve n xs
```

### LiquidHaskell の結果

```shell
Error: Liquid Type Mismatch

 37 | prop_halve_append n xs = elts xs == elts xs'
                               ^^^^^^^^^^^^^^^^^^^

   Inferred type
     VV : {v : Bool | v <=> ?b == ?a}

   not a subtype of Required type
     VV : {VV : Bool | VV}

   In Context
     xs : {v : [a##xo] | len v >= 0}

     xs' : {v : [a##xo] | Main.elts v == Set_cup (Main.elts ys) (Main.elts zs)
                          && len v >= 0}

     ?c : ([a##xo], [a##xo])

     ys : {ys : [a##xo] | len ys >= 0
                          && ys == fst ?c}

     ?b : {?b : (Set a##xo) | ?b == Main.elts xs}

     ?a : {?a : (Set a##xo) | ?a == Main.elts xs'}

     zs : {zs : [a##xo] | len zs >= 0
                          && zs == snd ?c}
```

### 解答

```haskell
import Data.Set (Set, empty, singleton, union)

{-@ type True  = {v:Bool |     v} @-}
{-@ type ListS a S = {v:[a] | elts v = S} @-}
{-@ type ListUn a X Y = ListS a {Set_cup (elts X) (elts Y)} @-}

{-@ measure elts @-}
elts :: (Ord a) => [a] -> Set a
elts []     = empty
elts (x:xs) = singleton x `union` elts xs

{-@ append' :: xs:_ -> ys:_ -> ListUn a xs ys @-}
append' :: [a] -> [a] -> [a]
append' [] ys     = ys
append' (x:xs) ys = x : append' xs ys

{-@ lazy halve @-}
{-@ halve :: Int -> xs:[a] -> {v:([a], [a]) | union (elts (fst v)) (elts (snd v)) = elts xs } @-}
halve :: Int -> [a] -> ([a], [a])
halve 0 xs = ([], xs)
halve n (x:y:zs) = (x:xs, y:ys) where (xs, ys) = halve (n-1) zs
halve _ xs = ([], xs)

{-@ prop_halve_append :: _ -> _ -> True @-}
prop_halve_append :: Ord a => Int -> [a] -> Bool
prop_halve_append n xs = elts xs == elts xs'
  where
    xs'      = append' ys zs
    (ys, zs) = halve n xs
```

## Exercise 8.5 (Membership)

`test1` と `test2` を満たすように `elem` のシグネチャを書け。

```haskell
{-@ elem :: (Eq a) => a -> [a] -> Bool @-}
elem _ [] = False
elem x (y:ys) = x == y || elem x ys

{-@ test1 :: True @-}
test1 = elem 2 [1,2,3]

{-@ test2 :: False @-}
test2 = elem 2 [1,3]
```

### LiquidHaskell の結果

```shell
Error: Liquid Type Mismatch

 20 | test1 = elem 2 [1,2,3]
              ^^^^^^^^^^^^^^

   Inferred type
     VV : Bool

   not a subtype of Required type
     VV : {VV : Bool | VV}

   In Context


Error: Liquid Type Mismatch

 24 | test2 = elem 2 [1,3]
              ^^^^^^^^^^^^

   Inferred type
     VV : Bool

   not a subtype of Required type
     VV : {VV : Bool | not VV}

   In Context
```

### 解答

```haskell
import Prelude hiding (elem)
import Data.Set (Set, empty, singleton, union, member)

{-@ type True  = {v:Bool |     v} @-}
{-@ type False = {v:Bool | not v} @-}

{-@ measure elts @-}
elts :: (Ord a) => [a] -> Set a
elts []     = empty
elts (x:xs) = singleton x `union` elts xs

{-@ elem :: (Eq a) => x:a -> xs:[a] -> { v:Bool | v = member x (elts xs) } @-}
elem :: Eq a => a -> [a] -> Bool
elem _ [] = False
elem x (y:ys) = x == y || elem x ys

{-@ test1 :: True @-}
test1 :: Bool
test1 = elem 2 [1,2,3]

{-@ test2 :: False @-}
test2 :: Bool
test2 = elem 2 [1,3]
```

## Exercise 8.6 (Merge)

`prop_merge_app` が `LiquidHaskell` で `SAFE` になるように `merge` の仕様を書け。

```haskell
merge [] ys = ys
merge xs [] = xs
merge (x:xs) (y:ys)
  | x <= y = x : merge xs (y:ys)
  | otherwise = y : merge (x:xs) ys

{-@ prop_merge_app :: _ -> _ -> True @-}
prop_merge_app xs ys = elts zs == elts zs'
  where
    zs = append' xs ys
    zs' = merge xs ys
```

### LiquidHaskell の結果

```shell
Error: Liquid Type Mismatch

 22 |   | otherwise = y : merge (x:xs) ys
                          ^^^^^^^^^^^^

   Inferred type
     VV : {v : [a##xo] | Main.elts v == Set_cup (Set_sng x) (Main.elts xs)
                         && listElts v == Set_cup (Set_sng x) (listElts xs)
                         && len v == 1 + len xs
                         && tail v == xs
                         && head v == x
                         && len v >= 0
                         && v == ?a}

   not a subtype of Required type
     VV : {VV : [a##xo] | len VV < len ?b
                          && len VV >= 0}

   In Context
     xs : {v : [a##xo] | len v >= 0}

     ?b : {?b : [a##xo] | len ?b >= 0}

     x : a##xo

     ?a : {?a : [a##xo] | Main.elts ?a == Set_cup (Set_sng x) (Main.elts xs)
                          && listElts ?a == Set_cup (Set_sng x) (listElts xs)
                          && len ?a == 1 + len xs
                          && tail ?a == xs
                          && head ?a == x
                          && len ?a >= 0}


 Error: Liquid Type Mismatch

 25 | prop_merge_app xs ys = elts zs == elts zs'
                             ^^^^^^^^^^^^^^^^^^^

   Inferred type
     VV : {v : Bool | v <=> ?b == ?a}

   not a subtype of Required type
     VV : {VV : Bool | VV}

   In Context
     xs : {v : [a##xo] | len v >= 0}

     ys : {ys : [a##xo] | len ys >= 0}

     ?b : {?b : (Set a##xo) | ?b == Main.elts zs}

     zs' : {zs' : [a##xo] | len zs' >= 0}

     ?a : {?a : (Set a##xo) | ?a == Main.elts zs'}

     zs : {zs : [a##xo] | Main.elts zs == Set_cup (Main.elts xs) (Main.elts ys)
                          && len zs >= 0}
```

### 解答

```haskell
import Data.Set (Set, empty, singleton, union)

{-@ type True  = {v:Bool |     v} @-}
{-@ type ListS a S = {v:[a] | elts v = S} @-}
{-@ type ListUn a X Y = ListS a {Set_cup (elts X) (elts Y)} @-}

{-@ measure elts @-}
elts :: (Ord a) => [a] -> Set a
elts []     = empty
elts (x:xs) = singleton x `union` elts xs

{-@ append' :: xs:_ -> ys:_ -> ListUn a xs ys @-}
append' :: [a] -> [a] -> [a]
append' [] ys     = ys
append' (x:xs) ys = x : append' xs ys

{-@ merge :: xs:[a] -> ys:[a] -> ListUn a xs ys / [len xs, len ys] @-}
merge [] ys = ys
merge xs [] = xs
merge (x:xs) (y:ys)
  | x <= y = x : merge xs (y:ys)
  | otherwise = y : merge (x:xs) ys

{-@ prop_merge_app :: _ -> _ -> True @-}
prop_merge_app xs ys = elts zs == elts zs'
  where
    zs = append' xs ys
    zs' = merge xs ys
```













