#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = print $ runConduitPure $ return () .| do
    mapM_ leftover [1..10]
    sinkList

{-
$ ./Example36.hs
[10,9,8,7,6,5,4,3,2,1]
-}