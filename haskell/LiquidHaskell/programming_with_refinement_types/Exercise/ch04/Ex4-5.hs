import Prelude hiding (length, abs)
import Data.Vector

{-@ abs :: Int -> Nat @-}
abs :: Int -> Int
abs n
  | 0 < n = n
  | otherwise = 0 - n

-- >>> absoluteSum (fromList [1, -2, 3])
-- 6
{-@ absoluteSum :: Vector Int -> Nat @-}
absoluteSum :: Vector Int -> Int
absoluteSum vec = go 0 0
  where
    {-@ lazy go @-}
    {-@ go :: Nat -> {n:Nat | n <= vlen vec} -> Nat @-}
    go acc i
      | i < sz = go (acc + abs (vec ! i)) (i + 1)
      | otherwise = acc
    sz = length vec