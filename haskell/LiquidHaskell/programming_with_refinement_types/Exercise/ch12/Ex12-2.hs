import Prelude hiding (max)

{-@ mkNode :: n:a -> l:AVLL a n -> {r:AVLR a n | isBal l r 1} -> AVLN a {nodeHeight l r} @-}
mkNode :: a -> AVL a -> AVL a -> AVL a
mkNode v l r = Node v l r h
  where
    h  = 1 + max hl hr
    hl = realHeight l
    hr = realHeight r

{-@ measure realHeight @-}
{-@ realHeight :: AVL a -> Nat @-}
realHeight :: AVL a -> Int
realHeight Leaf           = 0
realHeight (Node _ l r _) = nodeHeight l r

data AVL a = Leaf
           | Node { key :: a
                  , l   :: AVL a
                  , r   :: AVL a
                  , ah  :: Int
                  }
           deriving (Show)

{-@ data AVL a = Leaf
               | Node { key :: a
                      , l   :: AVLL a key
                      , r   :: { v:AVLR a key | isBal  l v 1 }
                      , ah  :: { v:Nat        | isReal v l r }
                      }
@-}

{-@ type AVLL a X = AVL { v:a | v < X } @-}
{-@ type AVLR a X = AVL { v:a | X < v } @-}
{-@ type AVLN a N = { v:AVL a | realHeight v = N} @-}

{-@ lazy nodeHeight @-}
{-@ inline nodeHeight @-}
{-@ nodeHeight :: AVL a -> AVL a -> Nat @-}
nodeHeight :: AVL a -> AVL a -> Int
nodeHeight l r = 1 + max hl hr
  where
    hl = realHeight l
    hr = realHeight r

{-@ inline max @-}
{-@ max :: Int -> Int -> Int @-}
max :: Int -> Int -> Int
max x y = if x > y then x else y

{-@ inline isBal @-}
{-@ isBal :: AVL a -> AVL a -> Int -> Bool @-}
isBal :: AVL a -> AVL a -> Int -> Bool
isBal l r n = 0 - n <= d && d <= n
  where
    d = realHeight l - realHeight r

{-@ inline isReal @-}
{-@ isReal :: Int -> AVL a -> AVL a -> Bool @-}
isReal :: Int -> AVL a -> AVL a -> Bool
isReal v l r = v == nodeHeight l r