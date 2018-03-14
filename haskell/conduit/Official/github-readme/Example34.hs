#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

myGoodTakeWhileC :: Monad m => (i -> Bool) -> ConduitM i i m ()
myGoodTakeWhileC f = loop
 where
  loop = do
    mx <- await
    case mx of
      Nothing -> return ()
      Just x
        | f x -> do
          yield x
          loop
        | otherwise -> leftover x

main :: IO ()
main = print $ runConduitPure $ yieldMany [1 .. 10] .| do
  x <- myGoodTakeWhileC (<= 5) .| sinkList
  y <- sinkList
  return (x, y)
