{-@ type True  = {v:Bool |     v} @-}
{-@ type Implies P Q = {v:_ | v <=> (P => Q)} @-}

{-@ implies :: p:Bool -> q:Bool -> Implies p q @-}
implies :: Bool -> Bool -> Bool
implies False _    = True
implies _     True = True
implies _     _    = False

{-@ prop_x_y_200 :: _ -> _ -> True @-}
prop_x_y_200 x y = (x < 100 && y < 100) `implies` (x + y < 200)