#!/usr/bin/env stack
{- stack script
   --resolver nightly-2018-04-21
   --package extensible
-}

{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}

module Main where

import Data.Extensible
import Data.Functor.Identity (runIdentity)

data Person = Person
  { name  :: String
  , age   :: Int
  } deriving Show

deriveIsRecord ''Person

main :: IO ()
main = do
  print p
  print $ hmap id2fp p

p :: Record (RecFields Person)
p = toRecord $ Person "guchi" 0

id2fp :: Field Identity kv -> Field ((->) String) kv
id2fp = Field . (error "test") . runIdentity . getField

instance Wrapper ((->) a) where
  type Repr ((->) a) b = a -> b
  _Wrapper = id

instance Show (String -> String) where
  show _ = "func: String -> String"

instance Show (String -> Int) where
  show _ = "func: String -> Int"
