#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = runConduit $ yieldMany' [1,2].| mapM_C print

yieldMany' :: Monad m => [o] -> ConduitM i o m ()
yieldMany' = mapM_ yield

{-
$ ./Example28.hs
1
2
-}