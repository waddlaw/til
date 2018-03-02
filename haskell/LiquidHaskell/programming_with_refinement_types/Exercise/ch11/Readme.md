# Case Study: Pointers & Bytes

## Exercise 11.1 (Legal ByteStrings)

`bad1` と `bad2` の定義を変更し、 `LiquidHaskell` が受理できるようにせよ。

### LiquidHaskell の結果

### 解答

```haskell
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
```

## Exercise 11.2 (Create) *

### LiquidHaskell の結果

### 解答

```haskell
{-@ create :: n:Nat -> (PtrN Word8 n -> IO ()) -> ByteStringN n @-}
create :: Int -> (Ptr Word8 -> IO ()) -> ByteString
create n fill = unsafePerformIO $ do
  fp <- mallocForeignPtrBytes n
  withForeignPtr fp fill
  return (BS fp 0 n)
```

## Exercise 11.3 (Pack)

### LiquidHaskell の結果

### 解答

```haskell
{-@ pack :: v:String -> ByteStringN (len v) @-}
pack :: String -> ByteString
pack str = create n $ \p -> go p xs
  where
    n = length str
    xs = map c2w str
    go _ [] = return ()
    go p (x:xs) = poke p x >> go (plusPtr p 1) xs
```

## Exercise 11.4 (Pack Invariant) *

### LiquidHaskell の結果

### 解答

```haskell
packEx :: String -> ByteString
packEx str = create n $ \p -> pLoop p xs
  where
    n  = length str
    xs = map c2w str

{-@ pLoop :: (Storable a) => p:Ptr a -> { xs:[a] | len xs == plen p }  -> IO () @-}
pLoop :: (Storable a) => Ptr a -> [a] -> IO ()
pLoop _ []     = return ()
pLoop p (x:xs) = poke p x >> pLoop (p `plusPtr` 1) xs
```

## Exercise 11.5 (Unsafe Take and Drop)

### LiquidHaskell の結果

### 解答

```haskell
{-@ unsafeTake :: n:Nat -> {v:ByteString | n <= bLen v } -> ByteStringN n @-}
unsafeTake :: Int -> ByteString -> ByteString
unsafeTake n (BS x s _) = BS x s n

{-@ unsafeDrop :: n:Nat -> b:{v:ByteString | n <= bLen v } -> ByteStringN {bLen b - n} @-}
unsafeDrop :: Int -> ByteString -> ByteString
unsafeDrop n (BS x s l) = BS x (s + n) (l - n)
```

## Exercise 11.6 (Unpack) *

### LiquidHaskell の結果

### 解答

```haskell
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
```

`peekAt` は自動的に推論されるので無くても良い。