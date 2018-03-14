#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit
import qualified System.IO as IO
import qualified Data.Conduit.Binary as CB

main :: IO ()
main = IO.withBinaryFile "input.txt" IO.ReadMode $ \inH ->
       IO.withBinaryFile "output.txt" IO.WriteMode $ \outH ->
       runConduit $ CB.sourceHandle inH .| CB.sinkHandle outH

{-
$ ./Example41.hs
-}