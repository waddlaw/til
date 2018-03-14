#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = runConduit $ yieldMany [1..10] .| iterMC print .| sinkNull

{-
$ ./Example38.hs
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