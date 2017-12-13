{-@ LIQUID "--no-totality" @-}
{-@ data IncList a = Emp
                   | (:<) { hd :: a, tl :: IncList { v:a | hd <= v }}
@-}
data IncList a = Emp
               | (:<) { hd :: a, tl :: IncList a }

merge :: (Ord a) => IncList a -> IncList a -> IncList a
merge Emp Emp = Emp