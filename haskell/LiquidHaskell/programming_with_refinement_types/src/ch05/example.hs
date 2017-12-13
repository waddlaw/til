{-@ LIQUID "--no-termination" @-}
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

{-@ data IncList a = Emp
                   | (:<) { hd :: a, tl :: IncList { v:a | hd <= v }}
@-}
data IncList a = Emp
               | (:<) { hd :: a, tl :: IncList a }

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
merge Emp Emp = Emp
merge Emp ys = ys
merge (x :< xs) (y :< ys)
  | x <= y    = x :< merge xs (y :< ys)
  | otherwise = y :< merge (x :< xs) ys