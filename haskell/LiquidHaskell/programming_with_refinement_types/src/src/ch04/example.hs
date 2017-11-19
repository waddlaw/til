import Data.Vector (Vector, (!), fromList)
import qualified Data.Vector as V
import Prelude hiding (head)
--import Language.Haskell.Liquid.Prelude

{-@ type VectorN a N = { v:Vector a | vlen v == N } @-}

{-@ twoLangs :: VectorN String 2 @-}
twoLangs = fromList ["haskell", "javascript"]

{- UNSAFE
eeks = [ok, yup, nono]
  where
    ok = twoLangs ! 0
    yup = twoLangs ! 1
    nono = twoLangs ! 3
-}

{-@ type NEVector a = { v:Vector a | 0 < vlen v} @-}

{-@ head :: NEVector a -> a @-}
head :: Vector a -> a
head vec = vec ! 0

-- | Exercise 4.1
head' :: Vector a -> Maybe a
head' vec
  | null vec = Nothing
  | otherwise = Just $ V.head vec

{-@ type Btwn Lo Hi = { v:Int | Lo <= v && v < Hi} @-}

-- | Exercise 4.2
-- (!) :: Vector a -> Int -> a
-- assume ! :: x:Vector a -> vec:{v:Nat | v < vlen x } -> a

{-@ unsafeLookup :: x:Nat -> {v:Vector a | x == vlen v && vlen v < x} -> a @-}
unsafeLookup :: Int -> Vector a -> a
unsafeLookup index vec = vec ! index

-- | Exercise 4.3
{-@ safeLookup :: Vector a -> Int -> Maybe a @-}
safeLookup x i
  | ok = Just (x ! i)
  | otherwise = Nothing
  where
    ok = 0 <= i && i < V.length x

-- |
-- >>> vectorSum (fromList [1 ,-2, 3])
-- 2
{-@ vectorSum :: Vector Int -> Int @-}
vectorSum :: Vector Int -> Int
vectorSum vec = go 0 0
  where
    go acc i
      | i < sz = go (acc + (vec ! i)) (i + 1)
      | otherwise = acc
    sz = length vec

-- go acc i
--   | i < sz = go (acc + (vec ! i)) (i + 1)
--   | otherwise = acc
--   where sz = length vec

-- | Exercise 4.4
-- Error になる (index が range を超えるため)
-- vectorSum' :: Vector Int -> Int
-- vectorSum' vec = go 0 0
--   where
--     go acc i
--       | i <= sz = go (acc + (vec ! i)) (i + 1)
--       | otherwise = acc
--     sz = length vec

-- | Exercise 4.5
-- >>> absoluteSum (fromList [1, -2, 3])
-- 6
-- absoluteSum :: Vector Int -> Int
-- absoluteSum vec = go 0 0
--   where
--     go acc i
--       | i < sz = go (acc + abs (vec ! i)) (i + 1)
--       | otherwise = acc
--     sz = length vec