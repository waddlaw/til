# Elemental Measures

```haskell
$ liquid
LiquidHaskell Version 0.8.2.2, Git revision 82f5baa2e8e9eb70171d9cd49bde4297e94c2029 (dirty) (8382 commits) Copyright 2013-17 Regents of the University of California. All Rights Reserved.
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


