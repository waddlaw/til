import Prelude hiding (length, abs)
import Data.Vector

{-@ type Btwn Lo Hi = { v:Int | Lo <= v && v < Hi} @-}

{-@ abs :: Int -> Nat @-}
abs :: Int -> Int
abs n
  | 0 < n = n
  | otherwise = 0 - n

{-@ loop :: lo:Nat -> hi:{ Nat | lo <= hi } -> a -> (Btwn lo hi -> a -> a) -> a @-}
loop :: Int -> Int -> a -> (Int -> a -> a) -> a
loop lo hi base f = go base lo
  where
    {-@ lazy go @-}
    go acc i
      | i < hi = go (f i acc) (i + 1)
      | otherwise = acc

{-@ absoluteSum' :: Vector Int -> Nat @-}
absoluteSum' :: Vector Int -> Int
absoluteSum' vec = loop 0 n 0 body
  where
    {-@ body :: {x:Nat | x < vlen vec} -> Nat -> Nat @-}
    body i acc = acc + abs (vec ! i)
    n = length vec