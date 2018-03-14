#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = runConduit
     $ yieldMany [1..10]
    .| iterMC print
    .| liftIO (putStrLn "I was called")
    .| sinkNull

{-
$ ./Example40.hs
I was called
-}