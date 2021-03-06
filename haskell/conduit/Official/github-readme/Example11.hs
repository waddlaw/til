#!/usr/bin/env stack
-- stack script --resolver lts-10.9
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main =
    putStrLn
        $  runConduitPure
        $  yieldMany [1 .. 10 :: Int]
        .| mapC show
        .| unlinesC
        .| foldC

{-
$ ./Example11.hs
1
2
3
4
5
6
7
8
9
10

-}