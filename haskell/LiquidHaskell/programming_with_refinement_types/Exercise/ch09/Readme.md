# Case Study: Okasaki's Lazy Queues

## Exercise 9.1 (Destructing Lists)

### Liquidhaskell の結果

### 解答

```haskell
{-@ hd :: { xs:SList a | size xs > 0 } -> a @-}
hd :: SList a -> a
hd (SL _ (x:_)) = x
hd _ = die "empty SList"
```

```haskell
{-@ tl :: { xs:SList a | size xs > 0 } -> SListN a {size xs - 1} @-}
tl (SL n (_:xs)) = SL (n-1) xs
tl _             = die "empty SList"
```

## Exercise 9.2 (Whither pattern matching?)

### LiquidHaskell の結果

### 解答


## Exercise 9.3 (Queue Sizes)

### LiquidHaskell の結果

### 解答

```haskell
{-@ measure sizeQ @-}
{-@ sizeQ :: q:Queue a -> { v:Nat | v = sizeQ q } @-}
sizeQ :: Queue a -> Int
sizeQ (Q f b) = size f + size b
```

```haskell
{-@ type QueueN a N = {v:Queue a | sizeQ v = N} @-}
```

```haskell
{-@ remove :: { v:Queue a | sizeQ v > 0 } -> (a, QueueN a {sizeQ v - 1}) @-}
remove :: Queue a -> (a, Queue a)
remove (Q f b) = (hd f, makeq (tl f) b)
```

## Exercise 9.4 (Insert)

### LiquidHaskell の結果

### 解答

```haskell
{-@ insert :: a -> q:Queue a -> QueueN a {sizeQ q + 1} @-}
insert :: a -> Queue a -> Queue a
insert e (Q f b) = makeq f (e `cons` b)
```

## Exercise 9.5 (Rotate) **

### LiquidHaskell の結果

### 解答

```haskell
{-@ makeq :: f:SList a -> {b:SList a | size b > size f => size b - size f = 1 } -> QueueN a {size f + size b} @-}
makeq :: SList a -> SList a -> Queue a
makeq f b
  | size b <= size f = Q f b
  | otherwise        = Q (rot f b nil) nil
```

```haskell
{-@ rot :: f:SList a -> b:SListN a {size f + 1} -> tmp:SList a -> SListN a {size f + size b + size tmp} / [size f] @-}
rot :: SList a -> SList a -> SList a -> SList a
rot f b a
  | size f == 0 = hd b `cons` a
  | otherwise   = hd f `cons` rot (tl f) (tl b) (hd b `cons` a)
```

## Exercise 9.6 (Transfer)

### LiquidHaskell の結果

### 解答

```haskell
{-@ take :: {n:Int | n >= 0} -> {q:Queue a | sizeQ q >= n} -> (QueueN a n, QueueN a {sizeQ q - n}) @-}
take :: Int -> Queue a -> (Queue a, Queue a)
take 0 q = (emp, q)
take n q = (insert x out, q'')
  where
    (x, q')    = remove q
    (out, q'') = take (n-1) q'
```

### 補足

`take` の結果出てきた `Queue` は逆順となってしまうため、通常の順序にしたい場合は以下のように定義すれば良い。

```haskell
{-@ take' :: n:Nat -> {q: Queue a | sizeQueue q >= n} -> (QueueN a n, QueueN a {sizeQueue q - n}) @-}
take' :: Int -> Queue a -> (Queue a, Queue a)
take' n q = take'' n q emp

{-@ take'' :: n:Nat -> {q: Queue a | sizeQueue q >= n} -> acc:Queue a -> (QueueN a {n + sizeQueue acc}, QueueN a {sizeQueue q - n}) @-}
take'' :: Int -> Queue a -> Queue a -> (Queue a, Queue a)
take'' 0 q accQ = (accQ, q)
take'' n q accQ = take'' (n - 1) q' (insert x accQ)
    where
      (x  , q')  = remove q
```
