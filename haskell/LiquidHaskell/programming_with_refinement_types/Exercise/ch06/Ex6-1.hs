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

{-@ measure notEmpty @-}
notEmpty :: [a] -> Bool
notEmpty [] = False
notEmpty (_:_) = True

{-@ average' :: [Int] -> Maybe Int @-}
average' :: [Int] -> Maybe Int
average' [] = Nothing
average' xs = Just $ divide (sum xs) $ size xs