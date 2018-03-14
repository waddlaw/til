#!/usr/bin/env stack
-- stack script --resolver lts-10.9
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

magic :: Int -> IO Int
magic x = do
    putStrLn $ "I'm doing magic with " ++ show x
    return $ x * 2

main :: IO ()
main = do
    putStrLn "List version:"
    mapM magic (take 10 [1 ..]) >>= mapM_ print . takeWhile (< 18)
    putStrLn ""
    putStrLn "Conduit version:"
    runConduit
        $  yieldMany [1 ..]
        .| takeC 10
        .| mapMC magic
        .| takeWhileC (< 18)
        .| mapM_C print

{-
$ ./Example05.hs
List version:
I'm doing magic with 1
I'm doing magic with 2
I'm doing magic with 3
I'm doing magic with 4
I'm doing magic with 5
I'm doing magic with 6
I'm doing magic with 7
I'm doing magic with 8
I'm doing magic with 9
I'm doing magic with 10
2
4
6
8
10
12
14
16

Conduit version:
I'm doing magic with 1
2
I'm doing magic with 2
4
I'm doing magic with 3
6
I'm doing magic with 4
8
I'm doing magic with 5
10
I'm doing magic with 6
12
I'm doing magic with 7
14
I'm doing magic with 8
16
I'm doing magic with 9
-}
