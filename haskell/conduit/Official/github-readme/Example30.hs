#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

myMapC :: Monad m => (i -> o) -> ConduitM i o m ()
myMapC f =
    loop
  where
    loop = do
        mx <- await
        case mx of
            Nothing -> return ()
            Just x -> do
                yield (f x)
                loop

main :: IO ()
main = runConduit $ yieldMany [1..10] .| myMapC (+ 1) .| mapM_C print

{-
$ ./Example30.hs
2
3
4
5
6
7
8
9
10
11
-}