#!/usr/bin/env stack
-- stack script --resolver lts-10.9
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = runConduit $ yieldMany [1 .. 10] .| filterC even .| mapM_C print

{-
$ ./Example15.hs
2
4
6
8
10
-}