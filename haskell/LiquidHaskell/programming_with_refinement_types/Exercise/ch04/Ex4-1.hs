import Prelude hiding (head, null)
import Data.Vector

-- | Exercise 4.1
head'' :: Vector a -> Maybe a
head'' vec
  | null vec = Nothing
  | otherwise = Just $ head vec