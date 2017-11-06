# 2章 Logic & SMT

## リファインメント型とは何か？

> Refinement Types = Type + Logical Predicates

## Syntax

チュートリアルの内容と githubu の Readme に載っている [Formal Grammar of Refinement Predicates](https://github.com/ucsd-progsys/liquidhaskell#formal-grammar-of-refinement-predicates) で少し構文が違う

### 定数 (constant)

```
c := 0, 1, 2, ...
```

### 変数 (variable)

```
v := x, y, z
```

### 式 (expression)

```
e := v
   | c
   | e + e
   | e - e
   | c * e
   | v e1 e2 ... en
```

github の内容 (たぶんこっちが正しいんだろうなぁと思う)

```
e := v                      -- variable
   | c                      -- constant
   | (e + e)                -- addition
   | (e - e)                -- subtraction
   | (c * e)                -- multiplication by constant
   | (v e1 e2 ... en)       -- uninterpreted function application
   | (if p then e else e)   -- if-then-else
```

### 関係 (relation)

```
r := ==
   | /=
   | >=
   | <=
   | >
   | <
```

### 述語 (predicate)

```
p := true
   | false
   | e r e
   | v e1 e2 ... en
   | p && p
   | p || p
   | p ==> p
   | p ===> p
   | p <=> p
   | not p
```

github の内容 (微妙に演算子違うのとかやばい)

```
p := (e r e)          -- binary relation
   | (v e1 e2 ... en) -- predicate (or alias) application
   | (p && p)         -- and
   | (p || p)         -- or
   | (p => p)         -- implies
   | (not p)          -- negation
   | true
   | false
```

僕の考える正しい `predicate`

```
p := (e r e)          -- binary relation
   | (v e1 e2 ... en) -- predicate (or alias) application
   | (p && p)         -- and
   | (p || p)         -- or
   | (p => p)         -- implies
   | (p ==> p)
   | (p <=> p)
   | (not p)          -- negation
   | true
   | True
   | false
   | False
```

## Semantics

### 環境
変数 → 型

```
x :: Int
y :: Int
z :: INt
```

### 割り当て
変数 → 値

```
x := 1
y := 2
z := 3
```

### 充足可能

与えられた論理式を満たす割り当てが少なくとも1つは存在する。

```
x + y == z
```

### 妥当

与えられた論理式は割り当てによらず、常に真である。

```
x < 10 || x == 10 || x > 10
```



## 実験によりわかったこと

### `{ ... }` の内部は `Haskell` とは関係無さそうな感じがする。

以下のコードは問題なく `SAFE` となる。`liquidhaskell` が内部で `Prelude` をインポートして使ってる可能性はある。

```
import Prelude hiding (not)

{-@ type FALSE = { v:Bool | not v } @-}

{-@ f :: FALSE @-}
f = False
```

ちなみに `not` を `nott` にするとこんな感じのエラーが出る。

```
 /home/liquid/experiment.hs:11:10: Error: Illegal type specification for `Main.f`

 11 | {-@ f :: FALSE @-}
               ^

     Main.f :: {v : Bool | nott v}
     Sort Error in Refinement: {v : bool | nott v}
     Unbound Symbol nott
 Perhaps you meant: fst
```

### true と false のスペルについて

`true`, `True` どちらでも良い。同様に `false`, `False` もどちらでも許容される。(ただし、`not`, `Not` などはだめ)

### 基本的な動作確認

```
{-@ type TRUE  = { v:Bool | v } @-}
{-@ type FALSE = { v:Bool | not v } @-}
{-@ type BOOL1 = { true } @-}
{-@ type BOOL2 = { True } @-}
{-@ type BOOL3 = { false } @-}
{-@ type BOOL4 = { False} @-}

t = True
f = False
```

関数名 | TRUE | FALSE | BOOL1 | BOOL2 | BOOL3 | BOOL4
-------|-----|-------|--------|------|--------|-----
t | SAFE | UNSAFE | SAFE | SAFE | UNSAFE | UNSAFE
f | UNSAFE | SAFE | SAFE | SAFE | UNSAFE | UNSAFE

ということで、戻り値が `v` に束縛されると考えて良さそう。


### -> の結合性

通常通り、右結合。

```
{-@ P4 = { false -> true -> false } @-}
{-@ P5 = { (false -> true) -> false } @-}

t = True
f = False
```

関数名 | P4 | P5
-------|-----|-------
t | SAFE | UNSAFE
f | SAFE | UNSAFE


### 算術の例
ax1 ~ ax6 まで、型を明示しないと `Num` に推論されて上手く検証できない。


## よくわからなかったこと

`f` が定義できないため、 `congruence` も検証できなかった。以下のように定義したけどだめ。

```
{-@ measure f @-}
f :: Int -> Int
f = undefined
```
