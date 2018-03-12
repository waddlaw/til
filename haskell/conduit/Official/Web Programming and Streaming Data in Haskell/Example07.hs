#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

source = do
  liftIO $ putStrLn "Source 1"
  yield ()
  liftIO $ putStrLn "Source 2"

sink = do
  liftIO $ putStrLn "Sink 1"
  _ <- await
  liftIO $ putStrLn "Sink 2"

main :: IO ()
main = runConduit $ source .| sink

{-
$ ./Example07.hs
Sink 1
Source 1
Sink 2
-}