#!/usr/bin/env stack
{- stack script
   --resolver nightly-2018-04-21
   --package extensible
   --package lens
-}

{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedLabels #-}

module Main where

import Data.Extensible
import Data.Functor.Identity (runIdentity)
import Data.Proxy
import Control.Lens hiding ((:>))

data Person = Person
  { name  :: String
  , age   :: Int
  } deriving Show

deriveIsRecord ''Person

p :: Record (RecFields Person)
p = toRecord $ Person "guchi" 0

main :: IO ()
main = do
  debug p
  debug $ p & #name .~ "bigmoon" & #age .~ 30

debug :: Record (RecFields Person) -> IO ()
debug = hfoldMapFor (Proxy @ (ValueIs Show)) ioDebug

ioDebug :: ValueIs Show kv => Field Identity kv -> IO ()
ioDebug = print . runIdentity . getField

instance Wrapper IO where
  type Repr IO a = IO a
  _Wrapper = id

-- ambiguousDebug :: IsRecord a => Record (RecFields a) -> IO ()
-- ambiguousDebug = hfoldMapFor (Proxy @ (ValueIs Show))ioDebug
