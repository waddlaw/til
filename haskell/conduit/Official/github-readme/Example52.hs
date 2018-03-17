#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE PackageImports #-}
import Conduit
import "cryptonite-conduit" Crypto.Hash.Conduit (sinkHash)
import "cryptonite" Crypto.Hash (Digest, SHA256)
import Data.Void (Void)

main :: IO ()
main = do
    digest <- runConduitRes
            $ sourceFile "input.txt"
           .| getZipSink (ZipSink (sinkFile "output.txt") *> ZipSink sinkHash)
    print (digest :: Digest SHA256)

{-
$ ./Example52.hs
a8a2f6ebe286697c527eb35a58b5539532e9b3ae3b64d4eb0a46fb657b41562c
-}