import Prelude hiding (length)
import Data.Vector

{-@ safeLookup :: Vector a -> Int -> Maybe a @-}
safeLookup :: Vector a -> Int -> Maybe a
safeLookup x i
    | ok = Just (x ! i)
    | otherwise = Nothing
    where
      ok = 0 <= i && i < length x