#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

-- 自作Sourceを作成する

import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Conduit (Source, ($$), yield)
import qualified Data.Conduit.List as CL

mySrc :: (Monad m, MonadIO m) => Source m String
mySrc = do
  x <- liftIO $ getLine
  if x == "END"
    then return ()
    else yield x >> mySrc

main :: IO ()
main = mySrc $$ CL.mapM_ putStrLn

{-
$ ./Example3.hs
aaa
aaa
b
b
END
-}