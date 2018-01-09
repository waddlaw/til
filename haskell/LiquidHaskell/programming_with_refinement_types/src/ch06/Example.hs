import Prelude hiding (head, tail, null, foldl, foldl1, sum, map)

{-@ type NonZero = { v:Int | v /= 0 } @-}

{-@ die :: {v:_ | false} -> a @-}
die msg = error msg

{-@ divide :: Int -> NonZero -> Int @-}
divide :: Int -> Int -> Int
divide _ 0 = die "divide-by-zero"
divide x n = x `div` n

{-@ size :: xs:[a] -> { v:Nat | notEmpty xs => v > 0} @-}
size :: [a] -> Int
size [] = 0
size (_:xs) = 1 + size xs

-- | UNSAFE
-- avgMany xs = divide total elems
--   where
--     total = sum xs
--     elems = size xs

{-@ measure notEmpty @-}
notEmpty :: [a] -> Bool
notEmpty [] = False
notEmpty (_:_) = True

{-@ type NEList a = { v:[a] | notEmpty v} @-}

{-@ average :: NEList Int -> Int @-}
average :: [Int] -> Int
average xs = divide total elems
  where
    total = sum xs
    elems = size xs

-- | Exercise 5.1
{-@ average' :: [Int] -> Maybe Int @-}
average' :: [Int] -> Maybe Int
average' [] = Nothing
average' xs = Just $ divide (sum xs) $ size xs

-- | Exercise 5.2
{-@ type Pos = { v:Int | v > 0 } @-}

-- | xs が空リストの可能性があるのでエラー
-- {-@ size1 :: xs:NEList a -> Pos @-}
-- size1 :: [a] -> Int
-- size1 [] = 0
-- size1 (_:xs) = 1 + size1 xs

-- | v の型が Int なので UNSAFE (Nat にすれば SAFE)
-- {-@ size2 :: xs:[a] -> { v:Int | notEmpty xs => v > 0} @-}
-- size2 :: [a] -> Int
-- size2 [] = 0
-- size2 (_:xs) = 1 + size2 xs

{-@ head :: NEList a -> a @-}
head :: [a] -> a
head [] = die "Fear not! 'twill ne'er come to pass"
head (x:_) = x

{-@ tail :: NEList a -> [a] @-}
tail :: [a] -> [a]
tail [] = die "Relaxeth! this too shall ne'er be"
tail (_:xs) = xs

-- | Exercise 5.3
safeHead :: [a] -> Maybe a
safeHead xs
  | null xs = Nothing
  | otherwise = Just $ head xs

{-@ null :: xs:[a] -> { v:Bool | notEmpty xs <=> not v } @-}
null :: [a] -> Bool
null [] = True
null (_:_) = False

{-@ groupEq :: (Eq a) => [a] -> [NEList a] @-}
groupEq [] = []
groupEq (x:xs) = (x:ys) : groupEq zs
  where
    (ys, zs) = span (x ==) xs

-- | >>> eliminateStutter "ssstringssss liiiiiike thisss"
--   "strings like this"
eliminateStutter xs = map head $ groupEq xs

{-@ foldl1 :: (a -> a -> a) -> NEList a -> a @-}
foldl1 f (x:xs)    = foldl f x xs
foldl1 _ []        = die "foldl1"

foldl              :: (a -> b -> b) -> b -> [a] -> b
foldl _ acc []     = acc
foldl f acc (x:xs) = foldl f (f x acc) xs

{-@ sum :: (Num a) => NEList a -> a @-}
sum [] = die "cannot add up empty list"
sum xs = foldl1 (+) xs

sumOk :: Int
sumOk = sum [1,2,3,4,5]

-- | UNSAFE
-- sumBad :: Int
-- sumBad = sum []

-- | Exercise 5.4
{-@ wtAverage :: NEList (Pos, Pos) -> Int @-}
wtAverage :: [(Int, Int)] -> Int
wtAverage wxs = divide totElems totWeight
  where
    elems = map (\(w, x) -> w * x) wxs
    weights = map (\(w, _) -> w  ) wxs
    totElems = sum elems
    totWeight = sum weights
    sum = foldl1 (+)

{-@ map :: (a -> b) -> xs:[a] -> { ys:[b] | notEmpty xs => notEmpty ys } @-}
map :: (a -> b) -> [a] -> [b]
map _ [] = []
map f (x:xs) = f x : map f xs

-- | Exercise 5.5
{-@ risers :: (Ord a) => xs:[a] -> { ys:[[a]] | notEmpty xs => notEmpty ys } @-}
risers :: (Ord a) => [a] -> [[a]]
risers [] = []
risers [x] = [[x]]
risers (x:y:etc)
  | x <= y = (x:s) : ss
  | otherwise = [x] : (s : ss)
    where
      (s, ss) = safeSplit $ risers (y:etc)

{-@ safeSplit :: NEList a -> (a, [a]) @-}
safeSplit (x:xs) = (x, xs)
safeSplit _ = die "don't worry, be happy"