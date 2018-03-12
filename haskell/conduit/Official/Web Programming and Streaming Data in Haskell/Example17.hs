#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

main :: IO ()
main = runConduit
  $ yieldMany [1..10]
 .| (foldMC f 0 >>= liftIO . print)
 where
  f total x = do
    putStrLn $ "Received: " ++ show x
    return $ total + x

{-
$ ./Example17.hs
Received: 1
Received: 2
Received: 3
Received: 4
Received: 5
Received: 6
Received: 7
Received: 8
Received: 9
Received: 10
55
-}