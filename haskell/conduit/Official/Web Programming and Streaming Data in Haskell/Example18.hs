#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

main :: IO ()
main = print
  $ runConduitPure
  $ yieldMany [1..10::Int]
 .| ((,) <$> (takeWhileC (<6) .| sinkList)
         <*> sinkList)

{-
$ ./Example18.hs
([1,2,3,4,5],[6,7,8,9,10])
-}