module ArrowConduit () where

import Control.Category (Category(..))
import Prelude (undefined)

{-
data Pipe l i o u m r =
    HaveOutput (Pipe l i o u m r) (m ()) o
  | NeedInput (i -> Pipe l i o u m r) (u -> Pipe l i o u m r)
  | Done r
  | PipeM (m (Pipe l i o u m r))
  | Leftover (Pipe l i o u m r) l
-}

data Pipe i o = Pipe (i -> (Pipe i o, o))

{-
class Category cat where
  id :: cat a a
  (.) :: (cat b c) -> (cat a b) -> (cat a c)
-}
instance Category Pipe where
  id = Pipe $ \a ->(id, a)
  (Pipe i2 o2) . (Pipe i1 o1) = Pipe i1 o2
