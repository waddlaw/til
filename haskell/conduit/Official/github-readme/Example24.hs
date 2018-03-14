#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

trans :: Monad m => ConduitM Int Int m ()
trans = do
  takeC 5 .| mapC (+ 1)
  mapC (* 2)

main :: IO ()
main = runConduit $ yieldMany [1 .. 10] .| trans .| mapM_C print

{-
$ ./Example24.hs
2
3
4
5
6
12
14
16
18
20
-}
