#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

-- 自作Conduitの作成

import Control.Monad (when)
import Data.Conduit (Conduit, ($$), ($=), await, yield)
import qualified Data.Conduit.List as CL

-- | 入力を3つ毎に区切り、そのタプルを送出します。
--   取得できた入力が3つ未満の場合は切り捨てます。
tuple3 :: Monad m => Conduit a m (a, a , a)
tuple3 = do
  xs <- CL.take 3
  case xs of
    [a,b,c] -> yield (a,b,c) >> tuple3
    _ -> return ()

-- | 入力の値が昇順になっている間だけ値を送出します。
ascend :: (Monad m, Ord i) => Conduit i m i
ascend = await >>= maybe (return ()) go
  where
    go i = do
      yield i
      await >>= maybe (return ()) (\j -> when (i <= j) $ go j)

main :: IO ()
main = CL.sourceList (['a' .. 's'] ++ ['a'..'d']) $= ascend $= tuple3 $$ CL.mapM_ print

{-
$ ./Example8.hs
('a','b','c')
('d','e','f')
('g','h','i')
('j','k','l')
('m','n','o')
('p','q','r')
-}