# Case Study: Associative Maps

## Exercise 10.1 (Wellformedness Check)

### LiquidHaskell の結果

### 解答

```haskell
{-@ evalAny :: Env -> Expr -> Maybe Val @-}
evalAny :: Map Var Expr -> Expr -> Maybe Expr
evalAny g e
  | ok = Just $ eval g e
  | otherwise = Nothing
  where
    ok = free e `isSubsetOf` keys g
```
