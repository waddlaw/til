{-@ LIQUID "--diff" @-}
import           Data.ByteString.Internal (c2w, w2c)
import           Data.Word                (Word8)
import           Foreign.ForeignPtr       (ForeignPtr, mallocForeignPtrBytes,
                                           withForeignPtr)
import           Foreign.Ptr              (Ptr, plusPtr)
import           Foreign.Storable         (Storable, peek, poke)
import           System.IO                (stdout, hPutBuf)
import           System.IO.Unsafe         (unsafePerformIO)

-- chop' :: String -> Int -> String
-- chop' s n = s'
--  where
--   b  = pack s
--   b' = unsafeTake n b
--   s' = unpack b'

zero4 :: IO (ForeignPtr a)
zero4 = do
  fp <- mallocForeignPtrBytes 4
  withForeignPtr fp $ \p -> do
    poke (p `plusPtr` 0) zero
    poke (p `plusPtr` 1) zero
    poke (p `plusPtr` 2) zero
    poke (p `plusPtr` 3) zero
  return fp
  where zero = 0 :: Word8

{- UNSAFE
zero4' :: IO (ForeignPtr a)
zero4' = do
  fp <- mallocForeignPtrBytes 4
  withForeignPtr fp $ \p -> do
    poke (p `plusPtr` 0) zero
    poke (p `plusPtr` 1) zero
    poke (p `plusPtr` 2) zero
    poke (p `plusPtr` 8) zero
  return fp
  where zero = 0 :: Word8
-}

-- | 定義済み
-- {-@ measure plen :: Ptr a -> Int @-}
-- {-@ measure fplen :: ForeignPtr a -> Int @-}
-- {-@ type PtrN a N = { v:Ptr a | plen v = N } @-}
-- {-@ type ForeignPtrN a N = { v:ForeignPtr a | fplen v = N } @-}
-- {-@ withForeignPtr :: fp:ForeignPtr a -> (PtrN a (fplen fp) -> IO b) -> IO b @-}

{-@ mallocForeignPtrBytes :: n:Nat -> IO (ForeignPtrN a n) @-}

zero3 :: IO (ForeignPtr a)
zero3 = do
  fp <- mallocForeignPtrBytes 4
  withForeignPtr fp $ \p -> do
    poke (p `plusPtr` 0) zero
    poke (p `plusPtr` 1) zero
    poke (p `plusPtr` 2) zero
  return fp
  where zero = 0 :: Word8

-- | 定義済み
-- {-@ type OkPtr a = {v:Ptr a | 0 < plen v} @-}
-- {-@ peek :: OkPtr a -> IO a @-}
-- {-@ poke :: OkPtr a -> a -> IO () @-}
-- {-@ plusPtr :: p:Ptr a -> off:BNat (plen p) -> PtrN b {plen p - off} @-}
-- {-@ type BNat N = {v:Nat | v <= N} @-}

{- UNSAFE
exBad :: IO (ForeignPtr a)
exBad = do
  fp <- mallocForeignPtrBytes 4
  withForeignPtr fp $ \p -> do
    poke (p `plusPtr` 0) zero
    poke (p `plusPtr` 1) zero
    poke (p `plusPtr` 2) zero
    poke (p `plusPtr` 5) zero
  return fp
  where zero = 0 :: Word8
-}

{-@
data ByteString = BS
  { bPtr :: ForeignPtr Word8
  , bOff :: {v:Nat | v        <= fplen bPtr}
  , bLen :: {v:Nat | v + bOff <= fplen bPtr}
  }
@-}
data ByteString = BS
  { bPtr :: ForeignPtr Word8
  , bOff :: !Int
  , bLen :: !Int
  }

{-@ type ByteStringN N = {v:ByteString | bLen v = N} @-}

{-@ good1 :: IO (ByteStringN 5) @-}
good1 :: IO ByteString
good1 = do
  fp <- mallocForeignPtrBytes 5
  return (BS fp 0 5)

{-@ good2 :: IO (ByteStringN 2) @-}
good2 :: IO ByteString
good2 = do
  fp <- mallocForeignPtrBytes 5
  return (BS fp 3 2)

{- UNSAFE
bad1 :: IO ByteString
bad1 = do
  fp <- mallocForeignPtrBytes 3
  return (BS fp 0 10)
-}

{- UNSAFE
bad2 :: IO ByteString
bad2 = do
  fp <- mallocForeignPtrBytes 3
  return (BS fp 2 2)
-}

-- | Ex 11.1 (Legal ByteStrings)
{-@ bad1 :: IO (ByteStringN 10) @-}
bad1 :: IO ByteString
bad1 = do
  fp <- mallocForeignPtrBytes 10
  return (BS fp 0 10)

{-@ bad2 :: IO (ByteStringN 2) @-}
bad2 :: IO ByteString
bad2 = do
  fp <- mallocForeignPtrBytes 4
  return (BS fp 2 2)

{-@ create :: n:Nat -> (PtrN Word8 n -> IO ()) -> ByteStringN n @-}
create :: Int -> (Ptr Word8 -> IO ()) -> ByteString
create n fill = unsafePerformIO $ do
  fp <- mallocForeignPtrBytes n
  withForeignPtr fp fill
  return (BS fp 0 n)

