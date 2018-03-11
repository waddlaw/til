#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Conduit

main :: IO ()
main = do
  -- Create a source file
  writeFile "input.txt" "This is a test."

  runConduitRes $ sourceFile "input.txt"
               .| sinkFile "output.txt"