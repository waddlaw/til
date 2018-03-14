#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit
import qualified System.IO as IO
import Data.ByteString (ByteString)

sourceFile' :: MonadResource m => FilePath -> ConduitM i ByteString m ()
sourceFile' fp = bracketP (IO.openBinaryFile fp IO.ReadMode) IO.hClose sourceHandle

sinkFile' :: MonadResource m => FilePath -> ConduitM ByteString o m ()
sinkFile' fp = bracketP (IO.openBinaryFile fp IO.WriteMode) IO.hClose sinkHandle

main :: IO ()
main = runResourceT
     $ runConduit
     $ sourceFile' "input.txt"
    .| sinkFile' "output.txt"

{-
$ ./Example42.hs
-}