import Prelude hiding (max)
{-@
data IncList [llen] a = Emp
                      | (:<) { hd :: a
                             , tl :: IncList { v:a | hd <= v }
                             }
@-}
data IncList a = Emp
               | (:<) { hd :: a
                      , tl :: IncList a
                      }

infixr 9 :<

{-@ measure llen @-}
{-@ llen :: IncList a -> Nat @-}
llen :: IncList a -> Int
llen Emp = 0
llen (_:<xs) = 1 + llen xs

{-@
data BST [bstLen] a = Leaf
           | Node { root  :: a
                  , left  :: BSTL a root
                  , right :: BSTR a root
                  }
@-}
data BST a = Leaf
           | Node { root  :: a
                  , left  :: BST a
                  , right :: BST a
                  }
  deriving (Eq, Show)

{-@ measure bstLen @-}
{-@ bstLen :: BST a -> Nat @-}
bstLen :: BST a -> Int
bstLen Leaf = 0
bstLen (Node _ l r) = 1 + bstLen l `max` bstLen r

{-@ inline max @-}
max :: Int -> Int -> Int
max x y = if x > y then x else y

{-@ type BSTL a X = BST { v:a | v < X } @-}
{-@ type BSTR a X = BST { v:a | X < v } @-}

one :: a -> BST a
one x = Node x Leaf Leaf

add :: (Ord a) => a -> BST a -> BST a
add k' Leaf = one k'
add k' t@(Node k l r)
  | k' < k = Node k (add k' l) r
  | k < k' = Node k l (add k' r)
  | otherwise = t

{-@ append :: z:a -> IncList { v:a | v < z } -> IncList { v:a | v >= z } -> IncList a @-}
append :: a -> IncList a -> IncList a -> IncList a
append z Emp ys = z :< ys
append z (x :< xs) ys = x :< append z xs ys

bstSort :: (Ord a) => [a] -> IncList a
bstSort = toIncList . toBST

toBST :: (Ord a) => [a] -> BST a
toBST = foldr add Leaf

toIncList :: BST a -> IncList a
toIncList Leaf = Emp
toIncList (Node x l r) = append x (toIncList l) (toIncList r)