-- | Ex 11.2 (Create)
{-@ bsGHC :: ByteStringN 3 @-}
bsGHC :: ByteString
bsGHC = create 3 $ \p -> do
  poke (p `plusPtr` 0) (c2w 'G')
  poke (p `plusPtr` 1) (c2w 'H')
  poke (p `plusPtr` 2) (c2w 'C')

-- | Ex 11.3 (Pack)
{-@ pack :: v:String -> ByteStringN (len v) @-}
pack :: String -> ByteString
pack str = create n $ \p -> go p xs
 where
  n  = length str
  xs = map c2w str
  go _ []     = return ()
  go p (x:xs) = poke p x >> go (p `plusPtr` 1) xs

{-@ type TRUE = { v:Bool | true } @-}

{-@ prop_pack_length :: String -> TRUE @-}
prop_pack_length :: String -> Bool
prop_pack_length xs = bLen (pack xs) == length xs

-- | Ex 11.4 (Pack Invariant)
packEx :: String -> ByteString
packEx str = create n $ \p -> pLoop p xs
 where
  n  = length str
  xs = map c2w str

{-@ pLoop :: (Storable a) => p:Ptr a -> { xs:[a] | len xs == plen p }  -> IO () @-}
pLoop :: (Storable a) => Ptr a -> [a] -> IO ()
pLoop _ []     = return ()
pLoop p (x:xs) = poke p x >> pLoop (p `plusPtr` 1) xs

-- | Ex 11.5 (Unsafe Take and Drop)
{-@ unsafeTake :: n:Nat -> {v:ByteString | n <= bLen v } -> ByteStringN n @-}
unsafeTake :: Int -> ByteString -> ByteString
unsafeTake n (BS x s _) = BS x s n

{-@ unsafeDrop :: n:Nat -> b:{v:ByteString | n <= bLen v } -> ByteStringN {bLen b - n} @-}
unsafeDrop :: Int -> ByteString -> ByteString
unsafeDrop n (BS x s l) = BS x (s + n) (l - n)

-- | Ex 11.6 (Unpack) *

{-@ type OkPtr a = {v:Ptr a | 0 < plen v} @-}

{-@ unpack :: b:ByteString -> { v:String | bLen b == len v } @-}
unpack :: ByteString -> String
unpack (BS _ _ 0) = []
unpack (BS ps s l) =
  unsafePerformIO $ withForeignPtr ps $ \p -> go (p `plusPtr` s) (l - 1) []
  where
    {-@ go :: p:OkPtr a -> n:{v:Nat | v < plen p} -> acc:_ -> IO { v:_ | len v = n + len acc + 1 } @-}
    go p 0 acc = peekAt p 0 >>= \e -> return (w2c e : acc)
    go p n acc = peekAt p n >>= \e -> go p (n-1) (w2c e : acc)
    peekAt p n = peek (p `plusPtr` n)

{-@ prop_unpack_length :: ByteString -> TRUE @-}
prop_unpack_length :: ByteString -> Bool
prop_unpack_length b = bLen b == length (unpack b)

-- unpack' :: ByteString -> String
-- unpack' (BS _ _ 0) = []
-- unpack' (BS ps s l) =
--   unsafePerformIO $ withForeignPtr ps $ \p -> go (p `plusPtr` s) l []
--   where
--     {-@ go :: p:_ -> n:_ -> acc:_ -> IO {v:_ | true } @-}
--     go p n acc
--       | n
--     go p 0 acc = peekAt p 0 >>= \e -> return (w2c e : acc)
--     go p n acc = peekAt p n >>= \e -> go p (n-1) (w2c e : acc)
--     peekAt p n = peek (p `plusPtr` n)

{-@ chop :: s:String -> n:BNat (len s) -> String @-}
chop :: String -> Int -> String
chop s n = s'
  where
    b = pack s
    b' = unsafeTake n b
    s' = unpack b'

{- UNSAFE
demo :: [String]
demo = [ex6, ex30]
  where
    ex = "LIQUID"
    ex6 = chop ex 6
    ex30 = chop ex 30
-}

{-@ prop_chop_length :: String -> Nat -> TRUE @-}
prop_chop_length :: String -> Int -> Bool
prop_chop_length s n
  | n <= length s = length (chop s n) == n
  | otherwise = True

-- | Ex 11.7 (Checked Chop)
safeChop :: String -> Int -> String
safeChop str n
  | ok = chop str n
  | otherwise = ""
  where
    ok = length str >= n && n > 0

queryAndChop :: IO String
queryAndChop = do
  putStrLn "Give me a string:"
  str <- getLine
  putStrLn "Give me a number:"
  ns <- getLine
  let n = read ns :: Int
  return $ safeChop str n

-- util
bsPut :: ByteString -> IO ()
bsPut (BS _  _ 0) = return ()
bsPut (BS ps s l) = withForeignPtr ps $ \p -> hPutBuf stdout (p `plusPtr` s) l