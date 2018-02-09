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












