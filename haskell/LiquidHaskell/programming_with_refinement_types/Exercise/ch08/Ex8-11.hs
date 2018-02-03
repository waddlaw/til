import Data.Set (Set, empty, singleton, union, member, intersection)

{-@ measure elts @-}
elts :: (Ord a) => [a] -> Set a
elts []     = empty
elts (x:xs) = singleton x `union` elts xs

{-@ measure unique @-}
unique :: (Ord a) => [a] -> Bool
unique [] = True
unique (x:xs) = unique xs && not (member x (elts xs))

{-@ type UList a = { v:[a] | unique v } @-}

{-@ type Btwn I J = { v:_ | I <= v && v < J } @-}

{-@ lazy range @-}
{-@ range :: i:Int -> j:Int -> UList (Btwn i j) @-}
range :: Int -> Int -> [Int]
range i j
  | i < j && unique xs = xs
  | otherwise = []
  where
    xs = i : range (i + 1) j