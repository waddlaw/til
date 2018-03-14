#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = runConduitRes
     $ sourceFile "input.txt"
    .| takeCE 5
    .| stdoutC

{-
$ ./Example48.hs
This
-}