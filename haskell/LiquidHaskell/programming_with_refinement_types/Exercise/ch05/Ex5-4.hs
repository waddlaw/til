{-@
data IncList [llen] a = Emp
                      | (:<) { hd :: a
                             , tl :: IncList { v:a | hd <= v }
                             }
@-}
data IncList a = Emp
               | (:<) { hd :: a
                      , tl :: IncList a
                      }

infixr 9 :<

{-@ measure llen @-}
{-@ llen :: IncList a -> Nat @-}
llen :: IncList a -> Int
llen Emp = 0
llen (_:<xs) = 1 + llen xs

quickSort :: (Ord a) => [a] -> IncList a
quickSort [] = Emp
quickSort (x:xs) = append x lessers greaters
  where
    lessers  = quickSort [y | y <- xs, y < x]
    greaters = quickSort [z | z <- xs, z >= x]

{-@ append :: z:a -> IncList { v:a | v < z } -> IncList { v:a | v >= z } -> IncList a @-}
append :: a -> IncList a -> IncList a -> IncList a
append z Emp ys = z :< ys
append z (x :< xs) ys = x :< append z xs ys