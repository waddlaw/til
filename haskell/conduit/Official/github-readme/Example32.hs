#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = print $ runConduitPure $ yieldMany [1 .. 10] .| do
  x <- takeWhileC (<= 5) .| sinkList
  y <- sinkList
  return (x, y)

{-
$ ./Example32.hs
([1,2,3,4,5],[6,7,8,9,10])
-}
