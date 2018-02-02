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
