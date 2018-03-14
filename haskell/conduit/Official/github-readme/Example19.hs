#!/usr/bin/env stack
-- stack script --resolver lts-10.9
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings #-}
import Conduit

evenM :: Int -> IO Bool
evenM i = do
  let res = even i
  print (i, res)
  return res

main :: IO ()
main = runConduit $ yieldMany [1 .. 10] .| filterMC evenM .| mapM_C print

{-
$ ./Example19.hs
(1,False)
(2,True)
2
(3,False)
(4,True)
4
(5,False)
(6,True)
6
(7,False)
(8,True)
8
(9,False)
(10,True)
10
-}