#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = runConduit $ yieldMany [1..10] .| iterMC print .| return ()

{-
$ ./Example37.hs
-}