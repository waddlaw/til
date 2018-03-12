#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

main :: IO ()
main = runConduit $ return () .| undefined

{-
$ ./Example10.hs
Example10.hs: Prelude.undefined
CallStack (from HasCallStack):
  error, called at libraries/base/GHC/Err.hs:79:14 in base:GHC.Err
  undefined, called at /home/bm12/Desktop/repo/personal/til/haskell/conduit/Official/Web Programming and Streaming Data in Haskell/Example10.hs:7:34 in main:Main
-}