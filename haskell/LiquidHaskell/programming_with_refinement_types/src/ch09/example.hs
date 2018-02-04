import Prelude hiding (replicate, take)

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

{-@ okList :: SListN String 1 @-}
okList :: SList String
okList = SL 1 ["cat"]
-- UNSAFE
-- badList = SL 1 []

{-@ type SListN a N = {v:SList a | size v = N} @-}

{-@ nil :: SListN a 0 @-}
nil = SL 0 []

{-@ cons :: a -> xs:SList a -> SListN a {size xs + 1} @-}
cons x (SL n xs) = SL (n+1) (x:xs)

{-@ die :: { v:String | false } -> a @-}
die = error

{-@ hd :: { xs:SList a | size xs > 0 } -> a @-}
hd :: SList a -> a
hd (SL _ (x:_)) = x
hd _ = die "empty SList"

{-@ tl :: { xs:SList a | size xs > 0 } -> SListN a {size xs - 1} @-}
tl (SL n (_:xs)) = SL (n-1) xs
tl _             = die "empty SList"

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

{-@ okQ :: Queue String @-}
okQ :: Queue String
okQ  = Q okList nil

-- badQ = Q nil okList

{-@ emp :: QueueN _ 0 @-}
emp :: Queue a
emp = Q nil nil

{-@ measure sizeQ @-}
{-@ sizeQ :: Queue a -> Int @-}
sizeQ :: Queue a -> Int
sizeQ (Q f b) = size f + size b

{-@ type QueueN a N = {v:Queue a | sizeQ v = N} @-}

{-@ remove :: { v:Queue a | sizeQ v > 0 } -> (a, QueueN a {sizeQ v - 1}) @-}
remove :: Queue a -> (a, Queue a)
remove (Q f b) = (hd f, makeq (tl f) b)

{-@ okRemove :: Num a => (a, Queue a) @-}
okRemove :: Num a => (a, Queue a)
okRemove = remove example2Q

{-@ example2Q :: QueueN _ 2 @-}
example2Q :: Num a => Queue a
example2Q = Q (1 `cons` (2 `cons` nil)) nil

-- {-@ badRemove :: (a, Queue a) @-}
-- badRemove :: (a, Queue a)
-- badRemove = remove example0Q

{-@ example0Q :: QueueN _ 0 @-}
example0Q :: Queue a
example0Q = Q nil nil

{-@ insert :: a -> q:Queue a -> QueueN a {sizeQ q + 1} @-}
insert :: a -> Queue a -> Queue a
insert e (Q f b) = makeq f (e `cons` b)

{-@ replicate :: n:Nat -> a -> QueueN a n @-}
replicate :: Int -> a -> Queue a
replicate 0 _ = emp
replicate n x = insert x (replicate (n-1) x)

{-@ y3 :: QueueN _ 3 @-}
y3 = replicate 3 "Yeah!"

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

{-@ take :: {n:Int | n >= 0} -> {q:Queue a | sizeQ q >= n} -> (QueueN a n, QueueN a {sizeQ q - n}) @-}
take :: Int -> Queue a -> (Queue a, Queue a)
take 0 q = (emp, q)
take n q = (insert x out, q'')
  where
    (x, q')    = remove q
    (out, q'') = take (n-1) q'

{-@ okTake :: (QueueN String 2, QueueN String 1) @-}
okTake :: (Queue String, Queue String)
okTake = take 2 exampleQ -- accept

-- badTake = take 10 exampleQ -- reject

{-@ exampleQ :: QueueN String 3 @-}
exampleQ :: Queue String
exampleQ = insert "nal" $ insert "bob" $ insert "alice" $ emp