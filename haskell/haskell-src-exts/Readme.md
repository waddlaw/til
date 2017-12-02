# haskell-src-exts

## Syntax

### Module

```haskell

-- Module _ Nothing [] [] []
```

これ以降、モジュールの部分は省略する。

### PatBind

```haskell
f = 1
-- PatBind _ (PVar _ (Ident _ "f")) (UnGuardedRhs _ (Lit _ (Int _ 1 "1"))) Nothing

f = f
-- PatBind _ (PVar _ (Ident _ "f")) (UnGuardedRhs _ (Var _ (UnQual _ (Ident _ "f")))) Nothing

f = id 1
-- PatBind _ (PVar _ (Ident _ "f")) (UnGuardedRhs _ (App _ (Var _ (UnQual _ (Ident _ "id"))) (Lit _ (Int _ 1 "1")))) Nothing

f
  | otherwise = 1
-- PatBind _ (PVar _ (Ident _ "f")) (GuardedRhss _ [GuardedRhs _ [Qualifier _ (Var _ (UnQual _ (Ident _ "otherwise")))] (Lit _ (Int _ 1 "1"))]) Nothing
```

### FunBind

```haskell
f x = x
-- FunBind _ [Match _ (Ident _ "f") [PVar _ (Ident _ "x")] (UnGuardedRhs _ (Var _ (UnQual _ (Ident _ "x")))) Nothing]

f x
  | otherwise = 1
-- FunBind _ [Match _ (Ident _ "f") [PVar _ (Ident _ "x")] (GuardedRhss _ [GuardedRhs _ [Qualifier _ (Var _ (UnQual _ (Ident _ "otherwise")))] (Lit _ (Int_ 1 "1"))]) Nothing]

f [] = 1
f (x:xs) = 2
-- FunBind _ [Match _ (Ident _ "f") [PList _ []] (UnGuardedRhs _ (Lit _ (Int _ 1 "1"))) Nothing,Match _ (Ident _ "f") [PParen _ (PInfixApp _ (PVar _ (Ident _ "x")) (Special _ (Cons _)) (PVar _ (Ident _ "xs")))] (UnGuardedRhs _ (Lit _ (Int _ 2 "2"))) Nothing]

g x1 x2 = x1 + x2 + 2
-- [FunBind _ [Match _ (Ident _ "g") [PVar _ (Ident _ "x1"),PVar _ (Ident _ "x2")] (UnGuardedRhs _ (InfixApp _ (InfixApp _ (Var _ (UnQual _ (Ident _ "x1"))) (QVarOp _ (UnQual _ (Symbol _ "+"))) (Var _ (UnQual _ (Ident _ "x2")))) (QVarOp _ (UnQual _ (Symbol _ "+"))) (Lit _ (Int _ 2 "2")))) Nothing]]
```
