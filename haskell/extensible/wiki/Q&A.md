# Q&A

---

2018/05/02

Q. 以下のように `deriveIsRecord` を使えば、通常の型から `extensible` の型を導出できると思います。

```haskell
data Person = Person
  { name  :: String
  , age   :: Int
  } deriving Show

deriveIsRecord ''Person
```

逆に `extensible` の型から通常の型を導出することも可能でしょうか？

A.一つの型レベルリストであるという条件付き(結合演算子などを使っていない)ならできますが、あまり有用なものにはならない気がします。普通のレコードをA、拡張可能レコードのフィールド列をFieldsとしたとき、`fromRecord :: (Fields ~ RecFields A) => Record Fields -> A`を使うことになると思います

---

2018/05/02

Q. `xxx ^. #fieldName` の形式で値を取得する時に `fieldName` に `- (ハイフン)` が含まれる場合は、以下のような関数を定義するしかないのでしょうか？

```
getDefaultExtensions :: Getting [String] Package [String]
getDefaultExtensions = fromLabel @"default-extensions"
```

A. これは仕方ない感じですね…もう少し制約が緩くてもいいと思ってはいるのですが

---

2018/04/30

Q. これって、意外とわかりづらいですよね。

```haskell
[ "name"   >: String ] -- コンパイルエラーになる (通常のリスト型と区別がつかないため)
[ "name"   >: String, "age" >: Int ] -- コンパイルエラーにならない (リスト型に複数の型を入れることはできないため判別可能)
```

常に `'[ ... ]` の形で書いた方が良いのでしょうか？

A. 基本的にはシングルクオートを常時つけるのを推奨します。

---

2018/04/27

Q. `hmap` について質問です。

`hmap` はラッパー `h` を `g` に変換していると思いますが、 `xs` を `ys` にすることは可能でしょうか？
例えば、以下のような例です。

```hs
badHmap1 :: Identity :* '[Int] -> Identity :* '[Bool]
badHmap1 = hmap f2

f2 :: Identity Int -> Identity Bool
f2 = pure . isZero . runIdentity
  where isZero 0 = True
```

A. 期待しているのとは違うかもしれませんが、こんな感じで行列を定義して形状の異なるレコードについて変換を定義することができます。

```hs
{-# LANGUAGE TypeOperators, PolyKinds, FlexibleContexts, DataKinds #-}

import Control.Arrow
import Data.Extensible
import Data.Monoid

newtype Row g h xs c = Row { unRow :: Comp ((->) (g c)) h :* xs }

runMatrix :: Monoid (h :* ys) => Row g h ys :* xs -> g :* xs -> h :* ys
runMatrix mat r = hfoldMap getConst'
  $ hzipWith (\x (Row y) -> Const' $ hmap (\(Comp f) -> f x) y) r mat

badHmap1 :: First :* '[Int] -> First :* '[Bool]
badHmap1 = runMatrix
  $ Row (Comp (fmap (==0)) <: nil)
  <: nil
```

---

2018/04/21

Q. 素朴な質問です。

```hs
type Record = RecordOf Identity
type RecordOf h = (:*) (Field h)

-- Record = (:*) (Field Identity)
-- Record xs = (Field Identity) :* xs
```

上記の結果 `Record xs = (Field Identity) :* xs` となると思います。
この時、

```hs
f :: (Field Identity) :* xs -> xs
```

っていうような関数 `f` は作れないですよね？(カインドが `*` ではないため)

A. xsの種は型レベルリストでなければならない一方、関数の戻り値は*(値の型)でないといけないので、できないですね。

---

2018/04/21

Q. 例えばこの `h6` という関数は型レベルリストの全ての `key` を集める処理になってると思うのですが

```hs
h6 :: [String]
h6 = henumerateFor (Proxy @ (KeyIs KnownSymbol)) (Proxy @ ('["name" :> String, "age" :> Int, "age2" :> Int])) f6 mempty

-- 全てのキーを取得する
f6 :: Forall (KeyIs KnownSymbol) xs
  => Membership xs x
  -> [String]
  -> [String]
f6 m r = getConst' (hlookup m names) : r
  where
    names = htabulateFor (Proxy @ (KeyIs KnownSymbol)) $ Const' . symbolVal . proxyAssocKey
```

違う例として、 `Show` 可能な全ての `value` を集めて文字列のリストにすることもできますか？

A. まとめてみました。レシピ集が作れそうですね

```hs
{-# LANGUAGE FlexibleContexts, ScopedTypeVariables, TypeApplications, AllowAmbiguousTypes #-}

import Data.Extensible
import Data.Functor.Identity
import Data.Proxy
import GHC.TypeLits

keys :: Forall (KeyIs KnownSymbol) xs => proxy xs -> [String]
keys xs = henumerateFor (Proxy @ (KeyIs KnownSymbol)) xs
  ((:) . symbolVal . proxyAssocKey) []

values :: Forall (ValueIs Show) xs => Record xs -> [String]
values = hfoldrWithIndexFor (Proxy @ (ValueIs Show))
  (const $ (:) . show . runIdentity . getField) []
```

---
