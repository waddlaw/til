#!/usr/bin/env stack
-- stack script --resolver lts-10.9
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = runConduit $ yieldMany [1 .. 10] .| mapC (* 2) .| mapM_C print

{-
$ ./Example14.hs
2
4
6
8
10
12
14
16
18
20
-}