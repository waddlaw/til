#!/usr/bin/env stack
-- stack script --resolver nightly-2018-04-21 --package extensible -- keys.hs

{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE PolyKinds #-}

module Main where

import Data.Extensible
import Data.Functor.Identity (runIdentity)
import Data.Proxy
import GHC.TypeLits (KnownSymbol, symbolVal)

values :: Forall (ValueIs Show) xs => Record xs -> [String]
values = hfoldrWithIndexFor (Proxy @ (ValueIs Show))
  (const $ (:) . show . runIdentity . getField) []

data Person = Person
  { name  :: String
  , age   :: Int
  } deriving Show

deriveIsRecord ''Person

type PersonRecord = Record '["name" ':> String, "age" ':> Int]

p1 :: PersonRecord
p1 = toRecord $ Person "guchi" 0

main :: IO ()
main = print $ values p1
