#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = print $ runConduitPure $ yieldMany [1 .. 100 :: Int] .| foldlC (+) 0

{-
$ ./Example08.hs
5050
-}