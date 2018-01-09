import Data.Set

{-@ measure empty :: Set a @-}
{-@ measure singleton :: a -> Set a @-}
{-@ measure member :: a -> Set a -> Bool @-}
{-@ measure union :: Set a -> Set a -> Set a @-}
{-@ measure intersection :: Set a -> Set a -> Set a @-}
{-@ measure difference :: Set a -> Set a -> Set a @-}

{-@ type True  = {v:Bool |     v} @-}
{-@ type False = {v:Bool | not v} @-}

{-@ prop_one_plus_one_eq_two :: _ -> True @-}
prop_one_plus_one_eq_two :: (Eq a, Num a) => a -> Bool
prop_one_plus_one_eq_two x = (x == 1 + 1) `implies` (x == 2)

{-@ implies :: p:Bool -> q:Bool -> Implies p q @-}
implies :: Bool -> Bool -> Bool
implies False _    = True
implies _     True = True
implies _     _    = False

{-@ type Implies P Q = {v:_ | v <=> (P => Q)} @-}

-- | Exercise 7.1 (Bounded Addition)
{-@ prop_x_y_200 :: _ -> _ -> True @-}
prop_x_y_200 :: (Ord a, Num a) => a -> a -> Bool
prop_x_y_200 x y = (x < 100 && y < 100) `implies` (x + y < 200)

{-@ prop_intersection_comm :: _ -> _ -> True @-}
prop_intersection_comm :: (Ord a) => Set a -> Set a -> Bool
prop_intersection_comm x y = (x `intersection` y) == (y `intersection` x)

{-@ prop_union_assoc :: _ -> _ -> _ -> True @-}
prop_union_assoc :: (Ord a) => Set a -> Set a -> Set a -> Bool
prop_union_assoc x y z = (x `union` (y `union` z)) == (x `union` y) `union` z

{-@ prop_intersection_dist :: _ -> _ -> _ -> True @-}
prop_intersection_dist :: (Ord a) => Set a -> Set a -> Set a -> Bool
prop_intersection_dist x y z = x `intersection` (y `union` z) == (x `intersection` y) `union` (x `intersection` z)

{- TODO
{-@ prop_cup_dif_bad :: _ -> _ -> True @-}
prop_cup_dif_bad :: (Ord a) => Set a -> Set a -> Bool
prop_cup_dif_bad x y = pre `implies` (x == ((x `union` y) `difference` y))
  where
    pre = True
-}

{-@ measure elts @-}
elts :: (Ord a) => [a] -> Set a
elts [] = empty
elts (x:xs) = singleton x `union` elts xs

{-@ type ListS a S = {v:[a] | elts v = S} @-}
{-@ type ListEmp a = ListS a {Set_empty 0} @-}
{-@ type ListEq a X = ListS a {elts X} @-}
{-@ type ListSub a X = {v:[a] | Set_sub (elts v) (elts X)} @-}
{-@ type ListUn a X Y = ListS a {Set_cup (elts X) (elts Y)} @-}
{-@ type ListUn1 a X Y = ListS a {Set_cup (Set_sng X) (elts Y)} @-}

{-@ append' :: xs:_ -> ys:_ -> ListUn a xs ys @-}
append' :: [a] -> [a] -> [a]
append' [] ys = ys
append' (x:xs) ys = x : append' xs ys

-- | Exercise 7.3 (Reverse)
{-@ reverse' :: xs:[a] -> ListEq a xs @-}
reverse' :: [a] -> [a]
reverse' xs = revHelper [] xs

{-@ revHelper :: xs:[a] -> ys:[a] -> ListUn a xs ys / [len ys] @-}
revHelper :: [a] -> [a] -> [a]
revHelper acc []     = acc
revHelper acc (x:xs) = revHelper (x:acc) xs