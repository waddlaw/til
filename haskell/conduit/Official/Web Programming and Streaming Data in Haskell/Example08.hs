#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

main :: IO ()
main = runConduit $ undefined .| return ()

{-
$ ./Example08.hs
-}