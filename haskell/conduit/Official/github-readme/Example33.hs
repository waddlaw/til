#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

myTakeWhileC :: Monad m => (i -> Bool) -> ConduitM i i m ()
myTakeWhileC f = loop
 where
  loop = do
    mx <- await
    case mx of
      Nothing -> return ()
      Just x
        | f x -> do
          yield x
          loop
        | otherwise -> return ()

main :: IO ()
main = print $ runConduitPure $ yieldMany [1 .. 10] .| do
  x <- myTakeWhileC (<= 5) .| sinkList
  y <- sinkList
  return (x, y)

{-
$ ./Example33.hs
([1,2,3,4,5],[7,8,9,10])
-}
