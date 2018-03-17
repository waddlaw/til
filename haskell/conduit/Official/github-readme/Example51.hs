#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit
import Data.Void (Void)

doubles :: [Double]
doubles = [1, 2, 3, 4, 5, 6]

average :: Monad m => ConduitM Double Void m Double
average =
    getZipSink (go <$> ZipSink sumC <*> ZipSink lengthC)
  where
    go total len = total / fromIntegral len

main :: IO ()
main = print $ runConduitPure $ yieldMany doubles .| average

{-
$ ./Example51.hs
3.5
-}