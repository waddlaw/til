#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

{-# LANGUAGE ExplicitForAll #-}

import Conduit

loudYield :: forall i. Int -> ConduitM i Int IO ()
loudYield x = do
  liftIO $ putStrLn $ "yielding: " ++ show x
  yield x

loudSinkNull :: forall o. ConduitM Int o IO ()
loudSinkNull = mapM_C $ \x -> putStrLn $ "awaited: " ++ show x

main :: IO ()
main =
  runConduit $ mapM_ loudYield [1..3]
            .| loudSinkNull

{-
$ ./Example04.hs
yielding: 1
awaited: 1
yielding: 2
awaited: 2
yielding: 3
awaited: 3
-}