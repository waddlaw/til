#!/usr/bin/env stack
-- stack script --resolver nightly-2018-04-21 --package extensible

{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}

module Main where

import Data.Extensible
import Data.Proxy
import GHC.TypeLits (KnownSymbol, symbolVal)

keys :: Forall (KeyIs KnownSymbol) xs => proxy xs -> [String]
keys xs = henumerateFor (Proxy @ (KeyIs KnownSymbol)) xs
  ((:) . symbolVal . proxyAssocKey) []

data Person = Person
  { name  :: String
  , age   :: Int
  } deriving Show

deriveIsRecord ''Person

type PersonRecord = Record '["name" ':> String, "age" ':> Int]

p1 :: PersonRecord
p1 = toRecord $ Person "guchi" 0

main :: IO ()
main = print $ keys p1
