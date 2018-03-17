#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE PackageImports       #-}

import           Conduit
import           Control.Monad
import           Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import qualified System.IO       as IO

myTakeCE :: Monad m => Int -> ConduitM ByteString ByteString m ()
myTakeCE n | n <= 0    = return ()
           | otherwise = await >>= maybe (return ()) myTakeCE'
 where
  myTakeCE' x = do
    unless (BS.null x') $ yield x'
    unless (BS.null y)  $ leftover y
    myTakeCE (n - m)
   where
    m       = BS.length x
    (x', y) = BS.splitAt n x

-- main :: IO ()
-- main = runConduitRes
--      $ mySourceFile "input.txt"
--     .| myTakeCE 5
--     .| myTakeCE 5
--     .| printC

main :: IO ()
main = do
  res <-
    runConduitRes
    $  mySourceFile "input.txt"
    .| ((,) <$> (takeCE 5 .| sinkList) <*> (sinkList))
  putStrLn $ mconcat ["takeCE  : ", show res]

  res2 <-
    runConduitRes
    $  mySourceFile "input.txt"
    .| ((,) <$> (myTakeCE 5 .| sinkList) <*> (sinkList))
  putStrLn $ mconcat ["myTakeCE: ", show res2]

{-
$ ./Example49.hs
This
-}

newtype ReadHandle = ReadHandle IO.Handle

myOpenFile :: FilePath -> IO ReadHandle
myOpenFile fp = ReadHandle `fmap` IO.openBinaryFile fp IO.ReadMode

myCloseFile :: ReadHandle -> IO ()
myCloseFile (ReadHandle h) = IO.hClose h

myReadChunk :: ReadHandle -> IO ByteString
myReadChunk (ReadHandle h) = BS.hGetSome h chunkSize where chunkSize = 5

mySourceFile :: FilePath -> ConduitM i ByteString (ResourceT IO) ()
mySourceFile fp = bracketP (myOpenFile fp) myCloseFile loop
 where
  loop h = do
    bs <- liftIO $ myReadChunk h
    unless (BS.null bs) $ do
      yield bs
      loop h
