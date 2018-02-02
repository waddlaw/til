import Prelude hiding (head, null)

{-@ die :: {v:_ | false} -> a @-}
die msg = error msg

{-@ measure notEmpty @-}
notEmpty :: [a] -> Bool
notEmpty [] = False
notEmpty (_:_) = True

{-@ type NEList a = { v:[a] | notEmpty v} @-}

{-@ head :: NEList a -> a @-}
head :: [a] -> a
head [] = die "Fear not! 'twill ne'er come to pass"
head (x:_) = x

{-@ null :: xs:[a] -> { v:Bool | notEmpty xs <=> not v } @-}
null :: [a] -> Bool
null [] = True
null (_:_) = False

safeHead :: [a] -> Maybe a
safeHead xs
  | null xs = Nothing
  | otherwise = Just $ head xs