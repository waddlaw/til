{-@ die :: { v:String | false } -> a @-}
die = error

{-@ measure realSize @-}
realSize :: [a] -> Int
realSize []     = 0
realSize (_:xs) = 1 + realSize xs

{-@
data SList a = SL
  { size  :: Nat
  , elems :: {v:[a] | realSize v = size}
  }
@-}
data SList a = SL
  { size  :: Int
  , elems :: [a]
  }

{-@ type SListN a N = {v:SList a | size v = N} @-}

{-@ okList :: SListN String 1 @-}
okList :: SList String
okList = SL 1 ["cat"]

{-@ hd :: { xs:SList a | size xs > 0 } -> a @-}
hd :: SList a -> a
hd (SL _ (x:_)) = x
hd _ = die "empty SList"

{-@ tl :: { xs:SList a | size xs > 0 } -> SListN a {size xs - 1} @-}
tl (SL n (_:xs)) = SL (n-1) xs
tl _             = die "empty SList"

{-@ okHd :: String @-}
okHd :: String
okHd = hd okList

-- UNSAFE
-- badHd = hd (tl okList)