#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = runConduit $ yieldMany [1..10] .| printOneC

printOneC :: (MonadIO m, Show i) => ConduitM i o m ()
printOneC = do
  mx <- await
  case mx of
    Nothing -> return ()
    Just x -> do
      liftIO $ print x
      return ()