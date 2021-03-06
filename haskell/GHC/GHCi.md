# GHCi

`ghc-8.2.2-rc3` の情報

- [ghc/ghc/GHCi/UI.hs](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/ghc/GHCi/UI.hs)

## type オプション

- [typeOfExpr](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/ghc/GHCi/UI.hs#L1849)

表示関数の呼び出し (全体)

1. [printForUser](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/utils/Outputable.hs#L449)
1. [printSDocLn](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/utils/Outputable.hs#L445)
1. [printSDoc](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/utils/Outputable.hs#L434)
1. [printDoc\_](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/utils/Pretty.hs#L983)

表示関数の呼び出し (型に関する部分)

1. [pprTypeForUser](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/main/PprTyThing.hs#L155)
1. [pprSigmaType](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/types/TyCoRep.hs#L2488)
1. [pprIfaceSigmaType](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/iface/IfaceType.hs#L897)
1. [ppr\_iface\_forall\_part](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/iface/IfaceType.hs#L838)

### 型クラス情報の削除

```haskell
ppr_iface_forall_part :: ShowForAllFlag
                      -> [IfaceForAllBndr] -> [IfacePredType] -> SDoc -> SDoc
ppr_iface_forall_part show_forall tvs ctxt sdoc
  = sep [ case show_forall of
            ShowForAllMust -> pprIfaceForAll tvs
            ShowForAllWhen -> pprUserIfaceForAll tvs
        , pprIfaceContextArr ctxt
        , sdoc]
```

ここを Hack したら良さそう。

```haskell
ppr_iface_forall_part :: ShowForAllFlag -> [IfaceForAllBndr] -> [IfacePredType] -> SDoc -> SDoc
ppr_iface_forall_part show_forall tvs ctxt sdoc = sep [sdoc]
```

### コード

- [ghc/compiler/utils/Outputable.hs](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/utils/Outputable.hs)
- [ghc/compiler/utils/Pretty.hs](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/utils/Pretty.hs)
- [ghc/compiler/main/PprTyThing.hs](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/main/PprTyThing.hs)
- [ghc/compiler/types/TyCoRep.hs](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/types/TyCoRep.hs)
- [ghc/compiler/iface/IfaceType.hs](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/iface/IfaceType.hs)

## type オプション (+d)

評価関数の呼び出し

1. [exprType](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/main/InteractiveEval.hs#L825)
1. [hscTcExpr](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/main/HscMain.hs#L1668)
1. [tcRnExpr](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/typecheck/TcRnDriver.hs#L2159)
1. [simplifyInfer](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/typecheck/TcSimplify.hs#L572)
1. [decideQuantification](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/typecheck/TcSimplify.hs#L785)

### Defaulting に関するところ

- [tcGetDefaultTys](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/typecheck/TcEnv.hs#L751)

```haskell
tcGetDefaultTys :: TcM ([Type], -- Default types
                        (Bool,  -- True <=> Use overloaded strings
                         Bool)) -- True <=> Use extended defaulting rules
tcGetDefaultTys
  = do  { dflags <- getDynFlags
        ; let ovl_strings = xopt LangExt.OverloadedStrings dflags
              extended_defaults = xopt LangExt.ExtendedDefaultRules dflags
                                        -- See also Trac #1974
              flags = (ovl_strings, extended_defaults)

        ; mb_defaults <- getDeclaredDefaultTys
        ; case mb_defaults of {
           Just tys -> return (tys, flags) ;
                                -- User-supplied defaults
           Nothing  -> do

        -- No use-supplied default
        -- Use [Integer, Double], plus modifications
        { integer_ty <- tcMetaTy integerTyConName
        ; list_ty <- tcMetaTy listTyConName
        ; checkWiredInTyCon doubleTyCon
        ; let deflt_tys = opt_deflt extended_defaults [unitTy, list_ty]
                          -- Note [Extended defaults]
                          ++ [integer_ty, doubleTy]
                          ++ opt_deflt ovl_strings [stringTy]
        ; return (deflt_tys, flags) } } }
  where
    opt_deflt True  xs = xs
    opt_deflt False _  = []
```

ここを Hack したら良さそう。

```haskell
tcGetDefaultTys :: TcM ([Type], -- Default types
                        (Bool,  -- True <=> Use overloaded strings
                         Bool)) -- True <=> Use extended defaulting rules
tcGetDefaultTys
  = do  { dflags <- getDynFlags
        ; let ovl_strings = xopt LangExt.OverloadedStrings dflags
              extended_defaults = xopt LangExt.ExtendedDefaultRules dflags
                                        -- See also Trac #1974
              flags = (ovl_strings, extended_defaults)

        ; mb_defaults <- getDeclaredDefaultTys
        ; case mb_defaults of {
           Just tys -> return (tys, flags) ;
                                -- User-supplied defaults
           Nothing  -> do

        -- No use-supplied default
        -- Use [Integer, Double], plus modifications
        { integer_ty <- tcMetaTy integerTyConName
        ; int_ty <- tcMetaTy intTyConName
        ; list_ty <- tcMetaTy listTyConName
        ; checkWiredInTyCon doubleTyCon
        ; let deflt_tys = opt_deflt extended_defaults [unitTy, list_ty]
                          -- Note [Extended defaults]
                          ++ [int_ty, integer_ty, doubleTy]
                          ++ opt_deflt ovl_strings [stringTy]
        ; return (deflt_tys, flags) } } }
  where
    opt_deflt True  xs = xs
    opt_deflt False _  = []
```

### コード

- [ghc/compiler/main/InteractiveEval.hs](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/main/InteractiveEval.hs)
- [ghc/compiler/main/HscMain.hs](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/main/HscMain.hs)
- [ghc/compiler/typecheck/TcRnDriver.hs](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/typecheck/TcRnDriver.hs)
- [ghc/compiler/typecheck/TcSimplify.hs](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/typecheck/TcSimplify.hs)
- [compiler/typecheck/TcDefaults.hs](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/typecheck/TcDefaults.hs)
- [ghc/compiler/typecheck/TcEnv.hs](https://github.com/ghc/ghc/blob/ghc-8.2.2-rc3/compiler/typecheck/TcEnv.hs)

