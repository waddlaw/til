#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

-- 出力可能な値の残っているSourceを再利用する

import Data.Conduit (($$+), ($$++), ($$+-))
import qualified Data.Conduit.List as CL

main :: IO ()
main = do
  (resumableSrc0, xs) <- CL.sourceList [1..25] $$+ CL.take 10
  display xs

  (resumableSrc1, ys) <- resumableSrc0 $$++ CL.take 10
  display ys

  zs <- resumableSrc1 $$+- CL.take 10
  display zs

display :: [Int] -> IO ()
display xs = do
  print xs
  putStrLn "-----"

{-
$ ./Example4.hs
[1,2,3,4,5,6,7,8,9,10]
-----
[11,12,13,14,15,16,17,18,19,20]
-----
[21,22,23,24,25]
-----
-}