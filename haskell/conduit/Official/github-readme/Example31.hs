#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

myFilterC :: Monad m => (a -> Bool) -> ConduitM a a m ()
myFilterC p =
  loop
    where
      loop = do
        mx <- await
        case mx of
          Nothing -> return ()
          Just x ->
            if p x then
              yield x >> loop
            else
              loop

myMapM_C :: Monad m => (a -> m ()) -> ConduitM a o m ()
myMapM_C f =
  loop
    where
      loop = do
        mx <- await
        case mx of
          Nothing -> return ()
          Just x -> (lift $ f x) >> loop

main :: IO ()
main = runConduit $ yieldMany [1..10] .| myFilterC even .| myMapM_C print