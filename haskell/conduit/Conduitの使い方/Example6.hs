#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

-- 自作Sinkを作成する
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Conduit (Sink, ($$), await)
import qualified Data.Conduit.List as CL

-- | 入力を標準出力へ出力し、受け取った値の総数を返します。3の倍数でアホになります。
mySink :: (Monad m, MonadIO m) => Sink Int m Int
mySink = go 0
  where
    go l = do
      n <- await
      case n of
        Nothing -> return l
        Just n' -> do
          if n' `mod` 3 == 0
            then liftIO $ putStrLn "(^q^)"
            else liftIO $ print n'
          go $ l + 1

main :: IO ()
main = (CL.sourceList [1..30] $$ mySink) >>= print

{-
$ ./Example6.hs
1
2
(^q^)
4
5
(^q^)
7
8
(^q^)
10
11
(^q^)
13
14
(^q^)
16
17
(^q^)
19
20
(^q^)
22
23
(^q^)
25
26
(^q^)
28
29
(^q^)
30
-}