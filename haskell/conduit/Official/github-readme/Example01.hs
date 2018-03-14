#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

-- Synopsis

import Conduit

main :: IO ()
main = do
  print $ runConduitPure $ yieldMany [1 .. 10] .| sumC

  writeFile "input.txt" "This is a test."
  runConduitRes $ sourceFileBS "input.txt" .| sinkFile "output.txt"
  readFile "output.txt" >>= putStrLn

  print $ runConduitPure $ yieldMany [1 .. 10] .| mapC (+ 1) .| sinkList

{-
$ ./Example01.hs
55
This is a test.
[2,3,4,5,6,7,8,9,10,11]
-}
