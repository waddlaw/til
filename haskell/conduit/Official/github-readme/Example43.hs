#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = runConduitRes $ sourceFileBS "input.txt" .| sinkFileBS "output.txt"

{-
$ ./Example43.hs
-}