#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

-- Sinkに流れてきた値を全て出力する
import Data.Conduit (($$))
import qualified Data.Conduit.List as CL

main :: IO ()
main = CL.sourceList ['a' .. 'z'] $$ CL.mapM_ print

{-
$ ./Example5.hs
'a'
'b'
'c'
'd'
'e'
'f'
'g'
'h'
'i'
'j'
'k'
'l'
'm'
'n'
'o'
'p'
'q'
'r'
's'
't'
'u'
'v'
'w'
'x'
'y'
'z'
-}