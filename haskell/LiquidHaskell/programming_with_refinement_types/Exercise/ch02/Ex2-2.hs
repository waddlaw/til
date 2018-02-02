{-@ type TRUE = { v:Bool | v } @-}

{-@ (<=>) :: p:Bool -> q:Bool -> {v:Bool | v <=> (p <=> q) } @-}
False <=> False = True
False <=> True  = False
True  <=> True  = True
True  <=> False = False

{-@ exDeMorgan2 :: Bool -> Bool -> TRUE @-}
exDeMorgan2 a b = not (a && b) <=> (not a || not b)