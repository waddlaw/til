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

{-@ merge :: xs:[a] -> ys:[a] -> ListUn a xs ys / [len xs, len ys] @-}
merge [] ys = ys
merge xs [] = xs
merge (x:xs) (y:ys)
  | x <= y = x : merge xs (y:ys)
  | otherwise = y : merge (x:xs) ys

{-@ prop_merge_app :: _ -> _ -> True @-}
prop_merge_app xs ys = elts zs == elts zs'
  where
    zs = append' xs ys
    zs' = merge xs ys