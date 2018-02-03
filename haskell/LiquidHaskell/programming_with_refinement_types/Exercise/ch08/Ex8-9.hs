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

{-@ reverse :: xs:UList a -> UList a @-}
reverse :: Ord a => [a] -> [a]
reverse = go []
  where
    {-@ go :: acc:UList a -> { xs:UList a | intersection (elts acc) (elts xs) = empty } -> UList a / [len xs] @-}
    go acc [] = acc
    go acc (x:xs) = go (x:acc) xs