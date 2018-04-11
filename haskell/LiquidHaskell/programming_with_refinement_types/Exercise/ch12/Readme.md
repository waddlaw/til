# Case Study: AVL Trees

## Exercise 12.1 (Singleton)

### LiquidHaskell の結果

```shell
Error: Liquid Type Mismatch

 65 | singleton x = Node x empty empty 0
                    ^^^^^^^^^^^^^^^^^^^^

   Inferred type
     VV : {v : Int | v == (0 : int)}

   not a subtype of Required type
     VV : {VV : Int | VV >= 0
                      && VV == 1 + (if Main.realHeight ?b > Main.realHeight ?c then Main.realHeight ?b else Main.realHeight ?c)}

   In Context
     ?c : {?c : (AVL a) | Main.realHeight ?c == 0}

     ?b : {?b : (AVL a) | Main.realHeight ?b == 0}
```

### 解答

```hs
{-@ singleton :: a -> AVLN a 1 @-}
singleton :: a -> AVL a
singleton x = Node x empty empty 1
```

## Exercise 12.2 (Constructor)

### LiquidHaskell の結果

```shell
Error: Liquid Type Mismatch

 69 | mkNode v l r = Node v l r h
                     ^^^^^^^^


   Inferred type
    VV : a

  not a subtype of Required type
    VV : {VV : a | VV < v}

  In Context
    v : a
```

```shell
Error: Liquid Type Mismatch

 69 | mkNode v l r = Node v l r h
                     ^^^^^^^^^^


   Inferred type
    VV : {v : (AVL a) | Main.getHeight v >= 0
                        && v == r}

  not a subtype of Required type
    VV : {VV : (AVL {VV : a | v < VV}) | 0 - 1 <= Main.realHeight l - Main.realHeight VV
                                         && Main.realHeight l - Main.realHeight VV <= 1}

  In Context
    l : {l : (AVL a) | Main.getHeight l >= 0}

    r : {r : (AVL a) | Main.getHeight r >= 0}

    v : a
```

```shell
Error: Liquid Type Mismatch

 69 | mkNode v l r = Node v l r h
                     ^^^^^^^^^^^^


   Inferred type
    VV : {v : Int | v == (1 : int) + (if Main.getHeight l > Main.getHeight r then Main.getHeight l else Main.getHeight r)}

  not a subtype of Required type
    VV : {VV : Int | VV >= 0
                     && VV == 1 + (if Main.realHeight l > Main.realHeight r then Main.realHeight l else Main.realHeight r)}

  In Context
    l : {l : (AVL a) | Main.getHeight l >= 0}

    r : {r : (AVL a) | Main.getHeight r >= 0}
```

### 解答

```hs
{-@ realHeight :: AVL a -> Nat @-}

{-@ mkNode :: n:a -> l:AVLL a n -> {r:AVLR a n | isBal l r 1} -> AVLN a {nodeHeight l r} @-}
mkNode :: a -> AVL a -> AVL a -> AVL a
mkNode v l r = Node v l r h
  where
    h  = 1 + max hl hr
    hl = realHeight l
    hr = realHeight r
```