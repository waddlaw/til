module Main where

import System.Environment (getArgs)

main :: IO ()
main = do
  [fp] <- getArgs
  putStrLn fp