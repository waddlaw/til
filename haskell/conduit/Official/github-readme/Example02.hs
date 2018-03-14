#!/usr/bin/env stack
-- stack script --resolver lts-10.9
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = do
    putStrLn "List version:"
    print $ take 10 [1 ..]
    putStrLn ""
    putStrLn "Conduit version:"
    print $ runConduitPure $ yieldMany [1 ..] .| takeC 10 .| sinkList

{-
$ ./Example02.hs
List version:
[1,2,3,4,5,6,7,8,9,10]

Conduit version:
[1,2,3,4,5,6,7,8,9,10]
-}
