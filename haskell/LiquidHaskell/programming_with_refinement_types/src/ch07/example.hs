import Prelude hiding (map)

data Vector a = V { vDim :: Int
                  , vElts :: [a]
                  }
                  deriving Eq

data Matrix a = M { mRow :: Int
                  , mCol :: Int
                  , mElts :: Vector (Vector a)
                  }
                  deriving Eq

dotProd :: (Num a) => Vector a -> Vector a -> a
dotProd vx vy = sum (prod xs ys)
  where
    prod = zipWith (\x y -> x * y)
    xs = vElts vx
    ys = vElts vy

matProd :: (Num a) => Matrix a -> Matrix a -> Matrix a
matProd (M rx _ xs) (M _ cy ys) = M rx cy elts
  where
    elts = for xs $ \xi ->
             for ys $ \yj ->
               dotProd xi yj

for :: Vector a -> (a -> b) -> Vector b
for (V n xs) f = V n (map f xs)

{-@ measure size @-}
{-@ size :: xs:[a] -> { v:Nat | v = size xs } @-}
size :: [a] -> Int
size [] = 0
size (_:rs) = 1 + size rs

{-@ measure notEmpty @-}
notEmpty :: [a] -> Bool
notEmpty [] = False
notEmpty (_:_) = True

type List a = [a]

{-@ type ListN a N = { v:List a | size v = N} @-}
{-@ type ListX a X = ListN a { size X } @-}

-- | Exercise 6.1 (Map)
{-@ map :: (a -> b) -> xs:List a -> List b @-}
map _ [] = []
map f (x:xs) = f x : map f xs

{-@ type TRUE = {v:Bool |     v} @-}

-- {-@ prop_map :: List a -> TRUE @-}
-- prop_map xs = size ys == size xs
--   where
--     ys = map id xs

{-@ reverse :: xs:List a -> ListX a xs @-}
reverse :: [a] -> [a]
reverse xs = go [] xs
  where
    {-@ go :: xs:List a -> ys:List a -> ListN a {size xs + size ys} @-}
    {-@ decrease go 2 @-}
    go acc [] = acc
    go acc (x:xs) = go (x:acc) xs

