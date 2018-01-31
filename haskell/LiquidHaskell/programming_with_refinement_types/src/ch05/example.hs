{-@ LIQUID "--no-termination" @-}
{-@ LIQUID "--no-totality" @-}
import Data.List (foldl', find)
import Data.Vector (Vector, (!))
import Data.Maybe (fromJust, catMaybes, isJust)

{-@ type Nat = { v:Int | 0 <= v } @-}
{-@ type Btwn Lo Hi = { v:Int | Lo <= v && v < Hi} @-}
{-@ data Sparse a = SP { spDim :: Nat
                       , spElems :: [(Btwn 0 spDim, a)]} @-}
data Sparse a = SP { spDim :: Int
                   , spElems :: [(Int, a)]
                   } deriving Show

okSP :: Sparse String
okSP = SP 5 [ (0, "cat")
            , (3, "dog") ]

{- UNSAFE
badSP :: Sparse String
badSP = SP 5 [ (0, "cat")
             , (6, "dog") ]
-}

{-@ type SparseN a N = { v:Sparse a | spDim v == N } @-}

{-@ dotProd :: x:Vector Int -> SparseN Int (vlen x) -> Int @-}
dotProd :: Vector Int -> Sparse Int -> Int
dotProd x (SP _ y) = go 0 y
  where
    go acc []            = acc
    go acc ((i, v) : y') = go (acc + (x ! i) * v) y'

{-@ dotProd' :: x:Vector Int -> SparseN Int (vlen x) -> Int @-}
dotProd' :: Vector Int -> Sparse Int -> Int
dotProd' x (SP _ y) = foldl' body 0 y
  where
    body acc (i, v) = acc + (x ! i) * v

-- | Exercise 4.9
{-@ fromList :: d:Nat -> [(Int, a)] -> Maybe (SparseN a d) @-}
fromList :: Int -> [(Int, a)] -> Maybe (Sparse a)
fromList dim elts
  | Just ys <- check elts = Just $ SP dim ys
  | otherwise = Nothing
  where
    check = sequence . map (\(x, y) -> if 0 <= x && x < dim then Just (x,y) else Nothing)

{-@ test1 :: SparseN String 3 @-}
test1 :: Sparse String
test1 = fromJust $ fromList 3 [(1, "cat"), (2, "mouse")]

-- | Exercise 4.10
-- 仮定その1: 昇順
-- 仮定その2: 重複しない
{-@ plus :: Num a => v:Sparse a -> SparseN a (spDim v) -> SparseN a (spDim v) @-}
plus :: (Num a) => Sparse a -> Sparse a -> Sparse a
plus (SP d xs) (SP _ ys) = SP d $ plus' xs ys
  where
    plus' xs [] = xs
    plus' [] ys = ys
    plus' xs@((i1, v1):xs') ys@((i2, v2):ys')
      | i1 == i2 = (i1, v1 + v2) : plus' xs' ys'
      | i1 < i2 = (i1, v1) : plus' xs' ys
      | otherwise = (i2, v2) : plus' xs ys'

{-@ test2 :: SparseN Int 3 @-}
test2 :: Sparse Int
test2 = plus vec1 vec2
  where
    vec1 = SP 3 [(0, 12), (2, 9)]
    vec2 = SP 3 [(0, 8), (1, 100)]

{-@ data IncList [llen] a = Emp | (:<) { hd :: a, tl :: IncList { v:a | hd <= v }} @-}
data IncList a = Emp | (:<) { hd :: a, tl :: IncList a }

{-@ measure llen @-}
{-@ llen :: IncList a -> Nat @-}
llen :: IncList a -> Int
llen Emp = 0
llen (_:<xs) = 1 + llen xs

infixr 9 :<

okList :: IncList Int
okList = 1 :< 2 :< 3 :< Emp

{- UNSAFE
badList :: IncList Int
badList = 2 :< 1 :< 3 :< Emp
--}

insertSort :: (Ord a) => [a] -> IncList a
insertSort [] = Emp
insertSort (x:xs) = insert x (insertSort xs)

insert :: (Ord a) => a -> IncList a -> IncList a
insert y Emp = y :< Emp
insert y (x :< xs)
  | y <= x = y :< x :< xs
  | otherwise = x :< insert y xs

-- | Exercise 4.11
insertSort' :: (Ord a) => [a] -> IncList a
insertSort' = foldr insert Emp

split :: [a] -> ([a], [a])
split (x:y:zs) = (x:xs, y:ys)
  where
    (xs, ys) = split zs
split xs = (xs, [])

merge :: (Ord a) => IncList a -> IncList a -> IncList a
merge xs Emp = xs
merge Emp ys = ys
merge (x :< xs) (y :< ys)
  | x <= y    = x :< merge xs (y :< ys)
  | otherwise = y :< merge (x :< xs) ys

mergeSort :: (Ord a) => [a] -> IncList a
mergeSort [] = Emp
mergeSort [x] = x :< Emp
mergeSort xs = merge (mergeSort ys) (mergeSort zs)
  where
    (ys, zs) = split xs

-- | Ex.4.12
-- append の制約で z がxsの全ての要素より大きいことが制約として現れていない
quickSort :: (Ord a) => [a] -> IncList a
quickSort (x:xs) = append x lessers greaters
  where
    lessers  = quickSort [y | y <- xs, y < x]
    greaters = quickSort [z | z <- xs, z >= x]

{-@ append :: z:a -> IncList { v:a | v < z } -> IncList { v:a | v >= z } -> IncList a @-}
append :: a -> IncList a -> IncList a -> IncList a
append z Emp ys = z :< ys
append z (x :< xs) ys = x :< append z xs ys

data BST a = Leaf
           | Node { root  :: a
                  , left  :: BST a
                  , right :: BST a
                  }
  deriving (Eq, Show)

okBST :: BST Int
okBST = Node 6
          (Node 2
            (Node 1 Leaf Leaf)
            (Node 4 Leaf Leaf))
          (Node 9
            (Node 7 Leaf Leaf)
            Leaf)

{-@
data BST a = Leaf
           | Node { root  :: a
                  , left  :: BSTL a root
                  , right :: BSTR a root
                  }
@-}

{-@ type BSTL a X = BST { v:a | v < X } @-}
{-@ type BSTR a X = BST { v:a | X < v } @-}

{- UNSAFE
badBST :: BST Int
badBST = Node 66
          (Node 4
            (Node 1 Leaf Leaf)
            (Node 69 Leaf Leaf))
          (Node 99
            (Node 77 Leaf Leaf)
            Leaf)
-}

{- UNSAFE
duplicateBST :: BST Int
duplicateBST = Node 1 (Node 1 Leaf Leaf) (Node 1 Leaf Leaf)
-}

mem :: (Ord a) => a -> BST a -> Bool
mem _ Leaf = False
mem k (Node k' l r)
  | k == k' = True
  | k < k' = mem k l
  | otherwise = mem k r

one :: a -> BST a
one x = Node x Leaf Leaf

add :: (Ord a) => a -> BST a -> BST a
add k' Leaf = one k'
add k' t@(Node k l r)
  | k' < k = Node k (add k' l) r
  | k < k' = Node k l (add k' r)
  | otherwise = t

{-@ data MinPair a = MP { mElt :: a, rest :: BSTR a mElt } @-}
data MinPair a = MP { mElt :: a, rest :: BST a }
  deriving Show

{-@ delMin :: (Ord a) => { x:BST a | nonLeaf x } -> MinPair a  @-}
delMin :: (Ord a) => BST a -> MinPair a
delMin (Node k Leaf r) = MP k r
delMin (Node k l r) = MP k' (Node k l' r)
  where
    MP k' l' = delMin l
delMin Leaf = die "Don't say I didn't warn ya!"

{-@ die :: { v:String | false } -> a @-}
die msg = error msg

-- | Exercise 4.14
del :: (Ord a) => a -> BST a -> BST a
del k' t@(Node k l Leaf)
  | k' == k = l
  | otherwise = del k' l
del k' t@(Node k l r)
  | k' == k   = Node newRoot l restTree
  | k' < k    = Node k (del k' l) r
  | otherwise = Node k l (del k' r)
  where
    MP newRoot restTree = delMin r
del _ Leaf = Leaf

-- | Exercise 4.15
{-@ measure nonLeaf @-}
nonLeaf :: BST a -> Bool
nonLeaf Leaf = False
nonLeaf (Node _ _ _) = True

-- | Exercise 4.16
bstSort :: (Ord a) => [a] -> IncList a
bstSort = toIncList . toBST

toBST :: (Ord a) => [a] -> BST a
toBST = foldr add Leaf

toIncList :: BST a -> IncList a
toIncList Leaf = Emp
toIncList (Node x l r) = append x (toIncList l) (toIncList r)