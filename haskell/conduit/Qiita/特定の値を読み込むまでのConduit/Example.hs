#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

{-# LANGUAGE OverloadedStrings #-}

import Data.Conduit
import qualified Data.Conduit.Binary as CB
import qualified Data.Conduit.List as CL
import Control.Monad.Trans.Resource

takeWhile' :: Monad m => (a -> Bool) -> Conduit a m a
takeWhile' f = do
  mx <- await
  case mx of
    Nothing -> return ()
    Just x
      | f x -> yield x >> takeWhile' f
      | otherwise -> return ()

main :: IO ()
main = do
  ss <- runResourceT $
          CB.sourceFile "hogehoge.txt"
          $= CB.lines
          $= takeWhile' (/= "END")
          $$ CL.consume
  print ss