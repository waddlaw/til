#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = do
  -- prints: Just 1
  print $ runConduitPure $ yield 1 .| await
  -- prints: Nothing
  print $ runConduitPure $ yieldMany [] .| await

  -- Note, that the above is equivalent to the following. Work out
  -- why this works:
  print $ runConduitPure $ return () .| await
  print $ runConduitPure await