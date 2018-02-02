import Data.Set (Set, empty, singleton, union)

{-@ type True  = {v:Bool |     v} @-}

{-@ measure elts @-}
elts :: (Ord a) => [a] -> Set a
elts []     = empty
elts (x:xs) = singleton x `union` elts xs

{-@ type ListS a S = {v:[a] | elts v = S} @-}
{-@ type ListUn a X Y = ListS a {Set_cup (elts X) (elts Y)} @-}

{-@ append' :: xs:_ -> ys:_ -> ListUn a xs ys @-}
append' :: [a] -> [a] -> [a]
append' [] ys     = ys
append' (x:xs) ys = x : append' xs ys

{-@ lazy halve @-}
{-@ halve :: n:Int -> xs:[a] -> {v:([a], [a]) | union (elts (fst v)) (elts (snd v)) = elts xs } @-}
halve :: Int -> [a] -> ([a], [a])
halve 0 xs = ([], xs)
halve n (x:y:zs) = (x:xs, y:ys) where (xs, ys) = halve (n-1) zs
halve _ xs = ([], xs)

{-@ prop_halve_append :: _ -> _ -> True @-}
prop_halve_append :: Ord a => Int -> [a] -> Bool
prop_halve_append n xs = elts xs == elts xs'
  where
    xs'      = append' ys zs
    (ys, zs) = halve n xs