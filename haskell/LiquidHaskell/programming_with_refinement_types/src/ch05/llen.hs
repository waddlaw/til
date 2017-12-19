{-@ data IncList [llen] a = Emp | (:<) { hd :: a, tl :: IncList { v:a | hd <= v }} @-}
data IncList a = Emp | (:<) { hd :: a, tl :: IncList a }

{-@ measure llen @-}
{-@ llen :: IncList a -> Nat @-}
llen :: IncList a -> Int
llen Emp = 0
llen (_:<xs) = 1 + llen xs

{-@ append :: z:a -> IncList { v:a | v < z } -> IncList { v:a | v >= z } -> IncList a / [lllen xs] @-}
append :: (Ord a) => a -> IncList a  -> IncList a -> IncList a
append z Emp ys = z :< ys
append z (x :< xs) ys = x :< append z xs ys