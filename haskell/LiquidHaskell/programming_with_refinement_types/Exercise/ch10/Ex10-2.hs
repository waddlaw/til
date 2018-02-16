-- | Exercise 10.2 (Closures)

data Expr = Const Int
          | Var Var
          | Plus Expr Expr
          | Let Var Expr Expr
          | Fun Var Expr
          | App Expr Expr

{-@ lazy free @-}
{-@ measure free @-}
free :: Expr -> Set Var
free (Const _) = empty
free (Var x) = singleton x
free (Plus e1 e2) = xs1 `union` xs2
  where
    xs1 = free e1
    xs2 = free e2
free (Let x e1 e2) = xs1 `union` (xs2 `difference` xs)
  where
    xs1 = free e1
    xs2 = free e2
    xs = singleton x
free (Fun v e) = free e `union` singleton v
free (App e1 e2) = free e1 `union` free e2