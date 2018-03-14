#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit
import Data.Monoid (Sum(..))

main :: IO ()
main =
  print $ getSum $ runConduitPure $ yieldMany [1 .. 100 :: Int] .| foldMapC Sum

{-
$ ./Example09.hs
5050
-}
