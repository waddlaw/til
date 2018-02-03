{-@ type NonZero = { v:Int | v /= 0 } @-}

{-@ die :: { v:String | false } -> a @-}
die msg = error msg

{-@ divide :: Int -> NonZero -> Int @-}
divide :: Int -> Int -> Int
divide n 0 = die "divide by zero"
divide n d = n `div` d

-- {-@ result :: Int -> NonZero -> String @-}
result :: Int -> Int -> String
result n d
  | isPositive d = "Result = " ++ show (n `divide` d)
  | otherwise    = "Humph, please enter positive denominator!"

{-@ isPositive :: x:Int -> { v:Bool | x > 0 <=> v } @-}
isPositive :: Int -> Bool
isPositive x = x > 0