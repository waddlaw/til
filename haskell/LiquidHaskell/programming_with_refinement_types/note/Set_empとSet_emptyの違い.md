# Set_emp と Set_empty の違い

- [spec Data.Set](https://github.com/ucsd-progsys/liquidhaskell/blob/develop/include/Data/Set.spec)を見るとわかる。

```haskell
-- emptiness test
measure Set_emp   :: (Data.Set.Set a) -> GHC.Types.Bool

-- empty set
measure Set_empty :: forall a. GHC.Types.Int -> (Data.Set.Set a)
```

- `Set_emp` は与えられた集合が空かどうか判定する述語
- `Set_empty` は空集合を作る関数
