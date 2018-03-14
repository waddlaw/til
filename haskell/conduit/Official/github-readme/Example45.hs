#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit
import qualified Data.Text as T
import Data.Char (toUpper)

main :: IO ()
main = runConduitRes
     $ sourceFile "input.txt"
    .| decodeUtf8C
    .| mapC (T.map toUpper)
    .| encodeUtf8C
    .| stdoutC

{-
$ ./Example45.hs
THIS IS A TEST.
-}