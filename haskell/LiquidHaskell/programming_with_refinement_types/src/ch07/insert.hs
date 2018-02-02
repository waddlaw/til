import Data.Set hiding (insert)

{-@ measure elts @-}
elts :: (Ord a) => [a] -> Set a
elts []     = empty
elts (x:xs) = singleton x `union` elts xs

{-@ type ListS a S = {v:[a] | elts v = S} @-}
{-@ type ListUn1 a X Y = ListS a {Set_cup (Set_sng X) (elts Y)} @-}

{-@ insert :: x:a -> xs:[a] -> ListUn1 a x xs @-}
insert :: (Ord a) => a -> [a] -> [a]
insert x [] = [x]
-- insert x [y]
--   | x <= y = [x, y]
--   | otherwise = [y, x]
insert x (y:ys)
  | x <= y = x : y : ys
  | otherwise = y : insert x ys