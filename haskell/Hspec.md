# Hspec

- [User's Manual](http://hspec.github.io/)

## package

package name | GitHub | Hackage | Stackage
-------------|:------:|:-------:|:--------:
hspec | [LINK](https://github.com/hspec/hspec) | [LINK](https://hackage.haskell.org/package/hspec-2.4.7) | [LINK](https://www.stackage.org/package/hspec)
hspec-core | [LINK](https://github.com/hspec/hspec/tree/master/hspec-core) | [LINK](https://hackage.haskell.org/package/hspec-core-2.4.7) | [LINK](https://www.stackage.org/package/hspec-core)
hspec-expectations | [LINK](https://github.com/hspec/hspec-expectations) | [LINK](http://hackage.haskell.org/package/hspec-expectations) | [LINK](https://www.stackage.org/package/hspec-expectations)

## Types

### [Test.Hspec.Core.Spec.Monad](https://github.com/hspec/hspec/blob/master/hspec-core/src/Test/Hspec/Core/Spec/Monad.hs)

```haskell
type Spec = SpecWith ()
type SpecWith a = SpecM a ()

-- Spec = SpecM () ()

-- r (eturn)
newtype SpecM a r = SpecM (WriterT [SpecTree a] IO r)
  deriving (Functor, Applicative, Monad)
  
-- Spec = WriterT [SpecTree ()] IO ()
```

### [Test.Hspec.Core.Tree](https://github.com/hspec/hspec/blob/master/hspec-core/src/Test/Hspec/Core/Tree.hs)

```haskell
type SpecTree a = Tree (ActionWith a) (Item a)

-- Spec = WriterT [Tree (ActionWith ()) (Item ())] IO ()
```

```haskell
-- c (reanup)
-- Forest
data Tree c a = Node String [Tree c a]
              | NodeWithCleanup c [Tree c a]
              | Leaf a
              deriving (Functor, Foldable, Traversable)
```

```haskell
data Item a = Item
  { itemRequirement      :: String
  , itemLocation         :: Maybe Location
  , itemIsParallelizable :: Maybe Bool
  , itemExample          :: Params -> (ActionWith a -> IO ()) -> ProgressCallback -> IO Result
  }
```

### [Test.Hspec.Core.Example](https://github.com/hspec/hspec/blob/master/hspec-core/src/Test/Hspec/Core/Example.hs)

```haskell
type ActionWith a = a -> IO ()

-- Spec = WriterT [Tree (() -> IO ()) (Item ())] IO ()
```

### [Test.Hspec.Core.Example.Location](https://github.com/hspec/hspec/blob/master/hspec-core/src/Test/Hspec/Core/Example/Location.hs)

```haskell
data Location = Location
  { locationFile :: FilePath
  , locationLine :: Int
  , locationColumn :: Int
  } deriving (Eq, Show, Read)
```

### [Test.Hspec.Core.Example](https://github.com/hspec/hspec/blob/master/hspec-core/src/Test/Hspec/Core/Example.hs)

```haskell
data Params = Params
  { paramsQuickCheckArgs  :: Test.QuickCheck.Args
  , paramsSmallCheckDepth :: Int
  } deriving (Show)
```

## Classes

### [Test.Hspec.Core.Example](https://github.com/hspec/hspec/blob/master/hspec-core/src/Test/Hspec/Core/Example.hs)

```haskell
class Example e where
  type Arg e
  type Arg e = ()
  evaluateExample :: e -> Params -> (ActionWith (Arg e) -> IO ()) -> ProgressCallback -> IO Result
```

## hspec の動作についての考察

```haskell
main :: IO ()
main = hspec $ do
  describe "Prelude.head" $ do
    it "returns the first element of a list" $ do
      head [23 ..] `shouldBe` (23 :: Int)

    it "returns the first element of an *arbitrary* list" $
      property $ \x xs -> head (x:xs) == (x :: Int)

    it "throws an exception if used with an empty list" $ do
      evaluate (head []) `shouldThrow` anyException
```

### 主要な関数のそれぞれの型

function name | type | package
--------------|------|----------
[hspec](https://github.com/hspec/hspec/blob/master/hspec-core/src/Test/Hspec/Core/Runner.hs#L86) | `Spec -> IO ()` | hspec-core
[describe](https://github.com/hspec/hspec/blob/master/hspec-core/src/Test/Hspec/Core/Spec.hs#L47) | `String -> SpecWith a -> SpecWith a` | hspec-core
[it](https://github.com/hspec/hspec/blob/master/hspec-core/src/Test/Hspec/Core/Spec.hs#L66) | `(HasCallStack, Example a) => String -> a -> SpecWith (Arg a)` | hspec-core
[shouldBe](https://github.com/hspec/hspec-expectations/blob/master/src/Test/Hspec/Expectations.hs#L87) | `(HasCallStack, Show a, Eq a) => a -> a -> Expectation` | hspec-expectations
[shouldThrow](https://github.com/hspec/hspec-expectations/blob/master/src/Test/Hspec/Expectations.hs#L161) | `(HasCallStack, Exception e) => IO a -> Selector e -> Expectation` |hspec-expectations
evaluate | `a -> IO a` | base

### hspec

- `doExpr` は実際のテストケース

```haskell
main :: IO ()
main = hspec doExpr
     = hspecWith defaultConfig doExpr
     = do
         r <- hspecWithResult defaultConfig doExpr
         unless (isSuccess r) exitFailure
```

`hspec` を展開して行くと `hspecWithResult` が重要そうだとわかる。ここでは `Config` の詳細は追わない。

```haskell
hspecWithResult :: Config -> Spec -> IO Summary
hspecWithResult config spec = do
  prog <- getProgName
  args <- getArgs
  (oldFailureReport, c_) <- getConfig config prog args
  c <- ensureSeed c_
  if configRerunAllOnSuccess c
    then rerunAllMode c oldFailureReport
    else normalMode c
  where
    normalMode c = runSpec c spec
    rerunAllMode c oldFailureReport = do
      summary <- runSpec c spec
      if rerunAll c oldFailureReport summary
        then hspecWithResult config spec
        else return summary
```

`normalMode` と `rerunAllMode` で分岐しているが、本質的には `runSpec` を追えば良さそう。

```haskell
runSpec :: Config -> Spec -> IO Summary
runSpec config spec = do
    ...
    filteredSpec <- map (toEvalTree params) . filterSpecs config . applyDryRun config <$> runSpecM spec
    ...
```

色々と長いが `runSpecM` を追いかける。

```haskell
runSpecM :: SpecWith a -> IO [SpecTree a]
runSpecM (SpecM specs) = execWriterT specs
```

つまり、 `Spec` に対して `execWriterT` しているだけだった。`execWriterT :: Monad m => WriterT w m a -> m w` なので `IO [Tree (ActionWith ()) (Item ())]` 型の値が返ってくることがわかる。

### describe

```haskell
-- | The @describe@ function combines a list of specs into a larger spec.
describe :: String -> SpecWith a -> SpecWith a
describe label spec = runIO (runSpecM spec) >>= fromSpecList . return . specGroup label

runSpecM :: SpecWith a -> IO [SpecTree a]
runSpecM (SpecM specs) = execWriterT specs

runIO :: IO r -> SpecM a r
runIO = SpecM . liftIO

fromSpecList :: [SpecTree a] -> SpecWith a
fromSpecList = SpecM . tell

specGroup :: String -> [SpecTree a] -> SpecTree a
specGroup s = Node msg
  where
    msg
      | null s = "(no description given)"
      | otherwise = s
```

ややトリッキーだが整理するとこうなる

```haskell
describe label (SpecM specs) = do
  r <- SpecM $ liftIO $ execWriterT specs
  SpecM $ tell $ return $ specGroup label r
```

つまり `describe` が実行される度に、その子要素の `it` が全て実行されていくような順番となる。

具体的な型は以下の通り、特に `return` はリストモナドに持ち上げられる点に注意。

```haskell
-- w = [SpecTree a]
-- m = IO
tell :: w -> WriterT w m ()

SpecM :: WriterT [SpecTree a] IO r -> SpecM
tell  :: [SpecTree a] -> WriterT [SpecTree a] IO r
return :: SpecTree a -> [SpecTree a]
specGroup label r :: SpecTree a
```

### it

```haskell
it :: (HasCallStack, Example a) => String -> a -> SpecWith (Arg a)
it label action = fromSpecList [specItem label action]

specItem :: (HasCallStack, Example a) => String -> a -> SpecTree (Arg a)
specItem s e = Leaf $ Item requirement location Nothing (safeEvaluateExample e)
  where
    requirement
      | null s = "(unspecified behavior)"
      | otherwise = s
```

`describe` とほぼ同じ。

### まとめ

- 1つの `describe` で、それにぶら下がった `it` が先に全て評価される
- それぞれの `describe` の結果を集めて最終的な結果とする

## Arg の謎

`it` に出てきた `Arg a` について考察を進める。

```haskell
specItem :: (HasCallStack, Example a) => String -> a -> SpecTree (Arg a)
specItem s e = Leaf $ Item requirement location Nothing (safeEvaluateExample e)
```

`Item` と `safeEvaluateExample` の定義は以下の通り。

```haskell
data Item a = Item
  { itemRequirement      :: String
  , itemLocation         :: Maybe Location
  , itemIsParallelizable :: Maybe Bool
  , itemExample          :: Params -> (ActionWith a -> IO ()) -> ProgressCallback -> IO Result
  }

safeEvaluateExample :: Example e => e -> Params -> (ActionWith (Arg e) -> IO ()) -> ProgressCallback -> IO Result
safeEvaluateExample example params around progress = do
  r <- safeTry $ forceResult <$> evaluateExample example params around progress
  return $ case r of
    Left e | Just result <- fromException e -> result
    Left e | Just hunit <- fromException e -> hunitFailureToResult Nothing hunit
    Left e -> Failure Nothing $ Error Nothing e
    Right result -> result
  where
    forceResult :: Result -> Result
    forceResult r = case r of
      Success s -> s `deepseq` r
      Pending _ m -> m `deepseq` r
      Failure _ m -> m `deepseq` r
```

`Arg` のおかげで、`example` の引数の有無に関わらず `safeEvaluateExample` 1つで処理できるようになった。

### Example のインスタンス

**Result**

```haskell
instance Example Result where
  type Arg Result = ()
  evaluateExample e = evaluateExample (\() -> e)
  
instance Example (a -> Result) where
  type Arg (a -> Result) = a
  evaluateExample example _params action _callback = do
    ref <- newIORef (Success "")
    action (writeIORef ref . example)
    readIORef ref
```

**Bool**

```haskell

instance Example Bool where
  type Arg Bool = ()
  evaluateExample e = evaluateExample (\() -> e)

instance Example (a -> Bool) where
  type Arg (a -> Bool) = a
  evaluateExample p _params action _callback = do
    ref <- newIORef (Success "")
    action $ \a -> example a >>= writeIORef ref
    readIORef ref
    where
      example a
        | p a = return (Success "")
        | otherwise = return (Failure Nothing NoReason)
```

**Expectation**

```haskell
instance Example Expectation where
  type Arg Expectation = ()
  evaluateExample e = evaluateExample (\() -> e)
  
instance Example (a -> Expectation) where
  type Arg (a -> Expectation) = a
  evaluateExample e _ action _ = action e >> return (Success "")
```

**Property**

```haskell
instance Example QC.Property where
  type Arg QC.Property = ()
  evaluateExample e = evaluateExample (\() -> e)

instance Example (a -> QC.Property) where
  type Arg (a -> QC.Property) = a
  evaluateExample p c action progressCallback = do
    r <- QC.quickCheckWithResult (paramsQuickCheckArgs c) {QC.chatty = False} (QCP.callback qcProgressCallback $ aroundProperty action p)
    return $ fromQuickCheckResult r
    where
      qcProgressCallback = QCP.PostTest QCP.NotCounterexample $
        \st _ -> progressCallback (QC.numSuccessTests st, QC.maxSuccessTests st)
```







