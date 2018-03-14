#!/usr/bin/env stack
-- stack --resolver lts-10.9 script
{-# LANGUAGE ExtendedDefaultRules #-}

import Conduit

main :: IO ()
main = runConduit $ yieldMany [1..5] .| mapC (*100) .| printC