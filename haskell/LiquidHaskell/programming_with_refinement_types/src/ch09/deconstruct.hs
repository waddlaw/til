{-@ measure size @-}
{-@ size :: q:[a] -> { v:Nat | v = size q } @-}
size :: [a] -> Int
size [] = 0
size (x:xs) = size xs + 1

{-@ type ListN a N = { v:[a] | size v = N } @-}

{-@ LIQUID "--no-totality" @-}
{-@ f :: { xs:[a] | size xs > 0 } -> ListN a {size xs - 1} @-}
f :: [a] -> [a]
f (x:xs) = xs