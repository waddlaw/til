#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

source :: ConduitM i Int IO ()
source = do
  liftIO $ putStrLn "acquire some resource"
  mapM_ (\x -> yieldOr x
    (putStrLn $ "cleaning up after: " ++ show x)
    ) [1..10]

main :: IO ()
main = runConduit $ source .| takeC 2 .| (printC >> undefined)

{-
$ ./Example12.hs
acquire some resource
1
2
Example12.hs: Prelude.undefined
CallStack (from HasCallStack):
  error, called at libraries/base/GHC/Err.hs:79:14 in base:GHC.Err
  undefined, called at /home/bm12/Desktop/repo/personal/til/haskell/conduit/Official/Web Programming and Streaming Data in Haskell/Example12.hs:13:53 in main:Main
-}