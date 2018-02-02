import Data.Set (Set, empty, singleton, union, member)

{-@ measure elts @-}
elts :: (Ord a) => [a] -> Set a
elts []     = empty
elts (x:xs) = singleton x `union` elts xs

{-@ type ListSub a X = {v:[a] | Set_sub (elts v) (elts X)} @-}

{-@ measure unique @-}
unique :: (Ord a) => [a] -> Bool
unique [] = True
unique (x:xs) = unique xs && not (member x (elts xs))

{-@ type UList a = { v:[a] | unique v } @-}

{-@ filter' :: (a -> Bool) -> xs:[a] -> { v:ListSub a xs | unique xs => unique v } @-}
filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' f (x:xs)
  | f x = x : xs'
  | otherwise = xs'
  where
    xs' = filter' f xs

{-@ test3 :: UList _ @-}
test3 :: [Int]
test3 = filter' (> 2) [1,2,3,4]

{-@ test4 :: [_] @-}
test4 :: [Int]
test4 = filter' (> 3) [3,1,2,3]