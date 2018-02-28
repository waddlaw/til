import           Data.Word          (Word8)
import           Foreign.Ptr        (Ptr, plusPtr)
import           Foreign.ForeignPtr (ForeignPtr, withForeignPtr, mallocForeignPtrBytes,)
import           Foreign.Storable   (poke)
import           Data.ByteString.Internal (c2w)
import           System.IO.Unsafe         (unsafePerformIO)

-- | Ex 11.3 (Pack)
{-@ pack :: v:String -> ByteStringN (len v) @-}
pack :: String -> ByteString
pack str = create n $ \p -> go p xs
  where
    n = length str
    xs = map c2w str
    {-@ go :: p:Ptr a -> { v:[a] | len v == plen p } -> IO () @-}
    go _ [] = return ()
    go p (x:xs) = poke p x >> go (plusPtr p 1) xs

{-@ type TRUE = { v:Bool | true } @-}

{-@ prop_pack_length :: String -> TRUE @-}
prop_pack_length :: String -> Bool
prop_pack_length xs = bLen (pack xs) == length xs


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