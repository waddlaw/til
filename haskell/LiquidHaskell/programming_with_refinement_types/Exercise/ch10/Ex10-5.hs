import Data.Set (Set, singleton, union, empty)

-- | Exercise 10.5 (Membership Test)
{-@ lazy mem @-}
{-@ mem :: (Ord k) => k:k -> m:Map k v -> { v:_ | v <=> HasKey k m } @-}
mem :: Ord k => k -> Map k v -> Bool
mem k' (Node k _ l r)
  | k' == k   = True
  | k' < k    = assert (lemma_notMem k' r) $ mem k' l
  | otherwise = assert (lemma_notMem k' l) $ mem k' r
mem _ Tip = False

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

{-@ predicate In X Xs      = Set_mem X Xs  @-}
{-@ predicate HasKey K M   = In K (keys M) @-}

{-@ lazy lemma_notMem @-}
{-@ lemma_notMem :: Ord k => key:k -> m:Map { k:k | k /= key } v -> { v:Bool | not (HasKey key m) } @-}
lemma_notMem :: Ord k => k -> Map k v -> Bool
lemma_notMem _ Tip = True
lemma_notMem key (Node _ _ l r) = lemma_notMem key l && lemma_notMem key r

assert :: a -> b -> b
assert _ x = x