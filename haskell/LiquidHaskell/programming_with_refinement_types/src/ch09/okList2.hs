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

{-@ okList2 :: SListN String 2 @-}
okList2 :: SList String
okList2 = SL 2 ["cat", "dog"]

{-@ okQ2 :: Queue String @-}
okQ2 :: Queue String
okQ2 = Q okList2 nil

{-@ measure realSize @-}
realSize :: [a] -> Int
realSize []     = 0
realSize (_:xs) = 1 + realSize xs

{-@ nil :: SListN a 0 @-}
nil = SL 0 []