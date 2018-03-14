#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

main :: IO ()
main = runConduit $ yieldMany [1..10::Int] .| pipe3 .| sinkNull

pipe1 :: ConduitM Int Int IO ()
pipe1 = do
  mapC id .| (await >>= maybe (return ()) leftover)
  printC

pipe2 :: ConduitM Int o IO ()
pipe2 = do
  leftover 99999999
  printC

pipe3 :: ConduitM Int Int IO ()
pipe3 = do
  x <- await
  -- y <- maybe (return ()) leftover x
  -- mapC (+1)
  -- await
  -- liftIO $ print y
  liftIO $ print x
  -- printC

  -- maybe (return ()) yield x

-- pipe4 :: ConduitM Int Int IO ()
-- pipe4 = await >>= maybe (return ()) yield .| printC