## 実験により得られたこと

### トップレベルのリファインメント型は複数あっても問題無い

```
{-@ zero :: Zero @-}
{-@ zero :: Nat @-}
{-@ zero :: Even @-}
{-@ zero :: Lt100 @-}
```

### calc の検証
`Termination Error` が出るため `{-@ LIQUID "--notermination" @-}` を追加する必要がある。
