import           Data.ByteString.Internal (c2w)
import           Data.Word                (Word8)
import           Foreign.ForeignPtr       (ForeignPtr, mallocForeignPtrBytes,
                                           withForeignPtr)
import           Foreign.Ptr              (Ptr, plusPtr)
import           Foreign.Storable         (poke)
import           System.IO.Unsafe         (unsafePerformIO)

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
{-@ type ForeignPtrN a N = { v:ForeignPtr a | fplen v = N } @-}
{-@ mallocForeignPtrBytes :: n:Nat -> IO (ForeignPtrN a n) @-}