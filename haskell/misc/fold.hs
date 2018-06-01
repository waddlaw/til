--ex3 :: [a] -> [a] -> [a]
ex3 :: [a] -> [a] -> [a]
ex3 = (concat.) . zipWith pair
  where
    pair a b = [a,b]


{-
concat :: [[a]] -> [a]
(.) :: (b -> c) -> (a -> b) -> (a -> c)

zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
f :: a -> a -> [a]


(concat .) :: (a -> [[a]]) -> (a -> [a])
zipWith f :: [a] -> [a] -> [[a]]

(concat . zipWith f) :: [a] -> [a] -> [a]
-}

--f :: a -> a -> [a]
--f x y = [x,y]


-- foldr :: (a -> b -> b )-> b -> [a] -> b
-- foldr :: (a -> (c->d) -> (c->d))-> (c->d) -> [a] -> (c->d)
-- foldr :: (a -> (Int->d) -> (Int->d))-> (Int->d) -> [a] -> (Int->d)
-- foldr :: (a -> (Int->[a]) -> (Int->[a]))-> (Int->[a]) -> [a] -> (Int->[a])
-- foldr f :: (Int->[a]) -> [a] -> (Int->[a])
-- foldr f e :: [a] -> (Int->[a])

f :: a -> (Int->[a]) -> Int->[a]
--f :: Int -> (Int->[Int]) -> Int->[Int]
f a g 0 = []
f a g n = a:g (n-1)

e :: Int -> [a]
--e :: Int -> [Int]
e n = []

-- foldr f e [1..3] 2
-- f 1 (foldr f e [2..3]) 2
-- f 1 (f 2 (foldr f e [3])) 2
-- f 1 (f 2 (f 3 (foldr f e []))) 2
-- f 1 (f 2 (f 3 e)) 2

take' :: Int -> [a] -> [a]
take' n xs = foldr f e xs n
  where
    f a g 0 = []
    f a g n = a:g (n-1)
    e = const []


-- foldl :: (a -> b -> a) -> a -> [b] -> a
-- foldl :: ((c->d) -> b -> (c->d)) -> (c->d) -> [b] -> (c->d)
-- foldl :: ((Int->d) -> b -> (Int->d)) -> (Int->d) -> [b] -> (Int->d)
-- foldl :: ((Int->[b]) -> b -> (Int->[b])) -> (Int->[b]) -> [b] -> (Int->[b])
-- foldl f' :: (Int->[b]) -> [b] -> (Int->[b])
-- foldl f' e' :: [b] -> (Int->[b])
takeR :: Int -> [a] -> [a]
takeR n xs = foldl f e xs n
  where
    f g b 0 = []
    f g b n = b:g (n-1)
    e = const []

take'' :: Int -> [a] -> [a]
take'' n xs = foldl f e xs (length xs)
  where
    f g b 0 = []
    f g b m = if m <= n then g (m-1)++[b] else g (m-1)
    e = const []

f' :: (Int->[b]) -> b -> Int->[b]
f' g b 0 = []
f' g b n = b:g (n-1)

e' ::Int->[b]
e' = const []






