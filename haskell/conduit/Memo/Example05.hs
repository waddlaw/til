#!/usr/bin/env stack
-- stack --resolver lts-10.9 script
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = runConduit
  $ yieldMany [1..3::Int]
--  .| pipeLeftover .| mapC (*100) .| pipe2 .| mapC (*1000) .| pipe2
 .| pipeYield .| mapC (*100) .| pipe2 .| mapC (*1000) .| pipe2

pipeYield :: ConduitM Int Int IO ()
pipeYield = do
  x <- await
  maybe (return ()) yield x

pipeLeftover :: ConduitM Int Int IO ()
pipeLeftover = do
  x <- await
  maybe (return ()) leftover x

pipe2 :: ConduitM Int o IO ()
pipe2 = do
  x <- await
  liftIO $ print x