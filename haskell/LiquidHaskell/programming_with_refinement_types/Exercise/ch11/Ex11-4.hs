import           Data.Word          (Word8)
import           Foreign.Ptr        (Ptr, plusPtr)
import           Foreign.ForeignPtr (ForeignPtr, withForeignPtr, mallocForeignPtrBytes)
import           Foreign.Storable   (Storable, poke)
import           Data.ByteString.Internal (c2w)
import           System.IO.Unsafe         (unsafePerformIO)

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

{-@ mallocForeignPtrBytes :: n:Nat -> IO (ForeignPtrN a n) @-}

{-@
data ByteString = BS
  { bPtr :: ForeignPtr Word8
  , bOff :: {v:Nat | v <= fplen bPtr}
  , bLen :: {v:Nat | v + bOff <= fplen bPtr}
  }
@-}
data ByteString = BS
  { bPtr :: ForeignPtr Word8
  , bOff :: !Int
  , bLen :: !Int
  }

{-@ type ByteStringN N = {v:ByteString | bLen v = N} @-}

{-@ create :: n:Nat -> (PtrN Word8 n -> IO ()) -> ByteStringN n @-}
create :: Int -> (Ptr Word8 -> IO ()) -> ByteString
create n fill = unsafePerformIO $ do
  fp <- mallocForeignPtrBytes n
  withForeignPtr fp fill
  return (BS fp 0 n)