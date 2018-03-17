#!/usr/bin/env stack
-- stack script --resolver lts-11.0
import Conduit

fibs :: [Int]
fibs = 0 : 1 : zipWith (+) fibs (drop 1 fibs)

indexedFibs :: ConduitM () (Int, Int) IO ()
indexedFibs = getZipSource
    $ (,)
  <$> ZipSource (yieldMany [1..])
  <*> ZipSource (yieldMany fibs)

main :: IO ()
main = runConduit $ indexedFibs .| takeC 10 .| mapM_C print

{-
$ ./Example54.hs
(1,0)
(2,1)
(3,1)
(4,2)
(5,3)
(6,5)
(7,8)
(8,13)
(9,21)
(10,34)
-}