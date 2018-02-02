{-@ measure notEmpty @-}
notEmpty :: [a] -> Bool
notEmpty [] = False
notEmpty (_:_) = True

{-@ type NEList a = { v:[a] | notEmpty v} @-}
{-@ type Pos = { v:Int | v > 0 } @-}

{-@ size1 :: xs:NEList a -> Pos @-}
size1 :: [a] -> Int
size1 [] = 0
size1 (_:xs) = 1 + size1 xs

{-@ size2 :: xs:[a] -> { v:Int | notEmpty xs => v > 0} @-}
size2 :: [a] -> Int
size2 [] = 0
size2 (_:xs) = 1 + size2 xs