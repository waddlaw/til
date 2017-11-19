import Prelude hiding (not)

{-@ type TRUE = { v:Bool | v } @-}
{-@ type FALSE = { v:Bool | not v } @-}
{-@ type BOOL1 = { true } @-}
{-@ type BOOL2 = { True } @-}
{-@ type BOOL3 = { false } @-}
{-@ type BOOL4 = { False } @-}
{-@ type P1 = { true => true } @-}
{-@ type P2 = { true ==> true } @-}
{-@ type P3 = { true <=> true } @-}
{-@ type P4 = { false => true => false } @-}
{-@ type P5 = { (false => true) => false } @-}
{-@ t :: TRUE @-}
-- {-@ t :: FALSE @-} UNSAFE
{-@ t :: BOOL1 @-}
{-@ t :: BOOL2 @-}
-- {-@ t :: BOOL3 @-} UNSAFE
-- {-@ t :: BOOL4 @-} UNSAFE
{-@ t :: P1 @-}
{-@ t :: P2 @-}
{-@ t :: P3 @-}
{-@ t :: P4 @-}
-- {-@ t :: P5 @-} UNSAFE
t = True

-- {-@ f :: TRUE @-} UNSAFE
{-@ f :: FALSE @-}
{-@ f :: BOOL1 @-}
{-@ f :: BOOL2 @-}
-- {-@ f :: BOOL3 @-} UNSAFE
-- {-@ f :: BOOL4 @-} UNSAFE
{-@ f :: P1 @-}
{-@ f :: P2 @-}
{-@ f :: P3 @-}
{-@ f :: P4 @-}
-- {-@ f :: P5 @-} UNSAFE
f = False
