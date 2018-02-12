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
    ok = validateExpr e && free e `isSubsetOf` keys g

{-@ lazy validateExpr @-}
validateExpr :: Expr -> Bool
validateExpr (Const _)     = True
validateExpr (Var _)       = True
validateExpr (Plus e1 e2)  = validateExpr e1 && validateExpr e2
validateExpr (Let _ e1 e2) = validateExpr e1 && validateExpr e2
```
