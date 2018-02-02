import Prelude hiding (map, foldl, foldl1, head, tail, null)

{-@ type NonZero = { v:Int | v /= 0 } @-}
{-@ type Pos = { v:Int | v > 0 } @-}

{-@ measure notEmpty @-}
notEmpty :: [a] -> Bool
notEmpty [] = False
notEmpty (_:_) = True

{-@ type NEList a = { v:[a] | notEmpty v} @-}

{-@ die :: {v:_ | false} -> a @-}
die msg = error msg

{-@ divide :: Int -> NonZero -> Int @-}
divide :: Int -> Int -> Int
divide _ 0 = die "divide-by-zero"
divide x n = x `div` n

{-@ foldl1 :: (a -> a -> a) -> NEList a -> a @-}
foldl1 f (x:xs)    = foldl f x xs
foldl1 _ []        = die "foldl1"

foldl              :: (a -> b -> b) -> b -> [a] -> b
foldl _ acc []     = acc
foldl f acc (x:xs) = foldl f (f x acc) xs

{-@ wtAverage :: NEList (Pos, Pos) -> Int @-}
wtAverage :: [(Int, Int)] -> Int
wtAverage wxs = divide totElems totWeight
  where
    elems     = map (\(w, x) -> w * x) wxs
    weights   = map (\(w, _) -> w  ) wxs
    totElems  = sum elems
    totWeight = sum weights
    sum = foldl1 (+)

-- {-@ map :: (a -> b) -> xs:[a] -> { ys:[b] | notEmpty xs => notEmpty ys } @-}
map :: (a -> b) -> [a] -> [b]
map f xs
  | null xs   = error "die"
  | singleton xs = f (head xs) : []
  | otherwise = f (head xs) : map f xs
-- map _ [] = []
-- map f (x:xs) = f x : map f xs

{-@ singleton :: NEList a -> Bool @-}
singleton :: [a] -> Bool
singleton [_] = True
singleton _ = False

{-@ head :: NEList a -> a @-}
head :: [a] -> a
head [] = die "Fear not! 'twill ne'er come to pass"
head (x:_) = x

{-@ null :: xs:[a] -> { v:Bool | notEmpty xs <=> not v } @-}
null :: [a] -> Bool
null [] = True
null (_:_) = False