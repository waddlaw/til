{-@ LIQUID "--no-termination" @-}

import Data.Vector (Vector, (!), fromList)
import qualified Data.Vector as V
import Prelude hiding (abs, head, length)
import Data.Function (on)
import Language.Haskell.Liquid.Prelude
import Data.List (foldl')

-- | Ch03 で定義した abs 関数
{-@ abs :: Int -> Nat @-}
abs :: Int -> Int
abs n
  | 0 < n = n
  | otherwise = 0 - n

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
{-@ vectorSum :: {v:Vector Int | 0 <= vlen v} -> Int @-}
vectorSum :: Vector Int -> Int
vectorSum vec = go 0 0
  where
    {-@ go :: Int -> {n:Nat | n <= vlen vec} -> Int @-}
    go acc i
      | i < sz = go (acc + (vec ! i)) (i + 1)
      | otherwise = acc
    sz = V.length vec

{-@ vectorSumDec :: {v:Vector Int | 0 < vlen v} -> Int @-}
vectorSumDec :: Vector Int -> Int
vectorSumDec vec = go 0 (sz - 1)
  where
    {-@ go :: Int -> {n:Nat | n < vlen vec} -> Int @-}
    go acc i
      | i == 0 = acc + (vec ! 0)
      | otherwise = go (acc + (vec ! i)) (i - 1)
    sz = V.length vec

-- | Exercise 4.4
-- Error になる (index が range を超えるため)
{- UNSAFE
{-@ vectorSum' :: {v:Vector Int | 0 <= vlen v} -> Int @-}
vectorSum' :: Vector Int -> Int
vectorSum' vec = go 0 0
  where
    go acc i
      | i <= sz = go (acc + (vec ! i)) (i + 1)
      | otherwise = acc
    sz = V.length vec
-}

-- | Exercise 4.5
-- >>> absoluteSum (fromList [1, -2, 3])
-- 6
{-@ abs :: Int -> Nat @-}
{-@ absoluteSum :: Vector Int -> Nat @-}
absoluteSum :: Vector Int -> Int
absoluteSum vec = go 0 0
  where
    {-@ go :: Nat -> {n:Nat | n <= vlen vec} -> Nat @-}
    go acc i
      | i < sz = go (acc + abs (vec ! i)) (i + 1)
      | otherwise = acc
    sz = V.length vec

-- | Exercise 4.6
-- otherwise があるため

{-@ loop :: lo:Nat -> hi:{ Nat | lo <= hi } -> a -> (Btwn lo hi -> a -> a) -> a @-}
loop :: Int -> Int -> a -> (Int -> a -> a) -> a
loop lo hi base f = go base lo
  where
    go acc i
      | i < hi = go (f i acc) (i + 1)
      | otherwise = acc

{-@ vectorSum'' :: {v:Vector Int | 0 <= vlen v} -> Int @-}
vectorSum'' :: Vector Int -> Int
vectorSum'' vec = loop 0 n 0 body
  where
    body i acc = acc + (vec ! i)
    n = V.length vec

-- | Exercise 4.7
-- >>> absoluteSum' (fromList [1, -2, 3])
-- 6
{-@ absoluteSum' :: Vector Int -> Nat @-}
absoluteSum' :: Vector Int -> Int
absoluteSum' vec = loop 0 n 0 body
  where
    {-@ body :: {x:Nat | x < vlen vec} -> Nat -> Nat @-}
    body i acc = acc + abs (vec ! i)
    n = V.length vec

-- | Exercise 4.8
-- >>> dotProduct (fromList [1, 2, 3]) (fromList [4, 5, 6])
-- 32
-- Ans: V.length x > V.length y の可能性がある
{-@ dotProduct :: x:Vector Int -> {y:Vector Int | vlen x <= vlen y} -> Int @-}
dotProduct :: Vector Int -> Vector Int -> Int
dotProduct x y = loop 0 sz 0 body
  where
    body i acc = acc + (x ! i) * (y ! i)
    sz = V.length x

{-@ dotProduct :: Vector Int -> Vector Int -> Int @-}
dotProduct' :: Vector Int -> Vector Int -> Int
dotProduct' x y = loop 0 sz 0 body
  where
    body i acc = acc + (x ! i) * (y ! i)
    -- sz = (min `on` V.length) x y
    sz = if V.length x > V.length y then V.length y else V.length x

{-@ type SparseN a N = [(Btwn 0 N, a)] @-}

{-@ sparseProduct :: x:Vector _ -> SparseN _ (vlen x) -> _ @-}
sparseProduct x y = go 0 y
  where
    go n [] = n
    go n ((i,v):y') = go (n + (x!i) * v) y'

{- foldl' が Traversable なので動かないのかも
{-@ sparseProduct' :: x:Vector _ -> SparseN _ (vlen x) -> _ @-}
sparseProduct' x y = foldl' body 0 y
  where
    body sum (i, v) = sum + (x ! i) * v
-}