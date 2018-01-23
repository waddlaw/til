import           Data.Set hiding (insert, filter)
import Prelude hiding (elem, filter, reverse)

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

-- | Exercise 7.2
{- TODO
{-@ prop_cup_dif_bad :: _ -> _ -> True @-}
prop_cup_dif_bad :: (Ord a) => Set a -> Set a -> Bool
prop_cup_dif_bad x y = pre `implies` (x == ((x `union` y) `difference` y))
  where
    pre = True
-}

{-@ measure elts @-}
elts :: (Ord a) => [a] -> Set a
elts []     = empty
elts (x:xs) = singleton x `union` elts xs

{-@ type ListS a S = {v:[a] | elts v = S} @-}
{-@ type ListEmp a = ListS a {Set_empty 0} @-}
{-@ type ListEq a X = ListS a {elts X} @-}
{-@ type ListSub a X = {v:[a] | Set_sub (elts v) (elts X)} @-}
{-@ type ListUn a X Y = ListS a {Set_cup (elts X) (elts Y)} @-}
{-@ type ListUn1 a X Y = ListS a {Set_cup (Set_sng X) (elts Y)} @-}

{-@ append' :: xs:_ -> ys:_ -> ListUn a xs ys @-}
append' :: [a] -> [a] -> [a]
append' [] ys     = ys
append' (x:xs) ys = x : append' xs ys

-- | Exercise 7.3 (Reverse)
{-@ reverse' :: xs:[a] -> ListEq a xs @-}
reverse' :: [a] -> [a]
reverse' xs = revHelper [] xs

{-@ revHelper :: xs:[a] -> ys:[a] -> ListUn a xs ys / [len ys] @-}
revHelper :: [a] -> [a] -> [a]
revHelper acc []     = acc
revHelper acc (x:xs) = revHelper (x:acc) xs

-- -- | Exercise 7.4
-- halve :: Int -> [a] -> ([a], [a])
-- halve 0 xs       = ([], xs)
-- halve n (x:y:zs) = (x:xs, y:ys)
--   where
--     (xs, ys) = halve (n-1) zs
-- halve _ xs = ([], xs)

-- {-@ prop_halve_append :: _ -> _ -> True @-}
-- prop_halve_append n xs = elts xs == elts xs'
--   where
--     xs' = append' ys zs
--     (ys, zs) = halve n xs

-- | Exercise 7.5
{-@ elem :: (Eq a) => x:a -> xs:[a] -> { v:Bool | v <=> member x (elts xs) } @-}
elem :: Eq a => a -> [a] -> Bool
elem x (y:ys) = x == y || elem x ys
elem _ [] = False

{-@ test1 :: True @-}
test1 :: Bool
test1 = elem 2 [1,2,3]

{-@ test2 :: False @-}
test2 :: Bool
test2 = elem 2 [1,3]

{-@ insert :: x:a -> xs:[a] -> ListUn1 a x xs @-}
insert :: (Ord a) => a -> [a] -> [a]
insert x [] = [x]
insert x (y:ys)
  | x <= y = x : y :ys
  | otherwise = y : insert x ys

{-@ insertSort :: (Ord a) => xs:[a] -> ListEq a xs @-}
insertSort :: (Ord a) => [a] -> [a]
insertSort [] = []
insertSort (x:xs) = insert x (insertSort xs)

-- | Exercise 7.6 (Merge)
-- {-@ merge :: xs:[a] -> ys:[a] -> [a] @-}
-- merge (x:xs) (y:ys)
--   | x <= y = x : merge xs (y:ys)
--   | otherwise = y : merge (x:xs) ys
-- merge [] ys = ys
-- merge xs [] = xs

-- {-@ prop_merge_app :: _ -> _ -> True @-}
-- prop_merge_app xs ys = elts zs == elts zs'
--   where
--     zs = append' xs ys
--     zs' = merge xs ys

-- | Exercise 7.7 (Merge Sort)
-- {-@ mergeSort :: (Ord a) => xs:[a] -> ListEmp a @-}
-- mergeSort [] = []
-- mergeSort xs = merge (mergeSort ys) (mergeSort zs)
--   where
--     (ys, zs) = halve mid xs
--     mid = length xs `div` 2

{-@ measure unique @-}
unique :: (Ord a) => [a] -> Bool
unique [] = True
unique (x:xs) = unique xs && not (member x (elts xs))

{-@ type UList a = { v:[a] | unique v} @-}

{-@ isUnique :: UList Int @-}
isUnique :: [Int]
isUnique = [1,2,3]

-- UNSAFE {-@ isNotUnique :: UList Int @-}
isNotUnique :: [Int]
isNotUnique = [1,2,3,1]

{-@ filter :: (a -> Bool) -> xs:UList a -> { v:ListSub a xs | unique v} @-}
filter _ [] = []
filter f (x:xs)
  | f x = x:xs'
  | otherwise = xs'
  where
    xs' = filter f xs

-- | Exercise 7.8 (Filter)
-- filter' _ [] = []
-- filter' f (x:xs)
--   | f x = x : xs'
--   | otherwise = xs'
--   where
--     xs' = filter' f xs

-- {-@ test3 :: UList _ @-}
-- test3 = filter' (> 2) [1,2,3,4]

-- {-@ test4 :: [_] @-}
-- test4 = filter' (> 3) [3,1,2,3]

-- | Exercise 7.9 (Reverse)
{-@ reverse :: xs:UList a -> UList a @-}
reverse = go []
  where
    {-@ go :: a:[a] -> xs:UList a -> UList a @-}
    go a [] = a
    go a (x:xs) = go (x:a) xs

-- {-@ nub :: [a] -> UList a @-}
-- nub xs = go [] xs
--   where
--     go seen [] = seen
--     go seen (x:xs)
--       | x `isin` seen = go seen xs
--       | otherwise = go (x:seen) xs

-- -- FIXME
-- {-@ predicate In X Xs = Set_mem X (elts Xs) @-}

-- {-@ isin :: x:_ -> ys:_ -> { v:Bool | v <=> In x ys } @-}
-- isin x (y:ys)
--   | x == y = True
--   | otherwise = x `isin` ys
-- isin _ [] = False