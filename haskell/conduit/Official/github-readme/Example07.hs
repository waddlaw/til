#!/usr/bin/env stack
-- stack script --resolver lts-10.9
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = print $ runConduitPure $ yieldMany [1 .. 100 :: Int] .| sumC

{-
$ ./Example07.hs
5050
-}
