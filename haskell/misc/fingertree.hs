module Fingertree () where

import Prelude hiding (head, (!!))

data Tree v a = Leaf   v a
              | Branch v (Tree v a) (Tree v a)

-- list
toList :: Tree v a -> [a]
toList (Leaf _ a)     = [a]
toList (Branch _ x y) = toList x ++ toList y

tag :: Tree v a -> v
tag (Leaf v _)     = v
tag (Branch v _ _) = v

head :: Tree v a -> a
head (Leaf _ a)     = a
head (Branch _ x _) = head x

type Size = Int

leaf :: a -> Tree Size a
leaf a = Leaf 1 a

branch :: Tree Size a -> Tree Size a -> Tree Size a
branch x y = Branch (tag x + tag y) x y

(!!) :: Tree Size a -> Int -> a
(Leaf _ a)      !! 0 = a
(Branch _ x y)  !! n
     | n < tag x     = x !! n
     | otherwise     = y !! (n - tag x)

sample :: Tree Size String
sample = branch (branch (leaf "a") (leaf "a")) (branch (leaf "a") (branch (leaf "a") (leaf "a")))

-- priority queue
type Priority = Int

priority :: Tree Priority a -> Priority
priority (Leaf v _) = v

tag' (Leaf _ a)     = priority a
tag' (Branch _ x y) = tag' x `min` tag' y

leaf' :: a -> Tree Priority a
leaf' a = Leaf
