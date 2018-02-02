{-@ type TRUE = { v:Bool | v } @-}

{-@ (==>) :: p:Bool -> q:Bool -> { v:Bool | v <=> (p ==> q) } @-}

False ==> False = True
False ==> True  = True
True  ==> True  = True
True  ==> False = False

{-@ ex3' :: Bool -> Bool -> TRUE @-}
ex3' a b = a ==> (b || a)