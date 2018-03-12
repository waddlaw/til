#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

main :: IO ()
main = print
  $ runConduitPure
  $ yieldMany [1..10]
 .| foldlC (flip (:)) []

{-
$ ./Example16.hs
[10,9,8,7,6,5,4,3,2,1]
-}