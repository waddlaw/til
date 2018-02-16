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

## Exercise 11.2 (Create)

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
