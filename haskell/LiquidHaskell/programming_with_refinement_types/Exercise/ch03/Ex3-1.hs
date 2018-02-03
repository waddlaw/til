{-@ type NonZero = { v:Int | v /= 0 } @-}

{-@ die :: { v:String | false } -> a @-}
die msg = error msg

{-@ divide :: Int -> NonZero -> Int @-}
divide :: Int -> Int -> Int
divide n 0 = die "divide by zero"
divide n d = n `div` d

avg :: [Int] -> Int
avg [] = 0
avg xs = divide total n
  where
    total = sum xs
    n     = length xs