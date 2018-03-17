#!/usr/bin/env stack
-- stack --resolver lts-10.9 script
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main = runConduit
  $ yieldMany [1..3::Int]
 .| do
      -- mapC (*100) .| pipeLeftover .| pipe2
      pipeLeftover .| pipe2
      -- pipeYield .| pipe2
      -- printC

pipeYield :: ConduitM Int Int IO ()
pipeYield = do
  mx <- await
  maybe (return ()) yield mx

pipeLeftover :: ConduitM Int Int IO ()
pipeLeftover = do
  mx <- await
  maybe (return ()) leftover mx

pipe2 :: ConduitM Int o IO ()
pipe2 = do
  mx <- await
  liftIO $ print mx