# Conduit

パッケージ名 | Hackage | Stackage | GitHub | 備考
-------------|---------|----------|--------|-----
conduit | [hackage](http://hackage.haskell.org/package/conduit) | [stackage](https://www.stackage.org/package/conduit) | [github](https://github.com/snoyberg/conduit/tree/master/conduit)
conduit-extra | [hackage](https://hackage.haskell.org/package/conduit-extra) | [stackage](https://www.stackage.org/package/conduit-extra) | [github](https://github.com/snoyberg/conduit/tree/master/conduit-extra)
binary-conduit | [hackage](https://github.com/qnikst/binary-conduit/) | [stackage](https://www.stackage.org/package/binary-conduit) | [github](https://hackage.haskell.org/package/binary-conduit)

## よく使う型・関数まとめ

```hs
-- i は処理の入力として取る値の型
-- o は次の処理に流す値の型
-- m は基底モナドの型
-- r は処理終了後に返す値の型
data ConduitM i o m r
```

```hs
type Source m o    = ConduitM () o    m ()
type Conduit i m o = ConduitM i  o    m ()
type Sink i m r    = ConduitM i  Void m r
```

```hs
type Producer m o   = forall i. ConduitM i o m ()
type Consumer i m r = forall o. ConduitM i o m r
```

```hs
await  :: Monad m => Consumer i m (Maybe i)

yield  :: Monad m =>   o -> ConduitM i o m ()
yieldM :: Monad m => m o -> ConduitM i o m ()

leftover :: i -> ConduitM i o m ()
```

```hs
($$+) :: Monad m => Source m a -> Sink a m b -> m (ResumableSource m a, b)
($$++) :: Monad m => ResumableSource m a -> Sink a m b -> m (ResumableSource m a, b)
($$+-) :: Monad m => ResumableSource m a -> Sink a m b -> m b
($=+) :: Monad m => ResumableSource m a -> Conduit a m b -> ResumableSource m b
```

```hs
($$)  :: Monad m => Source m a    -> Sink a m b       -> m b
(=$=) :: Monad m => Conduit a m b -> ConduitM b c m r -> ConduitM a c m r
```

## Qiita

最終更新日 | タイトル | conduit version | おすすめ
-----------|----------|:---------------:|:----------:
2014年03月21日 | [Conduitの使い方](https://qiita.com/siphilia_rn/items/f3d8d83496a8eab65274) | 1.0.8 | O
2013年01月19日 | [Data.Conduit](https://qiita.com/hiratara/items/0c5af17feeae5c03479e) | 不明 | X
2013年09月16日 | [Data.Binary.Get with Data.Conduit](https://qiita.com/liquid_amber/items/7c69271ae5c19beee383) | 不明 | O
2013年09月15日 | [特定の値を読み込むまでのConduit](https://qiita.com/liquid_amber/items/22e3d791c3396b3ab13d) | 不明 | O

### [Conduitの使い方](https://qiita.com/siphilia_rn/items/f3d8d83496a8eab65274)

- `conduit-1.0.8` の解説なのでちょっと古い
- 最後の例はあまり意味がない
- 全体的にわかりやすかったので入門向け

### [Data.Conduit](https://qiita.com/hiratara/items/0c5af17feeae5c03479e)

- 記事通りでは動かないが、コメント通りに動かせば問題無い
- `Data.Conduit.Util` というのは今はもう無い
- `conduitState` はもう使わない。代わりに `CL.map` を使う
- 型の都合で `$=` と `=$` と `=$=` を使い分けないとならない。とあるが、 `$=` と `=$` は `=$=` のエイリアスになってるので `=$=` だけ使えば良い
- 今読むには少しきつい

### [Data.Binary.Get with Data.Conduit](https://qiita.com/liquid_amber/items/7c69271ae5c19beee383)

- `binary` パッケージを利用する時は `binary-conduit` パッケージを使うようだ
- インポートリストを明示的に書いてあれば親切だと思う
- 実用性高いのでおすすめ

### [特定の値を読み込むまでのConduit](https://qiita.com/liquid_amber/items/22e3d791c3396b3ab13d)

- `lines` の使い方が載っている
- `import Control.Monad.Trans.Resource` を追加しないと動かない