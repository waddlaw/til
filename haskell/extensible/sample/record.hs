#!/usr/bin/env stack
{- stack script
   --resolver nightly-2018-04-21
   --package extensible
-}

{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TemplateHaskell #-}

module Main where

import Data.Extensible

data Person = Person
  { name  :: String
  , age   :: Int
  } deriving Show

deriveIsRecord ''Person

p :: Record (RecFields Person)
p = toRecord $ Person "guchi" 0

main :: IO ()
main = print $ (fromRecord p :: Person)
