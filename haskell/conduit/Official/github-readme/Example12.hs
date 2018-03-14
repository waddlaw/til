#!/usr/bin/env stack
-- stack script --resolver lts-10.9
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit
import Data.Monoid (Product (..))

magic :: Int -> IO (Product Int)
magic i = do
    putStrLn $ "Doing magic on " ++ show i
    return $ Product i

main :: IO ()
main = do
    Product res <- runConduit $ yieldMany [1 .. 10] .| foldMapMC magic
    print res

{-
$ ./Example12.hs
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