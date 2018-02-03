import Prelude hiding (replicate)

{-@ measure realSize @-}
realSize :: [a] -> Int
realSize []     = 0
realSize (_:xs) = 1 + realSize xs

{-@ data SList a = SL
  { size :: Nat
  , elems :: {v:[a] | realSize v = size}
  }
@-}
data SList a = SL
  { size  :: Int
  , elems :: [a]
  }

{-@ type SListN a N = {v:SList a | size v = N} @-}

{-@ nil :: SListN a 0 @-}
nil :: SList a
nil = SL 0 []

{-@ cons :: a -> xs:SList a -> SListN a {size xs + 1} @-}
cons :: a -> SList a -> SList a
cons x (SL n xs) = SL (n+1) (x:xs)

{-@ type SListLE a N = {v:SList a | size v <= N} @-}

{-@
data Queue a = Q
  { front :: SList a
  , back  :: SListLE a (size front)
  }
@-}
data Queue a = Q
  { front :: SList a
  , back  :: SList a
  }

{-@ measure sizeQ @-}
{-@ sizeQ :: Queue a -> Int @-}
sizeQ :: Queue a -> Int
sizeQ (Q f b) = size f + size b

{-@ type QueueN a N = {v:Queue a | sizeQ v = N} @-}

{-@ emp :: QueueN _ 0 @-}
emp :: Queue a
emp = Q nil nil

{-@ insert :: a -> q:Queue a -> QueueN a {sizeQ q + 1} @-}
insert :: a -> Queue a -> Queue a
insert e (Q f b) = makeq f (e `cons` b)

{-@ replicate :: n:Nat -> a -> QueueN a n @-}
replicate :: Int -> a -> Queue a
replicate 0 _ = emp
replicate n x = insert x (replicate (n-1) x)

{-@ y3 :: QueueN _ 3 @-}
y3 :: Queue a
y3 = replicate 3 "Yeah!"

-- {-@ y2 :: QueueN _ 3 @-}
-- y2 = replicate 1 "No!"

makeq = undefined