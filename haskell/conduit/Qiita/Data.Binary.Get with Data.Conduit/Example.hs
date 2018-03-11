#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

{-# LANGUAGE OverloadedStrings #-}

import Data.Binary.Get (Get, getByteString, getWord16be, getWord8)
import qualified Data.ByteString as BS (ByteString)
import Data.Conduit
import Data.Conduit.Serialization.Binary (sinkGet)
import Data.Word (Word16, Word8)


query :: BS.ByteString
query = "\64\64\0ABC"

qSource :: Monad m => Source m BS.ByteString
qSource = yield query

getter :: Get (Word8, Word16, BS.ByteString)
getter = (,,) <$> getWord8 <*> getWord16be <*> getByteString 3

main :: IO ()
main = do
  result <- qSource $$ sinkGet getter
  print result

{-
$ ./Example.hs
(64,16384,"ABC")
-}