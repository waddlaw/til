# PROGRAMMING WITH REFINEMENT TYPES

```bash
# LiquidHaskell
$ stack exec -- liquid src/chXX/XXX.hs

# REPL
$ stack repl src/chXX/XXX.hs
```

- [book (pdf ver)](http://ucsd-progsys.github.io/liquidhaskell-tutorial/book.pdf)
- [book (embeded pdf ver)](https://github.com/ucsd-progsys/liquidhaskell-tutorial/blob/master/pdf/programming-with-refinement-types.pdf)
- [book (html ver)](http://ucsd-progsys.github.io/liquidhaskell-tutorial/01-intro.html)

訳 | ノート
--- | ---
[Ch01. Introduction](/haskell/LiquidHaskell/programming_with_refinement_types/ch01.md) | [note](./ch01-note.md)
_ | [note](./ch02-note.md)
_ | [note](./ch03-note.md)

## LIQUID プラグマ

プラグマ | 意味
--------|------
`{-@ lazy <func> @-}` | `func` の停止性判定を無効化する

{-@ LIQUID "--higherorder" @-}
{-@ LIQUID "--no-totality" @-}
{-@ LIQUID "--no-termination" @-}
{-@ LIQUID "--automatic-instances=liquidinstances" @-}
{-@ LIQUID "--diff"        @-}
{-@ LIQUID "--short-names" @-}
{-@ LIQUID "--cabaldir"    @-}
{-@ LIQUID "--total-Haskell" @-}
{-@ LIQUID "--prune-unsorted" @-}
