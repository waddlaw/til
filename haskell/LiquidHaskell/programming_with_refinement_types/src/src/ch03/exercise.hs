{-@ type NonZero = { v:Int | v /= 0 } @-}

{-@ die :: { v:String | false } -> a @-}
die msg = error msg

{-@ divide :: Int -> NonZero -> Int @-}
divide :: Int -> Int -> Int
divide n 0 = die "divide by zero"
divide n d = n `div` d

-- Why does LiquidHaskell flag an error at n?
-- xs = [] の場合があるため

avg :: [Int] -> Int
avg [] = 0
avg xs = divide total n
  where
    total = sum xs
    n = length xs

-- 3.2 わからない


-- 3.3
{-@ lAssert :: { v:Bool | v } -> a -> a @-}
lAssert True x = x
lAssert False _ = die "yikes, assertion fails!"

yes = lAssert (1 + 1 == 2) ()
{- UNSAFE
no = lAssert (1 + 1 == 3) ()
-}
