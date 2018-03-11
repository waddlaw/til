#!/usr/bin/env stack
-- stack --resolver lts-10.9 script

import Data.Conduit
import qualified Data.Conduit.List as CL
import Data.Monoid ((<>))

main :: IO ()
main = do
  xs <- CL.sourceList [1..10] <> tapC 2 0 $$ CL.consume
  print xs

tapC :: Monad m => Int -> a -> ConduitT i a m ()
tapC n o = CL.replicate n o
  -- | n < 0 = error "tapC: The n should ge. zero."
  -- | otherwise = do
  --     x <- await
  --     case x of
  --       Nothing -> return ()
  --       Just x' -> yield x' >> tapC n 0

-- tapC :: Monad m => Int -> o -> Conduit a m a
-- tapC n o
--   | n < 0 = error "tapC: The n should ge. zero."
--   | otherwise = CL.haveMore (CL.map id) (return ()) (replicate n o)