#!/usr/bin/env stack
-- stack script --resolver lts-10.9
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = do
  res <- runConduit $ yieldMany [1 .. 10] .| iterMC print .| sumC
  print res

{-
$ ./Example20.hs
1
2
3
4
5
6
7
8
9
10
55
-}