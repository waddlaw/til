#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

source :: ConduitM i Int (ResourceT IO) ()
source = bracketP
  (putStrLn "acquire some resource")
  (\() -> putStrLn "cleaning up")
  (\() -> mapM_ yield [1..10])

main :: IO ()
main = runConduitRes $ source .| takeC 2 .| (printC >> undefined)

{-
$ ./Example13.hs
acquire some resource
1
2
cleaning up
Example13.hs: Prelude.undefined
CallStack (from HasCallStack):
  error, called at libraries/base/GHC/Err.hs:79:14 in base:GHC.Err
  undefined, called at /home/bm12/Desktop/repo/personal/til/haskell/conduit/Official/Web Programming and Streaming Data in Haskell/Example13.hs:13:56 in main:Main
-}