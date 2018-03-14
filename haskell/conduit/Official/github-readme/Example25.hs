#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

trans :: Monad m => ConduitM Int Int m ()
trans = do
  takeC 3 .| mapC (+ 1)
  takeC 3 .| mapC (+ 10)
  dropC 1
  takeC 3 .| mapC (+ 100)

main :: IO ()
main = runConduit $ yieldMany [1 .. 10] .| trans .| mapM_C print

{-
$ ./Example25.hs
2
3
4
14
15
16
108
109
110
-}
