#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

-- bad example

main :: IO ()
main = print
  $ runConduitPure
  $ yieldMany [1..10 :: Double]
 .| ((/) <$> sumC <*> (fromIntegral <$> lengthC))

{-
$ ./Example14.hs
Infinity
-}