{-@ die :: { v:String | false } -> a @-}
die msg = error msg

{-@ lAssert :: { v:Bool | v == true } -> a -> a @-}
lAssert True x = x
lAssert False _ = die "yikes, assertion fails!"

yes = lAssert (1 + 1 == 2) ()
no  = lAssert (1 + 1 == 3) ()