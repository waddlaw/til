# ch04 Polymorphism

動かすためには `resolver: nightly-2017-10-06` の指定が必要。

`Data.Vector` を `import` すると自動的に [include/Data/Vector.spec](../src/ch04/include/Data/Vector.spec) が作成され、`liquid -i include/ target.hs` と指定しなくても `liquid target.hs` で実行できる。

## vectorSum

以下のように `Refinement Type` を定義した。

```haskell
{-@ vectorSum :: Vector Int -> Int @-}
vectorSum :: Vector Int -> Int
vectorSum vec = go 0 0
  where
    go acc i
      | i < sz = go (acc + (vec ! i)) (i + 1)
      | otherwise = acc
    sz = length vec
```

このようなエラーになる。

```bash
**** RESULT: UNSAFE ************************************************************
 example.hs:57:22-36: Error: Liquid Type Mismatch

 57 |       | i < sz = go (acc + (vec ! i)) (i + 1)
                           ^^^^^^^^^^^^^^^
   Inferred type
     VV : {v : Int | v == acc + ?a && v == ?b}

   not a subtype of Required type
     VV : {VV : Int | VV < acc && VV >= 0}

   In Context
     ?b : {?b : Int | ?b == acc + ?a}
     ?a : Int
     acc : Int

 example.hs:57:29-35: Error: Liquid Type Mismatch

 57 |       | i < sz = go (acc + (vec ! i)) (i + 1)
                                  ^^^^^^^

   Inferred type
     VV : {v : Int | v <= sz && v >= 0 && v == i}

   not a subtype of Required type
     VV : {VV : Int | VV >= 0 && VV < vlen vec}

   In Context
     sz : {sz : Int | sz >= 0 && sz == len vec}
     vec : {vec : (Vector Int) | 0 <= vlen vec}
     i : {i : Int | i <= sz && i >= 0}
```

`!` で利用される `i` は `i < sz` を満たすはずだが、上手く推論できていない感じがする。