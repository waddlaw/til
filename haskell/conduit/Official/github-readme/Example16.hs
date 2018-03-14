#!/usr/bin/env stack
-- stack script --resolver lts-10.9
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = runConduit $ yieldMany [1 .. 10] .| intersperseC 0 .| mapM_C print

{-
$ ./Example16.hs
1
0
2
0
3
0
4
0
5
0
6
0
7
0
8
0
9
0
10
-}