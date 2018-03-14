#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

myPeekC :: Monad m => ConduitM i o m (Maybe i)
myPeekC = do
  mx <- await
  case mx of
    Nothing -> return Nothing
    Just x -> do
      leftover x
      return (Just x)

main :: IO ()
main = print $ runConduitPure $ yieldMany [1 .. 10] .| do
  x <- myPeekC
  y <- myPeekC
  return (x, y)

{-
$ ./Example35.hs
([1,2,3,4,5],[7,8,9,10])
-}
