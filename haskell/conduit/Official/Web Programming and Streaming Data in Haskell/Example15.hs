#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

main :: IO ()
main = print
  $ runConduitPure
  $ yieldMany [1..10::Double]
 .| getZipSink ((/)
      <$> ZipSink sumC
      <*> ZipSink (fromIntegral <$> lengthC))

{-
$ ./Example15.hs
5.5
-}