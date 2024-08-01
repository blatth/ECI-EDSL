## **Functores**
Cosas que pueden ser mapeadas, como listas, Maybes, árboles y cosas del estilo. Son descritos como _typeclass Functor_, con un sólo typeclass method:

`fmap :: (a -> b) -> f a -> f b`

Es algo así como: dame una función que tome un a y devuelva un b y una caja con un a (o varias de ellos) dentro y te doy una caja con un b (o varias de ellos) dentro. De alguna manera aplica la función al elemento dentro de la caja, convirtiéndolo.
Si queremos hacer de un constructor de tipo una instancia de Functor, tiene que tener un tipo * -> * , lo que significa que tiene que tomar exactamente un tipo concreto como parámetro de tipo. Por ejemplo, Maybe puede convertirse en una instancia porque toma un parámetro de tipo para producir un tipo concreto, como Maybe Int o Maybe String. **Si un constructor de tipo toma dos parámetros, como Either, tenemos que aplicar parcialmente el constructor de tipo hasta que sólo tome un parámetro de tipo**.

- La función `pure` toma un valor y lo coloca dentro del contexto functorial, mientras que `<*>` toma una función dentro del contexto y un valor dentro del contexto, y aplica la función al valor, manteniendo el contexto.
- La función `<$>` es simplemente una sinónimo de `fmap`:
	**Aplicación a un valor 'Maybe':**
	`fmap (+1) (Just 5)  -- Just 6`
	`(+1) <$> (Just 5)   -- Just 6`
	
	**Aplicación a una función binaria usando `<$>` y `<*>`:***
	`addE :: Maybe Int -> Maybe Int -> Maybe Int`
	`addE x y = (+) <$> x <*> y`
	
	`addE (Just 3) (Just 5) -- Just 8`
	
	`addE` toma dos valores `Maybe Int` y aplica la función `(+)` a ambos. Primero, `<$>` aplica la función `(+)` al primer valor, resultando en `Just (3 +)`, y después `<*>` aplica la función parcialmente aplicada al segundo valor.
	
	**Aplicación de `divE`y `divM`:**
	
	`divM :: Int -> Int -> Maybe Int`
	`divM x y | y /= 0    = Just (x `div` y)`
	     `    | otherwise = Nothing`
	     
	`divE :: Maybe Int -> Maybe Int -> Maybe Int`
	`divE x y = case (x, y) of`
				`(Just vx, Just vy) -> divM vx vy`
							     `_ -> Nothing`
	
	`divE (Just 10) (Just 2) -- Just 5`
	`divE (Just 10) (Just 0) -- Nothing`
	`divE Nothing (Just 2) -- Nothing`
	`divE (Just 10) Nothing -- Nothing`
	
	`divE` utiliza `divM`  para hacer divisiones **seguras**. Si ambos valores son Just, devuelve un Just llamando a divM. Si cualquiera de los dos valores es un Nothing, devuelve Nothing

## Mónadas
Los mónadas son un subconjunto de los functores aplicativos.
En mónadas se ejecutan solamente aquellas computaciones que son _válidas_ (a diferencia de Applicative que ejecuta _todas_ las computaciones)

`sumnd :: Num a => [a] -> [a] -> [a]`
`sumnd xs ys do` x <- xs
				`y <- ys`
				 `return (x + y)`

Agarro cada `x `en `xs` y por cada uno que agarro, agarro un `y` en `ys`. Por cada uno, sumo `x+y` y lo pongo en una lista como elemento único. Se van generando listas para cada suma y las concateno todas en una sola. Al final, me devuelve una lista de sumas de cada valor de x con cada uno de y.

**Do notation** me ahorra de escribir lambdas y con ellos genero secuencias (tiene una noción un poco imperativa). Toda línea _dentro de un do_ es un valor monádico.
[Explicación más clara, con ejemplos](https://learnyouahaskell.com/a-fistful-of-monads#do-notation)
