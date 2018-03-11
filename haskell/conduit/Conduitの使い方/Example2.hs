#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

-- 複数のSourceの全ての値をリストで取得する

import Data.Conduit (Source, ($$))
import Data.Conduit.List as CL
import Data.Monoid ((<>))

srcA :: Monad m => Source m Int
srcA = CL.sourceList [1..10]

srcB :: Monad m => Source m Int
srcB = CL.sourceList [11..20]

main :: IO ()
main = do
  xs <- srcA <> srcB $$ CL.consume
  print xs

{-
$ ./Example2.hs
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
-}