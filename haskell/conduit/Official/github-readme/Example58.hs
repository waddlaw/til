#!/usr/bin/env stack
-- stack script --resolver lts-11.0
import Conduit

withFiveSum :: Monad m
            => ConduitM Int o m r
            -> ConduitM Int o m (r, Int)
withFiveSum inner = do
    r <- takeExactlyC 5 inner
    s <- sumC
    return (r, s)

main :: IO ()
main = print $ runConduitPure $ yieldMany [1..10] .| withFiveSum (return ())

{-
$ ./Example58.hs
((),40)
-}