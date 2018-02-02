import Data.Set (Set, empty, singleton, union)

{-@ measure elts @-}
elts :: (Ord a) => [a] -> Set a
elts []     = empty
elts (x:xs) = singleton x `union` elts xs

{-@ type ListS a S = {v:[a] | elts v = S} @-}
{-@ type ListEq a X = ListS a {elts X} @-}
{-@ type ListUn a X Y = ListS a {Set_cup (elts X) (elts Y)} @-}

{-@ lazy halve @-}
{-@ halve :: n:Int -> xs:[a] -> {v:([a], [a]) | union (elts (fst v)) (elts (snd v)) = elts xs } @-}
halve :: Int -> [a] -> ([a], [a])
halve 0 xs = ([], xs)
halve n (x:y:zs) = (x:xs, y:ys) where (xs, ys) = halve (n-1) zs
halve _ xs = ([], xs)

{-@ merge :: xs:[a] -> ys:[a] -> ListUn a xs ys / [len xs, len ys] @-}
merge [] ys = ys
merge xs [] = xs
merge (x:xs) (y:ys)
  | x <= y = x : merge xs (y:ys)
  | otherwise = y : merge (x:xs) ys

{-@ lazy mergeSort @-}
{-@ mergeSort :: (Ord a) => xs:[a] -> ListEq a xs @-}
mergeSort :: Ord a => [a] -> [a]
mergeSort []  = []
mergeSort [x] = [x]
mergeSort xs  = merge (mergeSort ys) (mergeSort zs)
  where
    (ys, zs) = halve mid xs
    mid = length xs `div` 2