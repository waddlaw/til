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

## Exercise 10.2 (Closures)

### LiquidHaskell の結果

### 解答

## Exercise 10.3 (Empty maps)

### LiquidHaskell の結果

### 解答

```haskell
{-@ emp :: { m:Map k v | Set_emp (keys m) } @-}
emp :: Map k v
emp = Tip
```

## Exercise 10.4 (Insert)

### LiquidHaskell の結果

### 解答

```haskell
{-@ predicate AddKey K M N = keys N = Set_cup (Set_sng K) (keys M) @-}

{-@ lazy set @-}
{-@ set :: Ord k => k:k -> v:v -> m:Map k v -> { n:Map k v | AddKey k m n } @-}
set :: Ord k => k -> v -> Map k v -> Map k v
set k' v' (Node k v l r)
  | k' == k   = Node k v' l r
  | k' < k    = Node k v (set k' v' l) r
  | otherwise = Node k v l (set k' v' r)
set k' v' Tip = Node k' v' emp emp
```

## Exercise 10.5 (Membership Test)

### LiquidHaskell の結果

### 解答

```haskell
{-@ lazy mem @-}
{-@ mem :: (Ord k) => k:k -> m:Map k v -> { v:_ | v <=> HasKey k m } @-}
mem :: Ord k => k -> Map k v -> Bool
mem k' (Node k _ l r)
  | k' == k   = True
  | k' < k    = assert (lemma_notMem k' r) $ mem k' l
  | otherwise = assert (lemma_notMem k' l) $ mem k' r
mem _ Tip = False
```


## Exercise 10.6 (Fresh)

### LiquidHaskell の結果

### 解答



