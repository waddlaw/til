{-@ type NonZero = { v:Int | v /= 0 } @-}

{-@ divide :: Int -> NonZero -> Maybe Int @-}
divide :: Int -> Int -> Maybe Int
divide _ 0 = Nothing
divide x n = Just $ x `div` n

{-@ measure notEmpty @-}
notEmpty :: [a] -> Bool
notEmpty [] = False
notEmpty (_:_) = True

{-@ size :: xs:[a] -> { v:Nat | notEmpty xs => v > 0} @-}
size :: [a] -> Int
size [] = 0
size (_:xs) = 1 + size xs

{-@ average' :: [Int] -> Maybe Int @-}
average' :: [Int] -> Maybe Int
average' [] = Nothing
average' xs = divide (sum xs) $ size xs
