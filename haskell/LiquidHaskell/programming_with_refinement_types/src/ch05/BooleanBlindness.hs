import Data.Maybe

{- UNSAFE
{-@ bad :: [Int] -> [Nat] @-}
bad :: [Int] -> [Int]
bad xs
  | all (\x -> x >= 0) xs = xs
  | otherwise             = []
-}

{-@ good :: [Int] -> [Nat] @-}
good :: [Int] -> [Int]
good xs
  | Just ys <- check xs = ys
  | otherwise           = []
  where
    check  = sequence . map (\x -> if 0 <= x then Just x else Nothing)