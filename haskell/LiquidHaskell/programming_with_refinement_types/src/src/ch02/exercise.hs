{-@ type TRUE  = { v:Bool | v     } @-}
{-@ type FALSE = { v:Bool | not v } @-}
{-@ (==>) :: p:Bool -> q:Bool -> {v:Bool | v <=> (p ==> q)} @-}
infixr 5 ==>

False ==> False = True
False ==> True = True
True ==> True = True
True ==> False = False

{-@ (<=>) :: p:Bool -> q:Bool -> {v:Bool | v <=> (p <=> q)} @-}
False <=> False = True
False <=> True = False
True <=> True = True
True <=> False = False

{-@ ex2_1 :: Bool -> _ -> TRUE @-}
ex2_1 a b = (a || a) ==> a

{-@ ex2_1' :: Bool -> Bool -> TRUE @-}
ex2_1' a b = a ==> (a || b)

{-@ exDeMorgan2 :: Bool -> Bool -> TRUE @-}
exDeMorgan2 a b = not (a && b) <=> (not a || not b)

{-@ ax6 :: Int -> Int -> TRUE @-}
ax6 :: Int -> Int -> Bool
ax6 x y = (0 <= y) ==> (x <= x + y)
