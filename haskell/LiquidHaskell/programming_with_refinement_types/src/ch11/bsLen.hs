{-@ LIQUID "--diff" @-}

import           Data.Word                (Word8)
import           GHC.ForeignPtr           (ForeignPtr)

-- data ByteString = BS
--   { bPtr :: ForeignPtr Word8
--   , bOff :: !Int
--   , bLen :: !Int
--   }

-- {-@ measure bsLen @-}
-- bsLen :: [ByteString] -> Int
-- bsLen [] = 0
-- bsLen (b:bs) = bLen b + bsLen bs

{-@ measure nLen @-}
nLen :: [Int] -> Int
nLen [] = 0
nLen (n:ns) = n + nLen ns