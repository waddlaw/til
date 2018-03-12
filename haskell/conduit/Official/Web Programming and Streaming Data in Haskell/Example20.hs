#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

myTakeWhileC :: Monad m => (i -> Bool) -> ConduitM i i m ()
myTakeWhileC f = loop
  where
    loop = do
      mx <- await
      case mx of
        Nothing -> return ()
        Just x
          | f x -> yield x >> loop
          | otherwise -> leftover x

main :: IO ()
main = print
  $ runConduitPure
  $ yieldMany [1..10::Int]
 .| ((,) <$> (myTakeWhileC (<6) .| sinkList)
         <*> sinkList)

{-
$ ./Example20.hs
([1,2,3,4,5],[6,7,8,9,10])
-}