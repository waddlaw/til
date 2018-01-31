import Data.Vector

-- Exercise 4.2
{-@ unsafeLookup :: x:Nat -> {v:Vector a | x < vlen v} -> a @-}
unsafeLookup :: Int -> Vector a -> a
unsafeLookup index vec = vec ! index