#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit
import System.FilePath (takeExtension)

main :: IO ()
main = runConduitRes
     $ sourceDirectoryDeep True "."
    .| filterC (\fp -> takeExtension fp == ".hs")
    .| awaitForever sourceFileBS
    .| sinkFileBS "all-haskell-files"

{-
$ ./Example44.hs
-}