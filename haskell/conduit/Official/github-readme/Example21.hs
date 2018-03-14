#!/usr/bin/env stack
-- stack --resolver lts-11.0 script

{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

source :: Monad m => ConduitM i Int m ()
source = do
  yieldMany [1 .. 10]
  yieldMany [11 .. 20]

main :: IO ()
main = runConduit $ source .| mapM_C print

{-
$ ./Example21.hs
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
-}