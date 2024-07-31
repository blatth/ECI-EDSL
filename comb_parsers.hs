import Prelude hiding ((<*>))
-- CLASE 1

numeros = [1..100]

pares = filter (\x -> x `mod` 2 == 0) numeros

-- Lista de números
-- numeros = [1, 2, 3, 4, 5]

-- Usando la función filter con una expresión lambda para filtrar números pares
-- pares = filter (\x -> x `mod` 2 == 0) numeros

-- pares será [2, 4]

-----------------------

type Parser s a = Eq s => [s] -> [(a, [s])]

-- COMBINADORES

-- pFail: Dado un valor cualquiera, siempre devuelve []

{-
pFail :: Parser s a
pFail = \cs -> []
-}

pFail :: Parser s a
pFail cs = []

-- pSucceed: Dado un valor cualquiera, devuelve siempre ese valor con el input (cs) sin consumirlo. 

{-
Implementación de clase

pSucceed :: a -> Parser s a
pSucceed a = \cs -> [(a, cs)]
-}

pSucceed :: a -> Parser s a
pSucceed a cs = [(a, cs)]

-- pSym: Dado un valor cualquiera, se fija si ese valor es == al primero de la lista cs. De ser así, lo consume y devuelve lo restante. Sino, devuelve []

{- 
Implementación de clase:

pSym :: Eq s => s -> Parser s s
pSym s = \cs -> case cs of
  [] -> []
  (c : cs') -> if c == s
    then [(c, cs')]
    else []
-}

-- Implementación
pSym :: Eq s => s -> Parser s s
pSym s = parser
  where
    parser [] = []
    parser (c:cs') = if c == s
                     then [(c, cs')]
                     else []

-- <|>

(<|>) :: Parser s a -> Parser s a -> Parser s a
p <|> q = \cs -> p cs ++ q cs

-- <**> (igual a <**>). Implementé la aplicación de funciones así porque había conflicto con algo del prelude

(<**>) :: Parser s (a -> b) -> Parser s a -> Parser s b
(p <**> q) cs = [(f a, cs'') | (f, cs') <- p cs, (a, cs'') <- q cs']  

-- Parsers: ejemplos

-- Cuando detecta un 'A' al principio, lo cambia por un B
pA2B = pSucceed (\_ -> 'B') <**> pSym 'A'

-- Reconoce una 'A' seguida de una 'B' al principio y retorna ambos caracteres en un par.
pAB = pSucceed (,) <**> pSym 'A' <**> pSym 'B'

-- Retorna una lista de valores de tipo a, tomando como parámetro un parser que retorna un a

pList :: Parser s a -> Parser s [a]
pList p = pSucceed (:) <**> p <**> pList p <|> pSucceed []

-- Reconoce un string de la forma AB

pListAB = pList pAB

{-
Este último, al hacer pListAB "AB" -> [([('A','B')],""),([],"AB")]
                      pListAB "ABAB" -> [([('A','B'),('A','B')],""),([('A','B')],"AB"),([],"ABAB")]
Preguntar si está bien (creo que no)
-}