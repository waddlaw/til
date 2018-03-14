#!/usr/bin/env stack
-- stack script --resolver lts-10.9

magic :: Int -> IO Int
magic x = do
    putStrLn $ "I'm doing magic with " ++ show x
    return $ x * 2

main :: IO ()
main = do
    let go []       = return ()
        go (x : xs) = do
            y <- magic x
            if y < 18
                then do
                    print y
                    go xs
                else return ()

    go $ take 10 [1 ..]

{-
$ ./Example06.hs
I'm doing magic with 1
2
I'm doing magic with 2
4
I'm doing magic with 3
6
I'm doing magic with 4
8
I'm doing magic with 5
10
I'm doing magic with 6
12
I'm doing magic with 7
14
I'm doing magic with 8
16
I'm doing magic with 9
-}
