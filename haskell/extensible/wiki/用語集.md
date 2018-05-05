# 用語集

## 型レベルリスト

その名の通り、`[Int, Bool, Char] :: [*]` というような複数の型を含むリスト。

### 表記法

正しい使い方

```hs
'[Int]
'[Int, Bool, Char]
[Int, Bool, Char]

'["name" >: String]
'["name" >: String, "age" >: Int]
["name" >: String, "age" >: Int]
```

間違った使い方

```hs
["name"   >: String]
```

解説

```hs
[ "name"   >: String ] -- コンパイルエラーになる (通常のリスト型と区別がつかないため)
[ "name"   >: String, "age" >: Int ] -- コンパイルエラーにならない (リスト型に複数の型を入れることはできないため判別可能)
```
