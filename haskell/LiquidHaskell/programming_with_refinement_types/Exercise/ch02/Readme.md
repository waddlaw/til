# Logic & SMT

## Exercise 2.1 (Implications and Or)

もちろん `&&` を `||` で置き換えた場合は妥当では無い。

演算子を変更することなく、変数をシャッフルするだけで以下の論理式を妥当にせよ。

```haskell
{-@ ex3' :: Bool -> Bool -> TRUE @-}
ex3' a b = (a || b) ==> a
```

### LiquidHaskell の結果

### 解答

## Exercise 2.2 (DeMorgan's Law)

以下のド・モルガンの法則は間違っている。修正して妥当な論理式にせよ。

```haskell
{-@ exDeMorgan2 :: Bool -> Bool -> TRUE @-}
exDeMorgan2 a b = not (a && b) <=> (not a && not b)
```

### LiquidHaskell の結果

### 解答

## Exercise 2.3 (Addition and Order)

以下の論理式は妥当ではない。何故か答えよ。

また、仮定を変更して妥当な論理式にせよ。(`==>` の左側を変更するという意味である)

```haskell
{-@ ax6 :: Int -> Int -> TRUE @-}
ax6 x y = True ==> (x <= x + y)
```

### LiquidHaskell の結果

### 解答
