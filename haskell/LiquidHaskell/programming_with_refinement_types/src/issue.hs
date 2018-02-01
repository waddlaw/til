-- 100% 超える問題
{-@ f :: p:_ -> {v:_ | p => v }  @-}
f :: Bool -> Bool
f = id