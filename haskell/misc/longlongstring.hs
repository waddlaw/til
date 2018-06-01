import Data.List (genericLength)

f :: Integer -> Integer
f n = genericLength $ show $ n^n

g :: Integer -> Integer
g m =
  if null res2 then
    -1
  else if m == head res2 then
    n
  else
    -1
  where
    (res1, res2) = span (<m) $ map f [1..]
    n = genericLength res1 + 1
