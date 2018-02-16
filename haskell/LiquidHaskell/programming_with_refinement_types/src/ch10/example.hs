import Data.Set (Set, union, singleton, empty, difference, isSubsetOf)

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

-- | Exercise 10.3 (Empty Maps)
{-@ emp :: { m:Map k v | Set_emp (keys m) } @-}
emp :: Map k v
emp = Tip

-- | Exercise 10.4 (Insert)
{-@ predicate AddKey K M N = keys N = Set_cup (Set_sng K) (keys M) @-}

{-@ lazy set @-}
{-@ set :: Ord k => k:k -> v:v -> m:Map k v -> { n:Map k v | AddKey k m n } @-}
set :: Ord k => k -> v -> Map k v -> Map k v
set k' v' (Node k v l r)
  | k' == k   = Node k v' l r
  | k' < k    = Node k v (set k' v' l) r
  | otherwise = Node k v l (set k' v' r)
set k' v' Tip = Node k' v' emp emp

{-@ die :: { v:_ | false } -> a @-}
die :: String -> a
die = error

{-@ predicate In X Xs      = Set_mem X Xs  @-}
{-@ predicate HasKey K M   = In K (keys M) @-}

{-@ lazy lemma_notMem @-}
{-@ lemma_notMem :: Ord k => key:k -> m:Map { k:k | k /= key } v -> { v:Bool | not (HasKey key m) } @-}
lemma_notMem :: Ord k => k -> Map k v -> Bool
lemma_notMem _ Tip = True
lemma_notMem key (Node _ _ l r) = lemma_notMem key l && lemma_notMem key r

{-@ lazy get @-}
{-@ get :: (Ord k) => k:k -> m:{ Map k v | HasKey k m } -> v @-}
get :: Ord k => k -> Map k v -> v
get k' (Node k v l r)
  | k' == k   = v
  | k' < k    = assert (lemma_notMem k' r) $ get k' l
  | otherwise = assert (lemma_notMem k' l) $ get k' r
get _ Tip = die "Lookup Never Fails"

assert :: a -> b -> b
assert _ x = x

-- | Exercise 10.5 (Membership Test)
{-@ lazy mem @-}
{-@ mem :: (Ord k) => k:k -> m:Map k v -> { v:_ | v <=> HasKey k m } @-}
mem :: Ord k => k -> Map k v -> Bool
mem k' (Node k _ l r)
  | k' == k   = True
  | k' < k    = assert (lemma_notMem k' r) $ mem k' l
  | otherwise = assert (lemma_notMem k' l) $ mem k' r
mem _ Tip = False

-- | Exercise 10.6 (Fresh)
{-@ lazy fresh @-}
{-@ fresh :: xs:[Int] -> { v:Int | not (Elem v xs) } @-}
fresh :: [Int] -> Int
fresh xs = undefined

{-@ predicate Elem X Ys = In X (elems Ys) @-}
{-@ measure elems @-}
elems :: Ord a => [a] -> Set a
elems [] = empty
elems (x:xs) = (singleton x) `union` (elems xs)

------
type Var = String
data Expr = Const Int
          | Var Var
          | Plus Expr Expr
          | Let Var Expr Expr
          | Fun Var Expr
          | App Expr Expr

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

{-@ measure isFun @-}
isFun :: Expr -> Bool
isFun (Fun _ _) = True
isFun _ = False

{-@ type Fun = { v:Expr | isFun v } @-}

{-@ app :: Fun -> Expr -> Expr @-}
app :: Expr -> Expr -> Expr
app (Fun x e1) e2 = Let x e2 e1
app _ _ = die "Bad call to app"

{-@ LIQUID "--no-totality" @-}
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
eval g (Fun x e) = undefined -- eval g' e
  -- where
  --   g' = del x g
eval g (App (Fun x e1) e2) = eval g' e1
  where
    g' = set x v1 g
    v1 = eval g e2

subst :: Var -> Expr -> Expr
subst v e = undefined

{-@ predicate DelKey K M N = keys N = Set_dif (Set_sng K) (keys M) @-}

{-@ lazy del @-}
{-@ del :: (Ord k) => k:k -> m:{ Map k v | HasKey k m } -> { n:Map k v | DelKey k m n } @-}
del :: Ord k => k -> Map k v -> Map k v
del k' (Node k v l r)
  | k' == k   = -- TODO delMin
  | k' < k    = assert (lemma_notMem k' r) $ del k' l
  | otherwise = assert (lemma_notMem k' l) $ del k' r
del _ Tip = die "Lookup Never Fails"

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
free (Fun x e) = free e `difference` singleton x
free (App e1 e2) = free e1 `union` free e2

{-@ topEval :: { v:Expr | Set_emp (free v) } -> Val @-}
topEval :: Expr -> Expr
topEval = eval emp

-- | Exercise 10.1 (Wellformedness Check)
{-@ evalAny :: Env -> Expr -> Maybe Val @-}
evalAny :: Map Var Expr -> Expr -> Maybe Expr
evalAny g e
  | ok = Just $ eval g e
  | otherwise = Nothing
  where
    ok = free e `isSubsetOf` keys g

-- test = [v2, v3]
--   where
--     -- v1 = topEval e1
--     v2 = topEval e2
--     v3 = topEval e3
--     e1 = (Var x) `Plus` c1
--     e2 = Let x c10 e1
--     e3 = App fun c1
--     x = "x"
--     c1 = Const 1
--     c10 = Const 10
--     fun = Fun x e1

-- | Exercise 10.2 (Closures)