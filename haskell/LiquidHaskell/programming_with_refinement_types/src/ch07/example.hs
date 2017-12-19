{-@ measure size @-}
{-@ size :: xs:[a] -> { v:Nat | v = size xs } @-}
size :: [a] -> Int
size [] = 0
size (_:rs) = 1 + size rs

type List a = [a]

{-@ type ListN a N = { v:List a | size v = N} @-}
{-@ type ListX a X = ListN a { size X } @-}

{-@ reverse :: xs:List a -> ListX a xs @-}
reverse :: [a] -> [a]
reverse xs = go [] xs
  where
    {-@ go :: xs:List a -> ys:List a -> ListN a {size xs + size ys} @-}
    {-@ decrease go 2 @-}
    go acc [] = acc
    go acc (x:xs) = go (x:acc) xs