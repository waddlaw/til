#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

-- Conduit を使うべきではない例
main :: IO ()
main = do
  print $ runConduitPure
        $ yieldMany [1..10]
       .| mapC (+1)
       .| sinkList

{-
$ ./Example03.hs
[2,3,4,5,6,7,8,9,10,11]
-}