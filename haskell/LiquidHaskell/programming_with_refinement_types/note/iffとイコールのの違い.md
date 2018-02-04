# <=> と == の違い

```haskell
{-@ isPositive :: x:Int -> { v:Bool | x > 0 <=> v } @-} -- SAFE
{-@ isPositive :: x:Int -> { v:Bool | x > 0 ==  v } @-} -- 構文エラー
{-@ isPositive :: x:Int -> { v:Bool | x > 0 =   v } @-} -- 構文エラー
isPositive :: Int -> Bool
isPositive x = x > 0
```

```haskell
{-@ elem :: (Eq a) => x:a -> xs:[a] -> { v:Bool | v <=> member x (elts xs) } @-} -- SAFE
{-@ elem :: (Eq a) => x:a -> xs:[a] -> { v:Bool | v ==  member x (elts xs) } @-} -- SAFE
{-@ elem :: (Eq a) => x:a -> xs:[a] -> { v:Bool | v =   member x (elts xs) } @-} -- SAFE
elem :: Eq a => a -> [a] -> Bool
elem _ [] = False
elem x (y:ys) = x == y || elem x ys
```

なぜ `elem` では `<=>`. `==`, `=` の全てで `SAFE` になるのに、`isPositive` ではそうならないのか説明する。また、`=` と `==` は同一の演算子である。

## 構文

### Constant

```
c := 0, 1, 2, ...
```

### Variables

```
v := x, y, z, ...
```

### Expression

```
e := v                      -- variable
   | c                      -- constant
   | (e + e)                -- addition
   | (e - e)                -- subtraction
   | (c * e)                -- multiplication by constant
   | (v e1 e2 ... en)       -- uninterpreted function application
   | (if p then e else e)   -- if-then-else
```

### Relation

```
r := == | =           -- equality
   | /=               -- disequality
   | >=               -- greater than or equal
   | <=               -- less than or equal
   | >                -- greater than
   | <                -- less than
```

### Predicate

```
p := (e r e)                -- binary relation
   | (v e1 e2 ... en)       -- predicate (or alias) application
   | (p && p)               -- and
   | (p || p)               -- or
   | (p => p) | (p ==> p)   -- implies
   | (p <=> p)              -- iff
   | (not p)                -- negation
   | true  | True
   | false | False
```

## 解説

- `<=>` は両辺に `predicate` を取るため、 `p1 <=> p2` の形式となる
- `==` は両辺に `expression` を取るため、 `e1 == e2` の形式となる

また、変数は `Expression` だが、`Bool`型の変数のみ `Predicate` として扱われるような特別規則があると思われる。

### (<=>) の場合

#### isPositive

`SAFE` となる。

```haskell
{-@ isPositive :: x:Int -> { v:Bool | x > 0 <=> v } @-}
```

```
x > 0  <=>   v
= = =       ===
e r e        e :: Bool
=====       ===
  p          p
```

#### elem

`SAFE` となる。

```haskell
{-@ elem :: (Eq a) => x:a -> xs:[a] -> { v:Bool | v <=> member x (elts xs) } @-}
```

`member` は `measure` によって `predicate application` として使えるようになっている。

```
v     <=>    member x (elts xs)
=           ====================
e :: Bool      v e1 e2
=              =======
p                 p
```

### (==) の場合

#### isPositive

`UNSAFE` となる。

```haskell
{-@ isPositive :: x:Int -> { v:Bool | x > 0 ==   v } @-}
```

```
x > 0  ==  v
= = =     ===
e r e      e
=====
  p
```

この時、`==` は `Relation` なので `e r e` の形式でなければならない。よって、構文エラーとなる。

#### elem

`SAFE` となる。

```haskell
{-@ elem :: (Eq a) => x:a -> xs:[a] -> { v:Bool | v == member x (elts xs) } @-}
```

`member` は `uninterpreted function application` として解釈される。

```
v  ==  member x (elts xs)
=     ====================
e          v e1 e2
           =======
              e
```

## まとめ

- `=` と `==` は同一
- `==` は `Expression` の同値
- `<=>` は `Predicate` の同値
