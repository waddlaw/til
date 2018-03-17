#!/usr/bin/env stack
-- stack script --resolver lts-11.0
import Conduit

tagger :: Monad m => ConduitM Int (Either Int Int) m ()
tagger = mapC $ \i -> if even i then Left i else Right i

evens, odds :: Monad m => ConduitM Int String m ()
evens  = mapC $ \i -> "Even number: " ++ show i
odds   = mapC $ \i -> "Odd  number: " ++ show i

left :: Either l r -> Maybe l
left = either Just (const Nothing)

right :: Either l r -> Maybe r
right = either (const Nothing) Just

inside :: Monad m => ConduitM (Either Int Int) String m ()
inside = getZipConduit
    $ ZipConduit (concatMapC left  .| evens)
   *> ZipConduit (concatMapC right .| odds)

main :: IO ()
main = runConduit $ enumFromToC 1 10 .| tagger .| inside .| mapM_C putStrLn

{-
$ ./Example55.hs
Odd  number: 1
Even number: 2
Odd  number: 3
Even number: 4
Odd  number: 5
Even number: 6
Odd  number: 7
Even number: 8
Odd  number: 9
Even number: 10
-}