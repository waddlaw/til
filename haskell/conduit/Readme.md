# Conduit

パッケージ名 | Hackage | Stackage | GitHub | 備考
-------------|---------|----------|--------|-----
conduit | [hackage](http://hackage.haskell.org/package/conduit) | [stackage](https://www.stackage.org/package/conduit) | [github](https://github.com/snoyberg/conduit)

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

### [Conduitの使い方](https://qiita.com/siphilia_rn/items/f3d8d83496a8eab65274)

- `conduit-1.0.8` の解説なのでちょっと古い
- 最後の例はあまり意味がない
- 全体的にわかりやすかったので入門向け