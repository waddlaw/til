import Data.Maybe (fromJust)

{-@ type Btwn Lo Hi = { v:Int | Lo <= v && v < Hi} @-}

{-@ data Sparse a = SP
  { spDim :: Nat
  , spElems :: [(Btwn 0 spDim, a)]
  }
@-}
data Sparse a = SP
  { spDim :: Int
  , spElems :: [(Int, a)]
  } deriving Show

{-@ type SparseN a N = { v:Sparse a | spDim v == N } @-}

{-@ fromList :: d:Nat -> [(Int, a)] -> Maybe (SparseN a d) @-}
fromList :: Int -> [(Int, a)] -> Maybe (Sparse a)
fromList dim elts = SP dim <$> mapM check elts
  where
    check (x, y)
      | 0 <= x && x < dim = Just (x,y)
      | otherwise = Nothing

{-@ test1 :: SparseN String 3 @-}
test1 :: Sparse String
test1 = fromJust $ fromList 3 [(1, "cat"), (2, "mouse")]