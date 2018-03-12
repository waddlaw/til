#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

source :: ConduitM i Int IO ()
source = do
  liftIO $ putStrLn "acquire some resource"
  mapM_ (\x -> yieldOr x (putStrLn $ "cleaning up after: " ++ show x)) [1..10]

main :: IO ()
main = runConduit $ source .| takeC 2 .| printC

{-
$ ./Example11.hs
acquire some resource
1
2
cleaning up after: 2
-}