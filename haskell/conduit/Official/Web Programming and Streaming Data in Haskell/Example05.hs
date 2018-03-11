#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

{-# LANGUAGE ExplicitForAll #-}

import Conduit

loudYield :: forall i. Int -> ConduitM i Int IO ()
loudYield x = do
  liftIO $ putStrLn $ "yielding: " ++ show x
  yield x

loudSinkNull :: forall o. ConduitM Int o IO ()
loudSinkNull =
  loop
  where
    loop = do
      liftIO $ putStrLn "calling await"
      mx <- await
      case mx of
        Nothing -> liftIO $ putStrLn "all done!"
        Just x -> do
          liftIO $ putStrLn $ "received: " ++ show x
          loop

main :: IO ()
main =
  runConduit $ mapM_ loudYield [1..3]
            .| loudSinkNull

{-
$ ./Example05.hs
calling await
yielding: 1
received: 1
calling await
yielding: 2
received: 2
calling await
yielding: 3
received: 3
calling await
all done!
-}