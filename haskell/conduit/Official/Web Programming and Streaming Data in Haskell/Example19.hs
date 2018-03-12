#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

-- wrong example

myTakeWhileC :: Monad m => (i -> Bool) -> ConduitM i i m ()
myTakeWhileC f = loop
  where
    loop = do
      mx <- await
      case mx of
        Nothing -> return ()
        Just x
          | f x -> yield x >> loop
          | otherwise -> return ()

main :: IO ()
main = print
  $ runConduitPure
  $ yieldMany [1..10::Int]
 .| ((,) <$> (myTakeWhileC (<6) .| sinkList)
         <*> sinkList)

{-
$ ./Example19.hs
([1,2,3,4,5],[7,8,9,10])
-}