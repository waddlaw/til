import Data.Set hiding (insert, filter)
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

{-@ type Implies P Q = {v:_ | v <=> (P => Q)} @-}

{-@ implies :: p:Bool -> q:Bool -> Implies p q @-}
implies :: Bool -> Bool -> Bool
implies False _    = True
implies _     True = True
implies _     _    = False

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

-- | Exercise 7.2 (Set Difference)
--
-- > quickCheck prop_cup_dif_bad
-- *** Failed! Falsifiable (after 3 tests):
-- fromList [()]
-- fromList [()]
{-@ prop_cup_dif_bad :: _ -> _ -> True @-}
prop_cup_dif_bad :: (Ord a) => Set a -> Set a -> Bool
prop_cup_dif_bad x y = pre `implies` (x == ((x `union` y) `difference` y))
  where
    pre = empty == intersection x y

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

-- {-@ append' :: xs:_ -> ys:_ -> ListUn a xs ys @-}
-- {-@ append' :: xs:_ -> ys:_ -> ListS a {Set_cup (elts xs) (elts ys)} @-}
{-@ append' :: xs:_ -> ys:_ -> {v:[a] | elts v = (Set_cup (elts xs) (elts ys)) } @-}
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

-- | Exercise 7.4 (Halve)

{-@ lazy halve @-}
{-@ halve :: Int -> xs:[a] -> {v:([a], [a]) | union (elts (fst v)) (elts (snd v)) = elts xs } @-}
halve :: Int -> [a] -> ([a], [a])
halve 0 xs = ([], xs)
halve n (x:y:zs) = (x:xs, y:ys) where (xs, ys) = halve (n-1) zs
halve _ xs = ([], xs)

{-@ prop_halve_append :: _ -> _ -> True @-}
prop_halve_append :: Ord a => Int -> [a] -> Bool
prop_halve_append n xs = elts xs == elts xs'
  where
    xs'      = append' ys zs
    (ys, zs) = halve n xs

-- | Exercise 7.5 (Membership)
{-@ elem :: (Eq a) => x:a -> xs:[a] -> { v:Bool | v = member x (elts xs) } @-}
elem :: Eq a => a -> [a] -> Bool
elem _ [] = False
elem x (y:ys) = x == y || elem x ys

{-@ test1 :: True @-}
test1 :: Bool
test1 = elem 2 [1,2,3]

{-@ test2 :: False @-}
test2 :: Bool
test2 = elem 2 [1,3]

{-@ insert :: x:a -> xs:[a] -> ListUn1 a x xs @-}
insert :: (Ord a) => a -> [a] -> [a]
insert x [] = [x]
insert x [y]
  | x <= y = [x, y]
  | otherwise = [y, x]
insert x (y:ys)
  | x <= y = x : y : ys
  | otherwise = y : insert x ys

{-@ insertSort :: (Ord a) => xs:[a] -> ListEq a xs @-}
insertSort :: (Ord a) => [a] -> [a]
insertSort [] = []
insertSort (x:xs) = insert x (insertSort xs)

-- | Exercise 7.6 (Merge)
{-@ lazy merge @-}
{-@ merge :: xs:[a] -> ys:[a] -> ListUn a xs ys @-}
merge [] ys = ys
merge xs [] = xs
merge (x:xs) (y:ys)
  | x <= y = x : merge xs (y:ys)
  | otherwise = y : merge (x:xs) ys

{-@ prop_merge_app :: _ -> _ -> True @-}
prop_merge_app xs ys = elts zs == elts zs'
  where
    zs = append' xs ys
    zs' = merge xs ys

-- | Exercise 7.7 (Merge Sort)
{-@ lazy mergeSort @-}
{-@ mergeSort :: (Ord a) => xs:[a] -> ListEq a xs @-}
mergeSort :: Ord a => [a] -> [a]
mergeSort [] = []
-- mergeSort [x] = [x]
mergeSort xs = merge (mergeSort ys) (mergeSort zs)
  where
    (ys, zs) = halve mid xs
    mid = length xs `div` 2

{-@ measure unique @-}
unique :: (Ord a) => [a] -> Bool
unique [] = True
unique (x:xs) = unique xs && not (member x (elts xs))

{-@ type UList a = { v:[a] | unique v } @-}

{-@ isUnique :: UList Int @-}
isUnique :: [Int]
isUnique = [1,2,3]

{- UNSAFE
{-@ isNotUnique :: UList Int @-}
isNotUnique :: [Int]
isNotUnique = [1,2,3,1]
-}

{-@ filter :: (a -> Bool) -> xs:UList a -> { v:ListSub a xs | unique v } @-}
filter :: (a -> Bool) -> [a] -> [a]
filter _ [] = []
filter f (x:xs)
  | f x = x:xs'
  | otherwise = xs'
  where
    xs' = filter f xs

-- | Exercise 7.8 (Filter)
{-@ filter' :: (a -> Bool) -> xs:[a] -> { v:ListSub a xs | unique xs => unique v } @-}
filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' f (x:xs)
  | f x = x : xs'
  | otherwise = xs'
  where
    xs' = filter' f xs

{-@ test3 :: UList _ @-}
test3 :: [Int]
test3 = filter' (> 2) [1,2,3,4]

{-@ test4 :: [_] @-}
test4 :: [Int]
test4 = filter' (> 3) [3,1,2,3]

-- | Exercise 7.9 (Reverse)
{-@ reverse :: xs:UList a -> UList a @-}
reverse :: Ord a => [a] -> [a]
reverse = go []
  where
    {-@ go :: acc:UList a -> { xs:UList a | intersection (elts acc) (elts xs) = empty } -> UList a / [len xs] @-}
    go acc [] = acc
    go acc (x:xs) = go (x:acc) xs

{-@ nub :: Eq a => [a] -> UList a @-}
nub :: Eq a => [a] -> [a]
nub xs = go [] xs
  where
    {-@ go :: Eq a => UList a -> xs:[a] -> UList a / [len xs] @-}
    go seen [] = seen
    go seen (x:xs)
      | x `isin` seen = go seen xs
      | otherwise = go (x:seen) xs

-- FIXME
{-@ predicate In X Xs = Set_mem X (elts Xs) @-}

{-@ isin :: x:_ -> ys:_ -> { v:Bool | v <=> In x ys } / [len ys] @-}
isin _ [] = False
isin x (y:ys)
  | x == y = True
  | otherwise = x `isin` ys

-- | Exercise 7.10 (Append)
{-@ append :: xs:UList a -> ys:{v:UList a | intersection (elts xs) (elts v) = empty} -> {v:UList a | union (elts xs) (elts ys) = elts v } @-}
append [] ys = ys
append (x:xs) ys = x : append xs ys

-- | Exercise 7.11 (Range)
{-@ type Btwn I J = { v:_ | I <= v && v < J } @-}

{-@ lazy range @-}
{-@ range :: i:Int -> j:Int -> UList (Btwn i j) @-}
range :: Int -> Int -> [Int]
range i j
  | i < j && unique xs = xs
  | otherwise = []
  where
    xs = i : range (i + 1) j

data Zipper a = Zipper {
    focus :: a
  , left :: [a]
  , right :: [a]
}

{-@ data Zipper a = Zipper {
      focus :: a
    , left  :: { v: UList a | not (In focus v)}
    , right :: { v: UList a | not (In focus v) && Disj v left }
    }
@-}

{-@ predicate Disj X Y = Disjoint (elts X) (elts Y) @-}
{-@ predicate Disjoint X Y = Inter (Set_empty 0) X Y @-}
{-@ predicate Inter X Y Z  = X = Set_cap Y Z         @-}

{-@ differentiate :: UList a -> Maybe (Zipper a) @-}
differentiate :: [a] -> Maybe (Zipper a)
differentiate [] = Nothing
differentiate (x:xs) = Just $ Zipper x [] xs

-- | Exercise 7.12 (Deconstructing Zippers)
{-@ integrate :: Ord a => Zipper a -> UList a @-}
integrate :: Ord a => Zipper a -> [a]
integrate (Zipper x l r) = reverse'' l `append''` (x : r)

{-@ reverse'' :: xs:UList a -> UList a @-}
reverse'' :: Ord a => [a] -> [a]
reverse'' = go []
  where
    {-@ go :: acc:UList a -> { xs:UList a | Disj acc xs } -> UList a / [len xs] @-}
    go acc [] = acc
    go acc (x:xs) = go (x:acc) xs

-- | Exercise 7.10 (Append)
{-@ append'' :: xs:UList a -> { ys:UList a | Disj xs ys} -> {v:UList a | Disj xs ys => union (elts xs) (elts ys) = elts v } @-}
append'' [] ys = ys
append'' (x:xs) ys = x : append'' xs ys

{-@ LIQUID "--no-totality" @-}
focusLeft :: Ord a => Zipper a -> Zipper a
focusLeft (Zipper t (l:ls) rs) = Zipper l ls (t:rs)
focusLeft (Zipper t [] rs)     = Zipper x xs []
  where
    (x:xs) = reverse (t:rs)

focusRight :: Ord a => Zipper a -> Zipper a
focusRight = reverseZipper . focusLeft . reverseZipper

reverseZipper :: Zipper a -> Zipper a
reverseZipper (Zipper t ls rs) = Zipper t rs ls

filterZipper :: (a -> Bool) -> Zipper a -> Maybe (Zipper a)
filterZipper p (Zipper f ls rs)
  = case filter p (f:rs) of
      f':rs' -> Just $ Zipper f' (filter p ls) rs'
      [] -> case filter p ls of
              f':ls' -> Just $ Zipper f' ls' []
              [] -> Nothing