main=mapM_ print$iterate(\[a,b,c,d,e]->[d+e,d+a,b,e,c] [1,0,0,0,0]

import Data.List
main=mapM_ print$map(sum.map snd)$take 100$iterate(s.concatMap u)[(1,1)]
u (6,n)=[(1,n),(2,n)]
u (8,n)=[(1,n),(6,n)]
u (i,n)=[(i*2,n)]
s = map (foo . unzip) . groupBy (\x y -> fst x == fst y) . sort
   where foo (names, vals) = (head names, sum vals)

   import Data.Array.Unboxed
import Data.List

baibaiman :: Int -> Int -> Int
baibaiman 1 e = 1
baibaiman d e =
  if (e*2)-10>0 then
    baibaiman (d-1) 1 + baibaiman (d-1) ((e*2)-10)
  else
    baibaiman (d-1) (e*2)

main :: IO ()
main = mapM_ (putStrLn.show) $ map f $ take 100 $ iterate (summary.concatMap update) [(1,1)]
  where
    f = sum . map snd
-- main = print $ sum $ map snd  $ last $ take 100 $ iterate (summary.concatMap update) [(1,1)]
-- main =  print $ map length $ take 100 $ iterate baibaiman' [1]
{-
main = print $ map (flip baibaiman 1) [1..10]
-}
{-
1: [1]
2: [2]
3: [4]
4: [8]
5: [16] -> [1,6]
6: [2, 12] -> [2, 1, 2]
7: [4, 2, 4]
8: [8, 4, 8]
9: [16, 8, 16] -> [1, 6, 8, 1, 6]
10: [2, 12, 16, 2, 12] -> [2, 1, 2, 1, 6, 2, 1, 2]
-}

baibaiman' :: [Int] -> [(Int, Int)]
baibaiman' ns = concatMap f ns
  where
    f n = if (n*2)<10 then [(n*2,1),(n,-1)] else [(1,1), (n*2-10,1),(n,-1)]

-- scanl :: (b -> a -> b) -> b -> [a] -> [b]
-- scanl baibaiman'' [1] (repeat 1)


baibaiman'' ns _ = concatMap f ns
  where
    f n = if (n*2)<10 then [(n*2)] else [1, (n*2-10)]

--input :: UArray Int Int
--input = array (1, 8) ((1,1):[(i,0)|i<-[2..8]])


update :: (Integer, Integer) -> [(Integer, Integer)]
update (1, n) = [(2, n)]
update (2, n) = [(4, n)]
update (4, n) = [(8, n)]
update (6, n) = [(1, n), (2, n)]
update (8, n) = [(1, n), (6, n)]

summary :: [(Integer, Integer)] -> [(Integer, Integer)]
summary = map (foo . unzip) . groupBy (\x y -> fst x == fst y) . sort
   where foo (names, vals) = (head names, sum vals)
