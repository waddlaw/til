import Data.Set (Set, singleton, union, empty)

-- | Exercise 10.3 (Empty Maps)
{-@ emp :: { m:Map k v | Set_emp (keys m) } @-}
emp :: Map k v
emp = Tip

{-@
data Map k v = Node
  { key   :: k
  , value :: v
  , left  :: Map { v:k | v < key } v
  , right :: Map { v:k | key < v } v
  }
             | Tip
@-}
data Map k v = Node
  { key   :: k
  , value :: v
  , left  :: Map k v
  , right :: Map k v
  }
             | Tip

{-@ lazy keys @-}
{-@ measure keys @-}
keys :: (Ord k) => Map k v -> Set k
keys Tip = empty
keys (Node k v l r) = ks `union` kl `union` kr
  where
    kl = keys l
    kr = keys r
    ks = singleton k