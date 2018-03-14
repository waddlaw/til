#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

sink :: Monad m => ConduitM Int o m (String, Int)
sink = (,) <$> (takeC 5 .| mapC show .| foldC) <*> sumC

main :: IO ()
main = do
  let res = runConduitPure $ yieldMany [1 .. 10] .| sink
  print res

{-
$ ./Example22.hs
("12345",40)
-}