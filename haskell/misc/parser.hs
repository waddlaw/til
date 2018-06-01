module Parser () where

import Control.Applicative (Alternative(..))
import Data.Char (isDigit, isLower, isUpper, isAlpha, isAlphaNum, isSpace)

data Parser a = Parser { runParser :: String -> Maybe (a, String) }

instance Functor Parser where
  fmap f p = Parser $ \inp ->
    case parse p inp of
      Just (a, rest) -> Just (f a, rest)
      _ -> Nothing

instance Applicative Parser where
  pure v = Parser $ \inp -> Just (v, inp)
  p <*> q = Parser $ \inp ->
    case parse p inp of
      Just (f, rest) -> case parse q rest of
        Just (a, rest') -> Just (f a, rest')
        _ -> Nothing
      _ -> Nothing

instance Alternative Parser where
  empty = Parser $ \inp -> Nothing
  p <|> q = Parser $ \inp ->
    case parse p inp of
      Nothing -> parse q inp
      just -> just

instance Monad Parser where
  fail _ = Parser $ \inp -> Nothing
  p >>= f = Parser $ \inp ->
    case parse p inp of
      Just (v, out) -> parse (f v) out
      _ -> Nothing

item :: Parser Char
item = Parser $ \inp ->
  case inp of
    [] -> Nothing
    (x:xs) -> Just (x, xs)

parse :: Parser a -> String -> Maybe (a, String)
parse = runParser

p :: Parser (Char, Char)
p = (,) <$> item <* item <*> item
{-
p = do
  x <- item
  item
  y <- item
  return (x, y)
-}

sat :: (Char -> Bool) -> Parser Char
sat p = do
  x <- item
  if p x then return x else fail ""

digit, lower, upper, letter, alphanum :: Parser Char
digit = sat isDigit
lower = sat isLower
upper = sat isUpper
letter = sat isAlpha
alphanum = sat isAlphaNum

char :: Char -> Parser Char
char x = sat (==x)

string :: String -> Parser String
string [] = return []
string (x:xs) = (:) <$> char x <*> string xs
{-
string (x:xs) = do
  char x
  string xs
  return (x:xs)
-}

ident :: Parser String
ident = (:) <$> lower <*> many alphanum
-- ident = do
--   x <- lower
--   xs <- many alphanum
--   return (x:xs)

nat :: Parser Int
nat = read <$> some digit
-- nat = do
--   xs <- some digit
--   return (read xs)

space :: Parser ()
space = const () <$> many (sat isSpace)
-- space = do
--   many (sat isSpace)
--   return ()

token :: Parser a -> Parser a
token p = id <$> space *> p <* space
-- token p = do
--   space
--   v <- p
--   space
--   return v

identifier :: Parser String
identifier = token ident

natural :: Parser Int
natural = token nat

symbol :: String -> Parser String
symbol xs = token (string xs)

--p' :: Parser [Int]
p' = undefined <$> symbol "[" *> ((:) <$> natural <*> many (symbol "," >> natural)) <* symbol "]"
-- p' = do
--   symbol "["
--   n <- natural
--   ns <- many (do
--     symbol ","
--     natural)
--   symbol "]"
--   return (n:ns)

p3 = undefined

-- parse (many digit) ""
-- runParser (many digit) ""
-- many digit $ ""
-- some digit <|> pure [] $ ""
-- (:) <$> digit <*> (some digit <|> pure []) <|> pure [] $ ""
--
-- <$> :: (a -> b) -> f a -> f b
-- <*> :: f (a -> b) -> f a -> f b
-- (*>) :: f a -> f b -> f b
-- (:) <$> :: f a -> f ([a] -> [a])
-- (:) <$> digit :: f (String -> String)
-- ((f <$> m1) <*> m2) <*> m3

-- (:) <$> symbol "[" :: Parser ([String] -> [String])
-- (:) <$> symbol "[" *> :: Parser b -> Parser b
-- (:) <$> symbol "[" *> natural :: Parser Int
-- (:) <$> symbol "[" *> natural <*> ::

data Expr a = Plus (Term a) (Expr a) | Term (Term a) deriving (Eq, Show)
data Term a = Mult (Factor a) (Term a) | Factor (Factor a) deriving (Eq, Show)
data Factor a = Paren (Expr a) | Nat Int deriving (Eq, Show)

expr :: Parser (Expr a)
expr = do
  t <- term
  (do
    symbol "+"
    e <- expr
    return (Plus t e)) <|> return (Term t)

term :: Parser (Term a)
term = do
  f <- factor
  (do
    symbol "*"
    t <- term
    return (Mult f t)) <|> return (Factor f)

factor :: Parser (Factor a)
factor = factor' <|> natural'

factor' = do
  symbol "("
  e <- expr
  symbol ")"
  return (Paren e)

natural' :: Parser (Factor a)
natural' = token nat'

nat' :: Parser (Factor a)
nat' = (Nat . read) <$> some digit


eval :: String -> Int
eval xs = case parse expr xs of
  Just (n, []) -> evalExpr n
  Just (_, out) -> error ("unused input " ++ out)
  _ -> error "invalid input"

evalExpr :: Expr a -> Int
evalExpr (Plus t e) = evalTerm t + evalExpr e
evalExpr (Term t) = evalTerm t

evalTerm :: Term a -> Int
evalTerm (Mult f t) = evalFactor f * evalTerm t
evalTerm (Factor f) = evalFactor f

evalFactor :: Factor a -> Int
evalFactor (Paren e) = evalExpr e
evalFactor (Nat n) = n
