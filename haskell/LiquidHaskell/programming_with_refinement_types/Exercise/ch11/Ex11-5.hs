import           Data.Word          (Word8)
import           Foreign.ForeignPtr (ForeignPtr)

-- | Ex 11.5 (Unsafe Take and Drop)
{-@ unsafeTake :: n:Nat -> {v:ByteString | n <= bLen v } -> ByteStringN n @-}
unsafeTake :: Int -> ByteString -> ByteString
unsafeTake n (BS x s _) = BS x s n

{-@ unsafeDrop :: n:Nat -> b:{v:ByteString | n <= bLen v } -> ByteStringN {bLen b - n} @-}
unsafeDrop :: Int -> ByteString -> ByteString
unsafeDrop n (BS x s l) = BS x (s + n) (l - n)

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