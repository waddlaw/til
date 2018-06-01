module Sanbika() where

import Data.List
import Data.Function

-- 全て違う数字で作られている
-- 2つめの番号は1つめの番号の倍
-- 3つめの番号は1つめの番号と2つめの番号の和
-- 3つの3桁の数で全て数字が異なるものを探せ

-- (100~333, 200~666, 300~999)
genNumTri :: [(Int, Int, Int)]
genNumTri = [(x, x*2, x+x*2) | x <- [100..333]]

removeDupNum :: [(Int, Int, Int)] -> [(Int, Int, Int)]
removeDupNum [] = []
removeDupNum (a@(x, y, z):ns) =
  if nub s == s then
    a : removeDupNum ns
  else
    removeDupNum ns
  where
    s = show x ++ show y ++ show z

main :: IO ()
main = print $ removeDupNum genNumTri


{-
1731
5363
7179
9903
-}
ans2 = [x | x <- [9903..a], ((x`mod`1731) == (x`mod`5363) && (x`mod`7159) == (x`mod`9903))]
  where
    a = 1731*5363*7179*9903+1

-- 1234 ~ 6789
ans3 = sortBy (\(_,_,x) -> \(_,_,y) ->compare x y) list
  where
    list = [(a,b,a^3+b^3) | a<-[0..100], b<-[a+1..100],a^3+b^3<10000, 999<a^3+b^3]

check n = if ((a^3+b^3)==(c^3+d^3)) then [[a,b,c,d]]   else []
  where
    a = n `div` 1000
    b = (n-a*1000) `div` 100
    c = (n-a*1000-b*100) `div` 10
    d = n `mod` 10
