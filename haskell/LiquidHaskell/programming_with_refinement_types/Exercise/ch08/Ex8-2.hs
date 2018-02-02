import Data.Set (Set, difference, empty, intersection, union)

{-@ type True  = {v:Bool |     v} @-}
{-@ type Implies P Q = {v:_ | v <=> (P => Q)} @-}

{-@ implies :: p:Bool -> q:Bool -> Implies p q @-}
implies :: Bool -> Bool -> Bool
implies False _    = True
implies _     True = True
implies _     _    = False

{-@ prop_cup_dif_bad :: _ -> _ -> True @-}
prop_cup_dif_bad :: (Ord a) => Set a -> Set a -> Bool
prop_cup_dif_bad x y = pre `implies` (x == ((x `union` y) `difference` y))
  where
    pre = empty == intersection x y