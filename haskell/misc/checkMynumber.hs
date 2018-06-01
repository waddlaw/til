module Main (main) where

type MynumWithErr = Either ErrMsg Mynumber
type ResultWithErr = Either ErrMsg Result

type Mynumber = (N11, ChkDiget)
type N11 = String
type ChkDiget = Int
type ErrMsg = String
type Result = Bool

main :: IO ()
main = do
  ns <- getContents
  mapM_ putStrLn $ map (either id show.chkMynumber.validate.sanitize) $ lines ns
  return ()

chkMynumber :: MynumWithErr -> ResultWithErr
chkMynumber (Right (n, d)) = Right $ calcChkDiget n == d
chkMynumber (Left err) = Left err

--calcChkDiget' :: N11 -> ChkDiget
calcChkDiget' n11 = check $ (sum $ zipWith (*) ps qs) `mod` 11
  where
    ps = map ((- 48).fromEnum) n11 -- char2int 関数と同じ
    qs = [n+1 | n<-[1..6]] ++ [n-5 | n<-[7..11]]
    check e
      | e <= 1 = 0
      | otherwise = 11 - e

calcChkDiget :: N11 -> ChkDiget
calcChkDiget n11 = check $ subExp `mod` 11
  where
    subExp = fst $ foldl go (0,11) n11
    go (acc, n) input = (pn * qn + acc, n-1)
      where
        pn = char2int input
        qn = if n <= 6 then n+1 else n-5
    check e
      | e <= 1 = 0
      | otherwise = 11 - e

validate :: String -> MynumWithErr
validate n
  | length n == 11 = Right (n, calcChkDiget n)
  | length n == 12 = Right $ fork init (char2int.last) n
  | otherwise = Left ("入力の桁数は12桁でお願いします。\n入力桁数：" ++ (show $ length n) ++ "\n入力値：" ++ n )

-- 数字以外を除去
sanitize :: String -> String
sanitize = filter (flip elem "0123456789")

-- Utils
char2int :: Char -> Int
char2int c = read [c]

fork :: (c -> a) -> (c -> b) -> c -> (a, b)
fork f g n = (f n, g n)
