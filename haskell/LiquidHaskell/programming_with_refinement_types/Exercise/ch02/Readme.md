# Logic & SMT

```shell
$ liquid
LiquidHaskell Version 0.8.2.2, Git revision 0eab6e5be11b889d5e2c83190594161120542c74 (dirty)
Copyright 2013-18 Regents of the University of California. All Rights Reserved.
```

## Exercise 2.1 (Implications and Or)

もちろん `&&` を `||` で置き換えた場合は妥当では無い。

演算子を変更することなく、変数をシャッフルするだけで以下の論理式を妥当にせよ。

```haskell
{-@ ex3' :: Bool -> Bool -> TRUE @-}
ex3' a b = (a || b) ==> a
```

### LiquidHaskell の結果

```shell
Error: Liquid Type Mismatch

 12 | ex3' a b = (a || b) ==> a
                 ^^^^^^^^^^^^^^

   Inferred type
     VV : {v : Bool | v <=> (?a => a)}

   not a subtype of Required type
     VV : {VV : Bool | VV}

   In Context
     a : Bool

     b : Bool

     ?a : {?a : Bool | ?a <=> a
                              || b}
```

### 解答

```haskell
{-@ type TRUE = { v:Bool | v } @-}

{-@ (==>) :: p:Bool -> q:Bool -> { v:Bool | v <=> (p ==> q) } @-}

False ==> False = True
False ==> True  = True
True  ==> True  = True
True  ==> False = False

{-@ ex3' :: Bool -> Bool -> TRUE @-}
ex3' a b = a ==> (b || a)
```

## Exercise 2.2 (DeMorgan's Law)

以下のド・モルガンの法則は間違っている。修正して妥当な論理式にせよ。

```haskell
{-@ exDeMorgan2 :: Bool -> Bool -> TRUE @-}
exDeMorgan2 a b = not (a && b) <=> (not a && not b)
```

### LiquidHaskell の結果

```haskell
Error: Liquid Type Mismatch

 10 | exDeMorgan2 a b = not (a && b) <=> (not a && not b)
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   Inferred type
     VV : {v : Bool | v <=> (?b <=> ?d)}

   not a subtype of Required type
     VV : {VV : Bool | VV}

   In Context
     a : Bool

     ?c : {?c : Bool | ?c <=> a
                              && b}

     b : Bool

     ?e : {?e : Bool | ?e <=> not a}

     ?b : {?b : Bool | ?b <=> not ?c}

     ?d : {?d : Bool | ?d <=> ?e
                              && ?a}

     ?a : {?a : Bool | ?a <=> not b}
```

### 解答

```haskell
{-@ type TRUE = { v:Bool | v } @-}

{-@ (<=>) :: p:Bool -> q:Bool -> {v:Bool | v <=> (p <=> q) } @-}
False <=> False = True
False <=> True  = False
True  <=> True  = True
True  <=> False = False

{-@ exDeMorgan2 :: Bool -> Bool -> TRUE @-}
exDeMorgan2 a b = not (a && b) <=> (not a || not b)
```

## Exercise 2.3 (Addition and Order)

以下の論理式は妥当ではない。何故か答えよ。

また、仮定を変更して妥当な論理式にせよ。(`==>` の左側を修正すれば良い)

```haskell
{-@ ax6 :: Int -> Int -> TRUE @-}
ax6 x y = True ==> (x <= x + y)
```

### LiquidHaskell の結果

```haskell
Error: Liquid Type Mismatch

 12 | ax6 x y = True ==> (x <= x + y)
                ^^^^^^^^^^^^^^^^^^^^^

   Inferred type
     VV : {v : Bool | v <=> (GHC.Types.True => ?a)}

   not a subtype of Required type
     VV : {VV : Bool | VV}

   In Context
     ?b : {?b : Int | ?b == x + y}

     x : Int

     ?a : {?a : Bool | ?a <=> x <= ?b}

     y : Int
```

### 解答

`Int` 型なので `y` が負数になる可能性があるため。

```haskell
{-@ type TRUE = { v:Bool | v } @-}

{-@ (==>) :: p:Bool -> q:Bool -> { v:Bool | v <=> (p ==> q) } @-}

False ==> False = True
False ==> True  = True
True  ==> True  = True
True  ==> False = False

{-@ ax6 :: Int -> Int -> TRUE @-}
ax6 :: Int -> Int -> Bool
ax6 x y = (0 <= y) ==> (x <= x + y)
```
