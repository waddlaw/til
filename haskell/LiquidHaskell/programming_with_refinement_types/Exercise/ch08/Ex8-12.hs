import Data.Set (Set, empty, singleton, union, member, intersection)
import Prelude hiding (reverse)

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

{-@ reverse :: xs:UList a -> UList a @-}
reverse :: Ord a => [a] -> [a]
reverse = go []
  where
    {-@ go :: acc:UList a -> { xs:UList a | intersection (elts acc) (elts xs) = empty } -> UList a / [len xs] @-}
    go acc [] = acc
    go acc (x:xs) = go (x:acc) xs

{-@ predicate In X Xs = Set_mem X (elts Xs) @-}
{-@ predicate Disj X Y = Disjoint (elts X) (elts Y) @-}
{-@ predicate Disjoint X Y = Inter (Set_empty 0) X Y @-}
{-@ predicate Inter X Y Z  = X = Set_cap Y Z         @-}

{-@ data Zipper a = Zipper {
      focus :: a
    , left  :: { v: UList a | not (In focus v)}
    , right :: { v: UList a | not (In focus v) && Disj v left }
    }
@-}

data Zipper a = Zipper {
    focus :: a
  , left :: [a]
  , right :: [a]
}

{-@ integrate :: Ord a => Zipper a -> UList a @-}
integrate :: Ord a => Zipper a -> [a]
integrate (Zipper x l r) = reverse l `append` (x : r)