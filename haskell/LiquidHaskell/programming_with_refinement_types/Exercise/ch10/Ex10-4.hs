import Data.Set (Set, singleton, union, empty)

-- | Exercise 10.4 (Insert)
{-@ predicate AddKey K M N = keys N = Set_cup (Set_sng K) (keys M) @-}

{-@ lazy set @-}
{-@ set :: Ord k => k:k -> v:v -> m:Map k v -> { n:Map k v | AddKey k m n } @-}
set :: Ord k => k -> v -> Map k v -> Map k v
set k' v' (Node k v l r)
  | k' == k   = Node k v' l r
  | k' < k    = Node k v (set k' v' l) r
  | otherwise = Node k v l (set k' v' r)
set k' v' Tip = Node k' v' emp emp

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

-- | Exercise 10.3 (Empty Maps)
{-@ emp :: { m:Map k v | Set_emp (keys m) } @-}
emp :: Map k v
emp = Tip