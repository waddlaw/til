import           Data.Word          (Word8)
import           Foreign.ForeignPtr (ForeignPtr, mallocForeignPtrBytes)

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

data ByteString = BS
  { bPtr :: ForeignPtr Word8
  , bOff :: !Int
  , bLen :: !Int
  }

{-@ type ForeignPtrN a N = { v:ForeignPtr a | fplen v = N } @-}
{-@ mallocForeignPtrBytes :: n:Nat -> IO (ForeignPtrN a n) @-}

{-@
  data ByteString = BS
    { bPtr :: ForeignPtr Word8
    , bOff :: {v:Nat | v <= fplen bPtr}
    , bLen :: {v:Nat | v + bOff <= fplen bPtr}
    }
@-}

{-@ type ByteStringN N = {v:ByteString | bLen v = N} @-}
