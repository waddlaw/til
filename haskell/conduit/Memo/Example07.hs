#!/usr/bin/env stack
-- stack script --resolver lts-11.0
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

trans :: Monad m => ConduitM Int Int m ()
trans = do
    -- takeC 5 .| mapC (+ 1)
    -- mapC (* 2)
    yieldMany $ map (+ 1) $ take 5 [1..10]
    yieldMany $ map (* 2) $ drop 5 [1..10]

main :: IO ()
main = runConduit $ return () .| trans .| mapM_C print