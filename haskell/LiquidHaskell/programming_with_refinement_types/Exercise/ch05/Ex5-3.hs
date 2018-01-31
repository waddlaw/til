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

{-@ insert :: (Ord a) => a -> IncList a -> IncList a @-}
insert :: (Ord a) => a -> IncList a -> IncList a
insert y Emp = y :< Emp
insert y (x :< xs)
  | y <= x = y :< x :< xs
  | otherwise = x :< insert y xs

{-@ insertSort' :: (Ord a) => [a] -> IncList a @-}
insertSort' :: (Ord a) => [a] -> IncList a
insertSort' = foldr insert Emp