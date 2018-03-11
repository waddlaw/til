#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

-- Sourceから全ての値をリストで取得する

import Data.Conduit (($$))
import qualified Data.Conduit.List as CL

main :: IO ()
main = do
  xs <- CL.sourceList ['a'..'z'] $$ CL.consume
  putStrLn xs

{-
$ ./Example1.hs
abcdefghijklmnopqrstuvwxyz
-}