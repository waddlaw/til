#!/usr/bin/env stack
-- stack script --resolver lts-11.0
doubles :: [Double]
doubles = [1, 2, 3, 4, 5, 6]

average :: [Double] -> Double
average xs = sum xs / fromIntegral (length xs)

main :: IO ()
main = print $ average doubles

{-
$ ./Example50.hs
3.5
-}