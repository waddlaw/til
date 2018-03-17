#!/usr/bin/env stack
-- stack script --resolver lts-11.0
import Conduit

main :: IO ()
main = runConduitRes $ sourceFile "input.txt" .| decodeUtf8C .| do
    len <- lineC lengthCE
    liftIO $ print len

{-
$ ./Example59.hs
15
-}