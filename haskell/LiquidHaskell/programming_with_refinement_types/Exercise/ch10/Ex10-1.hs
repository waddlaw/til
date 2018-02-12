import Data.Set (Set, singleton, union, empty, isSubsetOf, difference)

-- | Exercise 10.1 (Wellformedness Check)
{-@ evalAny :: Env -> Expr -> Maybe Val @-}
evalAny :: Map Var Expr -> Expr -> Maybe Expr
evalAny g e
  | ok = Just $ eval g e
  | otherwise = Nothing
  where
    ok = validateExpr e && free e `isSubsetOf` keys g

{-@ lazy validateExpr @-}
validateExpr :: Expr -> Bool
validateExpr (Const _)     = True
validateExpr (Var _)       = True
validateExpr (Plus e1 e2)  = validateExpr e1 && validateExpr e2
validateExpr (Let _ e1 e2) = validateExpr e1 && validateExpr e2

{-@
data Map k v = Node
  { key   :: k
  , value :: v
  , left  :: Map { v:k | v < key } v
  , right :: Map { v:k | key < v } v
  }
             | Tip
@-}
data Map k v = Node
  { key   :: k
  , value :: v
  , left  :: Map k v
  , right :: Map k v
  }
             | Tip

{-@ lazy keys @-}
{-@ measure keys @-}
keys :: (Ord k) => Map k v -> Set k
keys Tip = empty
keys (Node k v l r) = ks `union` kl `union` kr
  where
    kl = keys l
    kr = keys r
    ks = singleton k

{-@ emp :: { m:Map k v | Set_emp (keys m) } @-}
emp :: Map k v
emp = Tip

{-@ lazy set @-}
{-@ predicate AddKey K M N = keys N = Set_cup (Set_sng K) (keys M) @-}
{-@ predicate In X Xs      = Set_mem X Xs  @-}
{-@ predicate HasKey K M   = In K (keys M) @-}
{-@ set :: Ord k => k:k -> v:v -> m:Map k v -> { n:Map k v | AddKey k m n } @-}
set :: Ord k => k -> v -> Map k v -> Map k v
set k' v' (Node k v l r)
  | k' == k   = Node k v' l r
  | k' < k    = Node k v (set k' v' l) r
  | otherwise = Node k v l (set k' v' r)
set k' v' Tip = Node k' v' emp emp

{-@ lazy get @-}
{-@ get :: (Ord k) => k:k -> m:{ Map k v | HasKey k m } -> v @-}
get :: Ord k => k -> Map k v -> v
get k' (Node k v l r)
  | k' == k   = v
  | k' < k    = assert (lemma_notMem k' r) $ get k' l
  | otherwise = assert (lemma_notMem k' l) $ get k' r
get _ Tip = die "Lookup Never Fails"

{-@ lazy lemma_notMem @-}
{-@ lemma_notMem :: Ord k => key:k -> m:Map { k:k | k /= key } v -> { v:Bool | not (HasKey key m) } @-}
lemma_notMem :: Ord k => k -> Map k v -> Bool
lemma_notMem _ Tip = True
lemma_notMem key (Node _ _ l r) = lemma_notMem key l && lemma_notMem key r

type Var = String
data Expr = Const Int
          | Var Var
          | Plus Expr Expr
          | Let Var Expr Expr

{-@ measure val @-}
val :: Expr -> Bool
val (Const _) = True
val _ = False

{-@ type Val = { v:Expr | val v } @-}
{-@ type Env = Map Var Val @-}
{-@ type ClosedExpr G = { v:Expr | Set_sub (free v) (keys G) } @-}

{-@ plus :: Val -> Val -> Val @-}
plus :: Expr -> Expr -> Expr
plus (Const i) (Const j) = Const (i+j)
plus _ _ = die "Bad call to plus"

{-@ die :: { v:_ | false } -> a @-}
die :: String -> a
die = error

assert :: a -> b -> b
assert _ x = x

{-@ lazy eval @-}
{-@ eval :: g:Env -> ClosedExpr g -> Val @-}
eval :: Map Var Expr -> Expr -> Expr
eval _ i@(Const _) = i
eval g (Var x) = get x g
eval g (Plus e1 e2) = plus (eval g e1) (eval g e2)
eval g (Let x e1 e2) = eval g' e2
  where
    g' = set x v1 g
    v1 = eval g e1

{-@ lazy free @-}
{-@ measure free @-}
free :: Expr -> Set Var
free (Const _) = empty
free (Var x) = singleton x
free (Plus e1 e2) = xs1 `union` xs2
  where
    xs1 = free e1
    xs2 = free e2
free (Let x e1 e2) = xs1 `union` (xs2 `difference` xs)
  where
    xs1 = free e1
    xs2 = free e2
    xs = singleton x