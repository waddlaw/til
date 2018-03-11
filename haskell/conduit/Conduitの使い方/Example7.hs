#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

-- Conduitで流れているデータを加工する

import Data.Char (toUpper, toLower)
import Data.Conduit (($$), ($=), (=$), (=$=))
import qualified Data.Conduit.List as CL

main :: IO ()
main = do
  CL.sourceList ['a' .. 'z'] $= CL.map toUpper $$ CL.mapM_ print
  CL.sourceList ['A' .. 'Z'] $$ CL.map toLower =$ CL.mapM_ print
  CL.sourceList ['a' .. 'z'] $= CL.map toUpper =$= CL.map fromEnum $$ CL.mapM_ print

{-
$ ./Example7.hs
'A'
'B'
'C'
'D'
'E'
'F'
'G'
'H'
'I'
'J'
'K'
'L'
'M'
'N'
'O'
'P'
'Q'
'R'
'S'
'T'
'U'
'V'
'W'
'X'
'Y'
'Z'
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
65
66
67
68
69
70
71
72
73
74
75
76
77
78
79
80
81
82
83
84
85
86
87
88
89
90
-}