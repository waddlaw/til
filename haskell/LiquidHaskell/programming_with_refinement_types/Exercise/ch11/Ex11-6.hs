import           Data.ByteString.Internal (w2c)
import           Data.Word                (Word8)
import           Foreign.ForeignPtr       (ForeignPtr)
import           Foreign.ForeignPtr       (withForeignPtr)
import           Foreign.Ptr              (Ptr, plusPtr)
import           Foreign.Storable         (peek)
import           System.IO.Unsafe         (unsafePerformIO)

{-@ unpack :: b:ByteString -> { v:String | bLen b == len v } @-}
unpack :: ByteString -> String
unpack (BS _ _ 0) = []
unpack (BS ps s l) =
  unsafePerformIO $ withForeignPtr ps $ \p -> go (p `plusPtr` s) (l - 1) []
  where
    {-@ go :: p:OkPtr a -> n:{v:Nat | v < plen p} -> acc:_ -> IO { v:_ | len v = n + len acc + 1 } @-}
    go p 0 acc = peekAt p 0 >>= \e -> return (w2c e : acc)
    go p n acc = peekAt p n >>= \e -> go p (n-1) (w2c e : acc)
    {-@ peekAt :: p:OkPtr a -> {v:Nat | v < plen p} -> _ @-}
    peekAt p n = peek (p `plusPtr` n)

{-@ prop_unpack_length :: ByteString -> TRUE @-}
prop_unpack_length :: ByteString -> Bool
prop_unpack_length b = bLen b == length (unpack b)

{-@ type TRUE = { v:Bool | true } @-}
{-@ type OkPtr a = {v:Ptr a | 0 < plen v} @-}

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
