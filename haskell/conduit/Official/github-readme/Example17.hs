#!/usr/bin/env stack
-- stack script --resolver lts-10.9
{-# LANGUAGE ExtendedDefaultRules #-}
import Conduit

main :: IO ()
main =
    runConduit
        $  yieldMany (map (replicate 5) [1 .. 10])
        .| concatC
        .| mapM_C print

{-
$ ./Example17.hs
1
1
1
1
1
2
2
2
2
2
3
3
3
3
3
4
4
4
4
4
5
5
5
5
5
6
6
6
6
6
7
7
7
7
7
8
8
8
8
8
9
9
9
9
9
10
10
10
10
10
-}