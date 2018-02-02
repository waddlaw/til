# Elemental Measures

```haskell
$ liquid
LiquidHaskell Version 0.8.2.2, Git revision 82f5baa2e8e9eb70171d9cd49bde4297e94c2029 (dirty) (8382 commits) Copyright 2013-17 Regents of the University of California. All Rights Reserved.
```

## Exercise 8.1 (Bounded Addition)

`QuickCheck` スタイルで定理 `∀x,y. x < 100 ∧ y < 100 ⇒ x + y < 200` を証明せよ。

```haskell
{-@ prop_x_y_200 :: _ -> _ -> True @-}
prop_x_y_200 x y = False
```
