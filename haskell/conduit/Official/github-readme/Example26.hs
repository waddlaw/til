#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = runConduit $ yield 1 .| mapM_C print

{-
$ ./Example26.hs
1
-}