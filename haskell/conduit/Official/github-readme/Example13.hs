#!/usr/bin/env stack
-- stack script --resolver lts-10.9
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit
import Data.Monoid (Product (..))

magic :: Int -> Int -> IO Int
magic total i = do
    putStrLn $ "Doing magic on " ++ show i
    return $! total * i

main :: IO ()
main = do
    res <- runConduit $ yieldMany [1 .. 10] .| foldMC magic 1
    print res

{-
$ ./Example13.hs
Doing magic on 1
Doing magic on 2
Doing magic on 3
Doing magic on 4
Doing magic on 5
Doing magic on 6
Doing magic on 7
Doing magic on 8
Doing magic on 9
Doing magic on 10
3628800
-}