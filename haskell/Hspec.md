# Hspec

- [User's Manual](http://hspec.github.io/)

## package

package name | GitHub | Hackage | Stackage
-------------|:------:|:-------:|:--------:
Hspec | [LINK](https://github.com/hspec/hspec) | [LINK](https://hackage.haskell.org/package/hspec-2.4.7) | [LINK](https://www.stackage.org/package/hspec)
hspec-core | [LINK](https://github.com/hspec/hspec/tree/master/hspec-core) | [LINK](https://hackage.haskell.org/package/hspec-core-2.4.7) | [LINK](https://www.stackage.org/package/hspec-core)


- [hspec-core on GitHub](https://github.com/hspec/hspec/tree/master/hspec-core)
- [

## Type

```haskell
type Spec = SpecWith ()
type SpecWith a = SpecM a ()

-- Spec = SpecM () ()

type family Arg e :: *
```
