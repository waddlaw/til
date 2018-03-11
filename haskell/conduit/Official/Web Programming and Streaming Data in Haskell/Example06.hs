#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

source = liftIO $ putStrLn "Entered the source"
sink = liftIO $ putStrLn "Entered the sink"

main :: IO ()
main = runConduit $ source .| sink

{-
$ ./Example06.hs
Entered the sink
-}