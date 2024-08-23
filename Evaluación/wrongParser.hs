-- En la línea 106 está mi implementación, todo lo del principio son los parsers monádicos de clase que copié para reutilizar

import Control.Monad
import GHC.Base hiding ((<|>))

-- | Parser type 

newtype Parser a = P {runP :: String -> [(a,String)]}

instance Functor Parser where
  fmap f p = P $ \cs -> [(f a,cs') | (a,cs') <- runP p cs]

instance Applicative Parser where
  pure a =  P (\cs -> [(a,cs)])
  -- (<*>) ::  Parser (a -> b) -> Parser a -> Parser b
  (P p) <*> (P q) = P $ \cs -> [ (f a, cs'')  |  (f , cs')   <- p cs
                                              ,  (a , cs'')  <- q cs']

instance Monad Parser where
  return a    = P $ \cs -> [(a,cs)]
  (P p) >>= f = P $ \cs -> concat [runP (f a) cs' | (a,cs') <- p cs]

-- | Parsers primitivos

pFail :: Parser a
pFail = P $ \cs -> []

(<|>) :: Parser a -> Parser a -> Parser a
(P p) <|> (P q) = P $ \cs -> case p cs ++ q cs of
                              []     -> []
                              (x:xs) -> [x]

item :: Parser Char
item = P $ \cs -> case cs of
                    ""     -> []
                    (c:cs) -> [(c,cs)]

pSat :: (Char -> Bool) -> Parser Char
pSat p = do c <- item
            if p c then return c
                   else pFail

pSym :: Char -> Parser Char
pSym c = pSat (== c)

-- | p* (many) cero o más veces p

pList :: Parser a -> Parser [a]
pList p = do a <- p
             as <- pList p
             return (a:as)
          <|>
          return []

-- | p+ (some) una o más veces p

pListP :: Parser a -> Parser [a]
pListP p = do a <- p
              as <- pList p
              return (a:as)

-- | parsear una lista de dígitos

-- parsear un dígito y retornar el entero correspondiente
digit :: Parser Int
digit = do c <- pSat isDigit
           return (ord c - ord '0')

isDigit c = (c >= '0') && (c <= '9')

-- parsear una lista de dígitos no vacía
digits :: Parser [Int]
digits = pListP digit

-- sumar la lista de dígitos

sumDigits :: Parser Int
sumDigits = do ds <- digits
               return (sum ds)

-- suma de dígitos es par?
isEvenSumDs :: Parser Bool
isEvenSumDs = do n <- sumDigits
                 return (even n)
-- even n = n `mod` 2 == 0                

-- | reconocer un literal entero (reconoce una lista de dígitos 
-- | y retorna el entero que denota)

number :: Parser Int
number = do d <- digit
            number' d

number' :: Int -> Parser Int
number' n = do d <- digit
               number' (n*10 + d)
            <|>
            return n

-- Implementación Ej3 b

-- Parseo de espacios (consume los espacios en blanco)
pSpaces :: Parser ()
pSpaces = do
  _ <- pList (pSat isSpace)
  return ()

isSpace :: Char -> Bool
isSpace c = c `elem` [' ', '\t', '\n']

-- Parser auxiliar para reconocer palabras clave
pToken :: String -> Parser String
pToken []     = return []
pToken (c:cs) = do
  pSpaces
  pSym c
  pToken cs
  return (c:cs)

-- Parsers
data Expr = Val Int 
          | Eq Expr Expr
          | Lt Expr Expr
          | Not Expr
          | And Expr Expr
          | Or Expr Expr
          deriving Show

pVal :: Parser Expr
pVal = do
  pToken "val"
  pSpaces
  n <- number
  return (Val n)

pEq :: Parser Expr
pEq = do
  pToken "eq"
  pSpaces
  e1 <- expr
  e2 <- expr
  return (Eq e1 e2)

pLt :: Parser Expr
pLt = do
  pToken "lt"
  pSpaces
  e1 <- expr
  e2 <- expr
  return (Lt e1 e2)

pNot :: Parser Expr
pNot = do
  pToken "not"
  pSpaces
  e <- expr
  return (Not e)

pAnd :: Parser Expr
pAnd = do
  pToken "and"
  pSpaces
  e1 <- expr
  e2 <- expr
  return (And e1 e2)

pOr :: Parser Expr
pOr = do
  pToken "or"
  pSpaces
  e1 <- expr
  e2 <- expr
  return (Or e1 e2)

expr :: Parser Expr
expr = do
  pSpaces
  pVal
  <|> pEq
  <|> pLt
  <|> pNot
  <|> pAnd
  <|> pOr

-- Funciones de prueba
test1 = runP expr "val 5" -- -> [(Val 5,"")]
test2 = runP expr "eq val 3 val 4" -- -> [(Eq (Val 3) (Val 4),"")]
test3 = runP expr "not val 1" -- -> [(Not (Val 1),"")]
test4 = runP expr "and eq val 4 val 4 lt val 1 val 2" -- -> [(And (Eq (Val 4) (Val 4)) (Lt (Val 1) (Val 2)),"")]
test5 = runP expr "or eq val 4 val 4 lt val 1 val 2" -- -> [(And (Eq (Val 4) (Val 4)) (Lt (Val 1) (Val 2)),"")]