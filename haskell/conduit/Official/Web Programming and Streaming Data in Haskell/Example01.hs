#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

-- Conduit を使うべきではない例
main :: IO ()
main =
  print $ runConduitPure
        $ yieldMany [1..10]
       .| sumC

{-
$ ./Example01.hs
55
-}