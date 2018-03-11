#!/usr/bin/env stack
-- stack --resolver lts-9.10 script

module Main (main) where

import Control.Monad.Trans.Resource
import Data.Char (ord, chr, toUpper)
import Data.Conduit
import qualified Data.Conduit.List as CL
import qualified Data.Conduit.Binary as B
import qualified Data.ByteString as BS
import Data.Word (Word8)
import System.IO (stdin, stdout)

main :: IO ()
main = runResourceT $ do
  B.sourceHandle stdin
    $= B.takeWhile (\c -> c /= word8 '.')
    $= filterUc
    $$ B.sinkHandle stdout
  return ()
  where
    word8 = fromIntegral . ord

filterUc :: Monad m => Conduit BS.ByteString m BS.ByteString
filterUc = CL.map ucString
  where
    uc :: Word8 -> Word8
    uc = fromIntegral . ord . toUpper . chr .fromIntegral
    ucString :: BS.ByteString -> BS.ByteString
    ucString = BS.map uc

{-
$ ./Example.hs
aaa
AAA
ee
EE
.
-}