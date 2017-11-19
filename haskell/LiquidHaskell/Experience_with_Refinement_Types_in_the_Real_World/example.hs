{-@ LIQUID "--short-names" @-}

{-@ type Nat = { v:Int | 0 <= v } @-}
{-@ type Pos = { v:Int | 0 <  v } @-}

{-@ predicate Btwn Lo N Hi = Lo <= N && N < Hi @-}
{-@ type Rng Lo Hi = { v:Int | (Btwn Lo v Hi) } @-}
--{-@ range :: lo:Int -> hi:{Int | lo <= hi} -> [(Rng lo hi)] @-}
{-@ range :: lo:Int -> hi:{Int | lo <= hi} -> [{ v:Int | lo <= v && v < hi }] @-}
range :: Int -> Int -> [Int]
range lo hi
  | lo <= hi = lo : range (lo + 1) hi
  | otherwise = []
