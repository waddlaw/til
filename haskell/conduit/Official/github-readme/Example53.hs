#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE PackageImports #-}
{-# LANGUAGE OverloadedStrings #-}
import Conduit
import "cryptonite-conduit" Crypto.Hash.Conduit (sinkHash)
import "cryptonite" Crypto.Hash (Digest, SHA256)
import Data.Void (Void)
import Network.HTTP.Simple (httpSink)

main :: IO ()
main = do
    digest <- runResourceT $ httpSink "http://httpbin.org"
              (\_res -> getZipSink (ZipSink (sinkFile "output.txt") *> ZipSink sinkHash))
    print (digest :: Digest SHA256)

{-
$ ./Example53.hs
b8c9d06d14028584b5bb76765b782f3e676b95cccb6c68c3646c8f17222589f0
-}