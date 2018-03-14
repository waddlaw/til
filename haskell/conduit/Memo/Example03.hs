#!/usr/bin/env stack
-- stack --resolver lts-10.9 script
{-# LANGUAGE ExtendedDefaultRules #-}

import Conduit

main :: IO ()
main = runConduit $ do
  yieldMany [1..5]   .| printC                -- ConduitT Int Int IO ()
  yieldMany [10..15] .| mapC (*100) .| printC -- ConduitT Int Int IO ()
  yieldMany [20..25] .| printC                -- ConduitT Int o   IO ()