#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

main :: IO ()
main = runConduit $ return () .| undefined .| return ()

{-
$ ./Example09.hs
-}