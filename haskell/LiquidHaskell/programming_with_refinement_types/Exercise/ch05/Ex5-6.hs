import Prelude hiding (max)
import Data.Maybe (isJust)

{-@
data BST a = Leaf
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

{-@ data MinPair a = MP { mElt :: a, rest :: BSTR a mElt } @-}
data MinPair a = MP { mElt :: a, rest :: BST a }
  deriving Show

{-@ delMin :: (Ord a) => BST a -> Maybe (MinPair a)  @-}
delMin :: (Ord a) => BST a -> Maybe (MinPair a)
delMin Leaf = Nothing
delMin (Node k Leaf r) = Just $ MP k r
delMin (Node k l r)
  | Just (MP k' l') <- delMin l = Just $ MP k' (Node k l' r)
  | otherwise = Nothing

{-@ del :: (Ord a) => a -> BST a -> Maybe (BST a) @-}
del :: (Ord a) => a -> BST a -> Maybe (BST a)
del _ Leaf = Just $ Leaf
del k' t@(Node k l Leaf)
  | k' == k = Just $ l
  | otherwise = del k' l
del k' t@(Node k l r)
  | isJust (delMin r) && k' == k = (\(MP newRoot restTree) -> Node newRoot l restTree) <$> delMin r
  | isJust (del k' l) && k' < k  = (\l' -> Node k l' r) <$> del k' l
  | isJust (del k' r) && k' > k  = (\r' -> Node k l r') <$> del k' r
  | otherwise = Nothing