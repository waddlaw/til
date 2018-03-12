#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

main :: IO ()
main = runConduit
  $ yieldMany [1..10::Int]
 .| do
      mapC id .| (await >>= maybe (return ()) leftover)
      printC
 .| do
      leftover "Hello There!"
      printC
{-
$ ./Example21.hs
"Hello There!"
2
3
4
5
6
7
8
9
10
-}