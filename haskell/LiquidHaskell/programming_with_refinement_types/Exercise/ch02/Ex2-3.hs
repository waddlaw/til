{-@ type TRUE = { v:Bool | v } @-}

{-@ (==>) :: p:Bool -> q:Bool -> { v:Bool | v <=> (p ==> q) } @-}

False ==> False = True
False ==> True  = True
True  ==> True  = True
True  ==> False = False

{-@ ax6 :: Int -> Int -> TRUE @-}
ax6 :: Int -> Int -> Bool
ax6 x y = (0 <= y) ==> (x <= x + y)