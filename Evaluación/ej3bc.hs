-- Mi resolución comienza en la línea 62. Lo del principio es el código reutilizado de clase que copié.

import Control.Monad
import Data.Char (isDigit, ord)

-- | Parser type
newtype Parser a = P { runP :: String -> [(a, String)] }

instance Functor Parser where
  fmap f p = P $ \cs -> [(f a, cs') | (a, cs') <- runP p cs]

instance Applicative Parser where
  pure a = P $ \cs -> [(a, cs)]
  (P p) <*> (P q) = P $ \cs -> [(f a, cs'') | (f, cs') <- p cs, (a, cs'') <- q cs']

instance Monad Parser where
  return a = P $ \cs -> [(a, cs)]
  (P p) >>= f = P $ \cs -> concat [runP (f a) cs' | (a, cs') <- p cs]

-- | Parsers primitivos

pFail :: Parser a
pFail = P $ \_ -> []

(<|>) :: Parser a -> Parser a -> Parser a
(P p) <|> (P q) = P $ \cs -> case p cs ++ q cs of
                              [] -> []
                              (x:_) -> [x]

item :: Parser Char
item = P $ \cs -> case cs of
                    "" -> []
                    (c:cs') -> [(c, cs')]

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

-- | parsear un dígito y retornar el entero correspondiente
digit :: Parser Int
digit = do c <- pSat isDigit
           return (ord c - ord '0')

-- Implementación 3b y 3c

data UProp
    = UAnd UProp UProp
    | UOr UProp UProp
    | UNot UProp
    | UEq UProp UProp
    | ULt UProp UProp
    | UVal Int
    deriving (Show, Eq)

-- Ignora espacions en blanco
pSpaces :: Parser String
pSpaces = pList (pSat (== ' '))

-- Parser que ignora espacios en blanco antes y después de parsear un valor
token :: Parser a -> Parser a
token p = do _ <- pSpaces
             v <- p
             _ <- pSpaces
             return v

-- Parser enteros
pInt :: Parser Int
pInt = token $ do digits <- pListP digit
                  return (foldl (\acc x -> acc * 10 + x) 0 digits)

-- Parser UVal
pVal :: Parser UProp
pVal = do n <- pInt
          return (UVal n)

-- Parser igualdad
pEq :: Parser UProp
pEq = do _ <- token (pSym '(')
         p1 <- pProp
         _ <- token (pSym '=')
         p2 <- pProp
         _ <- token (pSym ')')
         return (UEq p1 p2)

-- Parser menor
pLt :: Parser UProp
pLt = do _ <- token (pSym '(')
         p1 <- pProp
         _ <- token (pSym '<')
         p2 <- pProp
         _ <- token (pSym ')')
         return (ULt p1 p2)

-- Parser negación
pNot :: Parser UProp
pNot = do _ <- token (pSym '∼')
          p <- pProp
          return (UNot p)

-- Parser factores (expresiones entre paréntesis)
pFactor :: Parser UProp
pFactor = pVal <|> pEq <|> pLt <|> pNot <|> do
              _ <- token (pSym '(')
              p <- pProp
              _ <- token (pSym ')')
              return p

-- Parser conjunción
pAnd :: Parser UProp
pAnd = chainl1 pFactor (token (pSym '/' >> pSym '\\') >> return UAnd)

-- Parser disyunción
pOr :: Parser UProp
pOr = chainl1 pAnd (token (pSym '\\' >> pSym '/') >> return UOr)

-- Auxiliar para manejar asociatividad izquierda
chainl1 :: Parser a -> Parser (a -> a -> a) -> Parser a
chainl1 p op = do x <- p
                  rest x
    where rest x = (do f <- op
                       y <- p
                       rest (f x y))
                    <|> return x

-- Parser proposición (solamente llama a las demás)
pProp :: Parser UProp
pProp = pOr

-- Función para ejecutar el parser
runParser :: String -> UProp
runParser input = case runP (token pProp) input of
                    [(result, "")] -> result
                    _              -> error "Error de parseo"

-- Funciones de testo

test0 = runParser "1517815615461652" -- -> UVal 1517815615461652
test1 = runParser "(5 < 10)" -- -> ULt (UVal 5) (UVal 10)
test2 = runParser "(5 < 10) /\\ (5 = 5)" -- -> UAnd (ULt (UVal 5) (UVal 10)) (UEq (UVal 5) (UVal 5))
test3 = runParser "((5 = 5) /\\ (3 < 4)) \\/ (2 = 2)" -- -> UOr (UAnd (UEq (UVal 5) (UVal 5)) (ULt (UVal 3) (UVal 4))) (UEq (UVal 2) (UVal 2))
test4 = runParser "∼(5 < 10) \\/ (3 < 4)" -- -> UOr (UNot (ULt (UVal 5) (UVal 10))) (ULt (UVal 3) (UVal 4))
test5 = runParser "∼(((5 = 5) \\/ ∼(2 < 1)) /\\ ((3 < 4) \\/ (7 = 7)))" -- -> UNot (UAnd (UOr (UEq (UVal 5) (UVal 5)) (UNot (ULt (UVal 2) (UVal 1)))) (UOr (ULt (UVal 3) (UVal 4)) (UEq (UVal 7) (UVal 7))))
test6 = runParser " (  ∼ ( 5  <  10 )  \\/  (  3  <  4  ) )  /\\  ( 7  = 7 ) " -- -> UAnd (UOr (UNot (ULt (UVal 5) (UVal 10))) (ULt (UVal 3) (UVal 4))) (UEq (UVal 7) (UVal 7))
