import Prelude hiding (length)
import Data.Vector

{-@ type Btwn Lo Hi = { v:Int | Lo <= v && v < Hi} @-}

{-@ loop :: lo:Nat -> hi:{ Nat | lo <= hi } -> a -> (Btwn lo hi -> a -> a) -> a @-}
loop :: Int -> Int -> a -> (Int -> a -> a) -> a
loop lo hi base f = go base lo
  where
    {-@ lazy go @-}
    go acc i
      | i < hi = go (f i acc) (i + 1)
      | otherwise = acc

{-@ dotProduct :: x:Vector Int -> y:Vector Int -> Int @-}
dotProduct :: Vector Int -> Vector Int -> Int
dotProduct x y = loop 0 sz 0 body
  where
    body i acc = acc + (x ! i) * (y ! i)
    sz = length x

-- コードを変更
-- {-@ dotProduct :: Vector Int -> Vector Int -> Maybe Int @-}
-- dotProduct :: Vector Int -> Vector Int -> Maybe Int
-- dotProduct x y
--   | length x == length y = Just $ loop 0 sz 0 body
--   | otherwise = Nothing
--   where
--     body i acc = acc + (x ! i) * (y ! i)
--     sz
--       | length x > length y = length y
--       | otherwise = length x

-- 仕様を変更
-- {-@ dotProduct :: x:Vector Int -> {y:Vector Int | vlen x == vlen y} -> Int @-}
-- dotProduct :: Vector Int -> Vector Int -> Int
-- dotProduct x y = loop 0 sz 0 body
--     where
--       sz = length x
--       body i acc = acc + (x ! i) * (y ! i)