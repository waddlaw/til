#!/usr/bin/env stack
-- stack script --resolver lts-11.0
import Conduit

main :: IO ()
main = runConduitRes $ sourceFile "input.txt" .| decodeUtf8C .| peekForeverE (do
    len <- lineC lengthCE
    liftIO $ print len)

{-
$ ./Example60.hs
15
-}