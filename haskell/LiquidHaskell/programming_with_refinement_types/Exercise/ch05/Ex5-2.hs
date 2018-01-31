{-@ type Btwn Lo Hi = { v:Int | Lo <= v && v < Hi} @-}

{-@
data Sparse a = SP
  { spDim :: Nat
  , spElems :: [(Btwn 0 spDim, a)]
  }
@-}
data Sparse a = SP
  { spDim :: Int
  , spElems :: [(Int, a)]
  } deriving Show

{-@ type SparseN a N = { v:Sparse a | spDim v == N } @-}

-- 仮定その1: 昇順
-- 仮定その2: 重複しない
{-@ plus :: Num a => v:Sparse a -> SparseN a (spDim v) -> SparseN a (spDim v) @-}
plus :: (Num a) => Sparse a -> Sparse a -> Sparse a
plus (SP d xs) (SP _ ys) = SP d $ plus' xs ys
  where
    {-@ plus' :: xs:_ -> ys:_ -> zs:_ / [len xs, len ys] @-}
    plus' xs [] = xs
    plus' [] ys = ys
    plus' xs@((i1, v1):xs') ys@((i2, v2):ys')
      | i1 == i2 = (i1, v1 + v2) : plus' xs' ys'
      | i1 < i2 = (i1, v1) : plus' xs' ys
      | otherwise = (i2, v2) : plus' xs ys'

-- {-@ plus :: Num a => v1:Sparse a -> SparseN a (spDim v1) -> SparseN a (spDim v1) @-}
-- plus :: Num a => Sparse a -> Sparse a -> Sparse a
-- plus (SP d x) (SP _ y) = SP d (x' ++ y' ++ xy)
--   where
--     xis = map fst x
--     yjs = map fst y
--     x'  = filter (\(i, _) -> i `notElem` yjs) x
--     y'  = filter (\(i, _) -> i `notElem` xis) y
--     xy  = [ (i, v+w) | (i, v) <- x , (j, w) <- y
--                      , i == j ]

{-@ test2 :: SparseN Int 3 @-}
test2 :: Sparse Int
test2 = plus vec1 vec2
  where
    vec1 = SP 3 [(0, 12), (2, 9)]
    vec2 = SP 3 [(0, 8), (1, 100)]