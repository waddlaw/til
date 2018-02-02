import Prelude hiding (head, null)

{-@ measure notEmpty @-}
notEmpty :: [a] -> Bool
notEmpty [] = False
notEmpty (_:_) = True

{-@ type NEList a = { v:[a] | notEmpty v} @-}

{-@ head :: NEList a -> Maybe a @-}
head :: [a] -> Maybe a
head [] = Nothing
head (x:_) = Just x

{-@ null :: xs:[a] -> { v:Bool | notEmpty xs <=> not v } @-}
null :: [a] -> Bool
null [] = True
null (_:_) = False

safeHead :: [a] -> Maybe a
safeHead xs
  | null xs = Nothing
  | otherwise = head xs