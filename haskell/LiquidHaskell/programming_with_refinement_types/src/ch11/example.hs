import           Data.ByteString.Char8    (pack, unpack)
import           Data.ByteString.Internal (c2w)
import           Data.ByteString.Unsafe   (unsafeTake)
import           Data.Word                (Word8)
import           Foreign.ForeignPtr       (ForeignPtr, mallocForeignPtrBytes,
                                           withForeignPtr)
import           Foreign.Ptr              (Ptr, plusPtr)
import           Foreign.Storable         (peek, poke)
import           System.IO                (stdout, hPutBuf)
import           System.IO.Unsafe         (unsafePerformIO)

-- chop' :: String -> Int -> String
-- chop' s n = s'
--  where
--   b  = pack s
--   b' = unsafeTake n b
--   s' = unpack b'

-- zero4 = do
--   fp <- mallocForeignPtrBytes 4
--   withForeignPtr fp $ \p -> do
--     poke (p `plusPtr` 0) zero
--     poke (p `plusPtr` 1) zero
--     poke (p `plusPtr` 2) zero
--     poke (p `plusPtr` 3) zero
--   return fp
--   where zero = 0 :: Word8

-- zero4' = do
--   fp <- mallocForeignPtrBytes 4
--   withForeignPtr fp $ \p -> do
--     poke (p `plusPtr` 0) zero
--     poke (p `plusPtr` 1) zero
--     poke (p `plusPtr` 2) zero
--     poke (p `plusPtr` 8) zero
--   return fp
--   where zero = 0 :: Word8

-- | 定義済み
-- {-@ measure plen :: Ptr a -> Int @-}
-- {-@ measure fplen :: ForeignPtr a -> Int @-}
-- {-@ type PtrN a N = { v:Ptr a | plen v = N } @-}
-- {-@ withForeignPtr :: fp:ForeignPtr a -> (PtrN a (fplen fp) -> IO b) -> IO b @-}

{-@ type ForeignPtrN a N = { v:ForeignPtr a | fplen v = N } @-}
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

{-@ type OkPtr a = {v:Ptr a | 0 < plen v} @-}

-- | 定義済み
-- {-@ peek :: OkPtr a -> IO a @-}
-- {-@ poke :: OkPtr a -> a -> IO () @-}
-- {-@ plusPtr :: p:Ptr a -> off:BNat (plen p) -> PtrN b {plen p - off} @-}

{-@ type BNat N = {v:Nat | v <= N} @-}

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

data ByteString = BS
  { bPtr :: ForeignPtr Word8
  , bOff :: !Int
  , bLen :: !Int
  }

{-@
  data ByteString = BS
    { bPtr :: ForeignPtr Word8
    , bOff :: {v:Nat | v <= fplen bPtr}
    , bLen :: {v:Nat | v + bOff <= fplen bPtr}
    }
@-}

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

-- util
bsPut :: ByteString -> IO ()
bsPut (BS _  _ 0) = return ()
bsPut (BS ps s l) = withForeignPtr ps $ \p-> hPutBuf stdout (p `plusPtr` s) l