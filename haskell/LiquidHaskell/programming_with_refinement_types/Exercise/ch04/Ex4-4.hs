import Prelude hiding (length)
import Data.Vector

{-@ vectorSum :: {v:Vector Int | 0 <= vlen v} -> Int @-}
vectorSum ::  Vector Int -> Int
vectorSum vec = go 0 0
  where
    {-@ lazy go @-}
    {-@ go :: Int -> i:{n:Nat | n <= vlen vec} -> Int @-}
    go acc i
      | i < sz = go (acc + (vec ! i)) (i + 1)
      | otherwise = acc
    sz = length vec

{-@ vectorSumDec :: {v:Vector Int | 0 < vlen v} -> Int @-}
vectorSumDec :: Vector Int -> Int
vectorSumDec vec = go 0 (sz - 1)
  where
    {-@ go :: Int -> {n:Nat | n < vlen vec} -> Int / [n] @-}
    go acc i
      | i == 0 = acc + (vec ! 0)
      | otherwise = go (acc + (vec ! i)) (i - 1)
    sz = length vec