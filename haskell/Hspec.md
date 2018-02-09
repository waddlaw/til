# Hspec

- [User's Manual](http://hspec.github.io/)

## package

package name | GitHub | Hackage | Stackage
-------------|:------:|:-------:|:--------:
hspec | [LINK](https://github.com/hspec/hspec) | [LINK](https://hackage.haskell.org/package/hspec-2.4.7) | [LINK](https://www.stackage.org/package/hspec)
hspec-core | [LINK](https://github.com/hspec/hspec/tree/master/hspec-core) | [LINK](https://hackage.haskell.org/package/hspec-core-2.4.7) | [LINK](https://www.stackage.org/package/hspec-core)

## Type

### [Test.Hspec.Core.Spec.Monad](https://github.com/hspec/hspec/blob/master/hspec-core/src/Test/Hspec/Core/Spec/Monad.hs)

```haskell
type Spec = SpecWith ()
type SpecWith a = SpecM a ()

-- Spec = SpecM () ()

-- a (ction)
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
data Tree c a =
    Node String [Tree c a]
  | NodeWithCleanup c [Tree c a]
  | Leaf a
  deriving (Functor, Foldable, Traversable)
```

```haskell
data Item a = Item {
  itemRequirement :: String
, itemLocation :: Maybe Location
, itemIsParallelizable :: Maybe Bool
, itemExample :: Params -> (ActionWith a -> IO ()) -> ProgressCallback -> IO Result
}
```

### [Test.Hspec.Core.Example](https://github.com/hspec/hspec/blob/master/hspec-core/src/Test/Hspec/Core/Example.hs)

```haskell
type ActionWith a = a -> IO ()

-- Spec = WriterT [Tree (() -> IO ()) (Item ())] IO ()
```













