import Prelude hiding (elem)
import Data.Set (Set, empty, singleton, union, member)

{-@ type True  = {v:Bool |     v} @-}
{-@ type False = {v:Bool | not v} @-}

{-@ measure elts @-}
elts :: (Ord a) => [a] -> Set a
elts []     = empty
elts (x:xs) = singleton x `union` elts xs

{-@ elem :: (Eq a) => x:a -> xs:[a] -> { v:Bool | v = member x (elts xs) } @-}
elem :: Eq a => a -> [a] -> Bool
elem _ [] = False
elem x (y:ys) = x == y || elem x ys

{-@ test1 :: True @-}
test1 :: Bool
test1 = elem 2 [1,2,3]

{-@ test2 :: False @-}
test2 :: Bool
test2 = elem 2 [1,3]