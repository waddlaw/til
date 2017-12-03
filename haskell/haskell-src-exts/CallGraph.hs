module CallGraph (extractGraphFromDecls) where

import Language.Haskell.Exts
import Data.Generics.Uniplate.Data (universeBi)
import Data.List (nub, (\\))
import Data.Maybe (mapMaybe, catMaybes)

type CallGraph = [FunctionCall]
type FunctionCall = (FuncName, [FuncName])
type FuncName = String

-- | partial functions
partials :: [FuncName]
partials = ["head", "last"]

extractGraphFromDecls :: [Decl SrcSpanInfo] -> CallGraph
extractGraphFromDecls = mapMaybe genCallGraph

genCallGraph :: Decl SrcSpanInfo -> Maybe FunctionCall
genCallGraph (PatBind _ pat rhs _) = constructFunctionCall (getName pat, getCallee rhs)
genCallGraph (FunBind _ matches) = constructFunctionCall (getName $ head matches, fvs)
  where
    fvs = vs \\ bs
    -- bound variables
    bs = mapMaybe getName $ concatMap getPat matches
    -- all variables
    vs = nub $ concatMap (getCallee . getRhs) matches
genCallGraph _ = Nothing

constructFunctionCall :: (Maybe FuncName, [FuncName]) -> Maybe FunctionCall
constructFunctionCall (mCaller, rhs) = do
  caller <- mCaller
  callee <- pure rhs
  return (caller, callee)

getCallee :: Rhs SrcSpanInfo -> [FuncName]
getCallee (UnGuardedRhs _ expr) = freeVars expr
getCallee (GuardedRhss _ guards) = concatMap (freeVars . getExp) guards

freeVars :: Exp SrcSpanInfo -> [FuncName]
freeVars expr = catMaybes qns
  where
    qns = [getName qname | Var _ qname <- universeBi expr :: [Exp SrcSpanInfo]]

-- | helper functions
getExp :: GuardedRhs SrcSpanInfo -> Exp SrcSpanInfo
getExp (GuardedRhs _ _ expr) = expr

getRhs :: Match SrcSpanInfo -> Rhs SrcSpanInfo
getRhs (Match _ _ _ rhs _) = rhs
getRhs (InfixMatch _ _ _ _ rhs _) = rhs

getPat :: Match SrcSpanInfo -> [Pat SrcSpanInfo]
getPat (Match _ _ pats _ _) = pats
getPat (InfixMatch _ _ _ pats _ _) = pats

-- | fake generics
class Getter a where
  getName :: a -> Maybe String
  getName _ = Nothing

instance Getter (Pat a) where
  getName (PVar _ name) = getName name
  getName _ = Nothing

instance Getter (Match a) where
  getName (Match _ name _ _ _) = getName name
  getName (InfixMatch _ _ name _ _ _) = getName name

instance Getter (QName a) where
  getName (Qual _ _ name) = getName name
  getName (UnQual _ name) = getName name
  getName _ = Nothing

instance Getter (Name a) where
  getName (Ident _ str) = Just str
  getName (Symbol _ str) = Just str

-- entry point
main :: IO ()
main = do
  (Module _ _ _ _ decls) <- fromParseResult <$> parseFile "test/examples/Ex.hs"
  print $ extractGraphFromDecls decls
