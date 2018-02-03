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

{-@ append :: xs:UList a -> ys:{v:UList a | intersection (elts xs) (elts v) = empty} -> {v:UList a | union (elts xs) (elts ys) = elts v } @-}
append [] ys = ys
append (x:xs) ys = x : append xs ys