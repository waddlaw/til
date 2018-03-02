import           Data.ByteString.Internal (c2w, w2c)
import           Data.Word                (Word8)
import           Foreign.ForeignPtr       (ForeignPtr, withForeignPtr, mallocForeignPtrBytes)
import           Foreign.Ptr              (Ptr, plusPtr)
import           Foreign.Storable         (peek, poke)
import           System.IO.Unsafe         (unsafePerformIO)

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


{-@ chop :: s:String -> n:BNat (len s) -> String @-}
chop :: String -> Int -> String
chop s n = s'
  where
    b = pack s
    b' = unsafeTake n b
    s' = unpack b'

{-@ unsafeTake :: n:Nat -> {v:ByteString | n <= bLen v } -> ByteStringN n @-}
unsafeTake :: Int -> ByteString -> ByteString
unsafeTake n (BS x s _) = BS x s n

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

{-@ pack :: v:String -> ByteStringN (len v) @-}
pack :: String -> ByteString
pack str = create n $ \p -> go p xs
 where
  n  = length str
  xs = map c2w str
  {-@ go :: p:Ptr a -> { v:[a] | len v == plen p } -> IO () @-}
  go _ []     = return ()
  go p (x:xs) = poke p x >> go (p `plusPtr` 1) xs

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

{-@ create :: n:Nat -> (PtrN Word8 n -> IO ()) -> ByteStringN n @-}
create :: Int -> (Ptr Word8 -> IO ()) -> ByteString
create n fill = unsafePerformIO $ do
  fp <- mallocForeignPtrBytes n
  withForeignPtr fp fill
  return (BS fp 0 n)

{-@ mallocForeignPtrBytes :: n:Nat -> IO (ForeignPtrN a n) @-}
{-@ type ByteStringN N = {v:ByteString | bLen v = N} @-}
{-@ type OkPtr a = {v:Ptr a | 0 < plen v} @-}