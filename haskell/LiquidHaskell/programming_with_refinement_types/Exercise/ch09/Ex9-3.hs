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
{-@ type SListLE a N = {v:SList a | size v <= N} @-}

{-@ die :: { v:String | false } -> a @-}
die = error

{-@ hd :: { xs:SList a | size xs > 0 } -> a @-}
hd :: SList a -> a
hd (SL _ (x:_)) = x
hd _ = die "empty SList"

{-@ tl :: { xs:SList a | size xs > 0 } -> SListN a {size xs - 1} @-}
tl (SL n (_:xs)) = SL (n-1) xs
tl _             = die "empty SList"

{-@ nil :: SListN a 0 @-}
nil = SL 0 []

{-@ cons :: a -> xs:SList a -> SListN a {size xs + 1} @-}
cons :: a -> SList a -> SList a
cons x (SL n xs) = SL (n+1) (x:xs)

{-@ makeq :: f:SList a -> {b:SList a | size b > size f => size b - size f = 1 } -> QueueN a {size f + size b} @-}
makeq :: SList a -> SList a -> Queue a
makeq f b
  | size b <= size f = Q f b
  | otherwise        = Q (rot f b nil) nil

{-@ rot :: f:SList a -> b:SListN a {size f + 1} -> tmp:SList a -> SListN a {size f + size b + size tmp}  / [size f] @-}
rot :: SList a -> SList a -> SList a -> SList a
rot f b a
  | size f == 0 = hd b `cons` a
  | otherwise   = hd f `cons` rot (tl f) (tl b) (hd b `cons` a)

-- 1
{-@ measure sizeQ @-}
{-@ sizeQ :: q:Queue a -> { v:Nat | v = sizeQ q } @-}
sizeQ :: Queue a -> Int
sizeQ (Q f b) = size f + size b

-- 2
{-@ type QueueN a N = {v:Queue a | sizeQ v = N} @-}

-- 3
{-@ remove :: { v:Queue a | sizeQ v > 0 } -> (a, QueueN a {sizeQ v - 1}) @-}
remove :: Queue a -> (a, Queue a)
remove (Q f b) = (hd f, makeq (tl f) b)

{-@ okRemove :: Num a => (a, Queue a) @-}
okRemove :: Num a => (a, Queue a)
okRemove = remove example2Q

{-@ example2Q :: QueueN _ 2 @-}
example2Q :: Num a => Queue a
example2Q = Q (1 `cons` (2 `cons` nil)) nil