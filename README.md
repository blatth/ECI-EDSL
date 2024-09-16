# Abordaje Funcional a EDSLs - ECI2024_N1 

## Recursos

- [learnyouakashell](https://learnyouahaskell.github.io/chapters.html)
- [Functors, Applicatives, And Monads In Pictures](https://www.adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html)
- [Three Useful Monads](https://www.adit.io/posts/2013-06-10-three-useful-monads.html)
- Explanation of Generalized Algebraic Data Types | [Video](https://vimeo.com/12208838) | [Texto](https://en.wikibooks.org/wiki/Haskell/GADT#Understanding_GADTs)


## Clases

| N° | Tema                                                                                                        | Código
|---|--------------------------------------------------------------------------------------------------------------|------------|
| 1 | [Repaso funcional - Intro EDSLs](https://github.com/blatth/ECI-EDSL/blob/main/Clases/Clase1.pdf)             | [Comb parsers](https://github.com/blatth/ECI-EDSL/blob/main/Clases/Clase1_comb_parsers.hs)
| 2 | [Parsers aplicativos - Functores aplicativos](https://github.com/blatth/ECI-EDSL/blob/main/Clases/Clase2.pdf)| [Parsing](https://github.com/blatth/ECI-EDSL/blob/main/Clases/Clase2_parsing.hs)
| 3 | [Mónadas - Parsers monádicos](https://github.com/blatth/ECI-EDSL/blob/main/Clases/Clase3.pdf)                | [Monadic parsing](https://github.com/blatth/ECI-EDSL/blob/main/Clases/Clase3_mon-parsing.hs)
| 4 | [Intérpretes Tagless-Final](https://github.com/blatth/ECI-EDSL/blob/main/Clases/Clase4.pdf)                  |
| 5 | [Deep-embeding en tipados - GADTs](https://github.com/blatth/ECI-EDSL/blob/main/Clases/Clase5.pdf)           |

## Evaluación

[Consigna del parcial](https://github.com/blatth/ECI-EDSL/blob/main/Evaluaci%C3%B3n/prueba.pdf)

| N°   | Resolución
|------|-----------------------------------------------------------------------------------------
| 1    | [Shallow embedding](https://github.com/blatth/ECI-EDSL/blob/main/Evaluaci%C3%B3n/ej1.hs)
| 2    | [Deep embedding](https://github.com/blatth/ECI-EDSL/blob/main/Evaluaci%C3%B3n/ej2.hs)
| 3 a 1| [Pp Shallow](https://github.com/blatth/ECI-EDSL/blob/main/Evaluaci%C3%B3n/ej3a1.hs)
| 3 a 2| [Pp Deep](https://github.com/blatth/ECI-EDSL/blob/main/Evaluaci%C3%B3n/ej3a2.hs)
| 3 b c| [Parser y UProp](https://github.com/blatth/ECI-EDSL/blob/main/Evaluaci%C3%B3n/ej3bc.hs)


## Breve resumen de la materia

Los lenguajes de programación de propósito general no siempre son adecuados para resolver problemas complejos: las soluciones pueden no ser claras y pueden requerir
conocimientos avanzados de programación. Una forma de resolver estos inconvenientes es a través de la definición de un lenguaje de dominio especı́fico (DSL: Domain Specific Language), que es un lenguaje hecho a la medida del dominio en que el problema se encuentra. Para evitar el trabajo de diseñar e implementar un lenguaje completamente nuevo para cada dominio, el DSL se puede implementar como una biblioteca del lenguaje «anfitrión». Los lenguajes de esta clase son llamados lenguajes de dominio especı́fico embebidos (EDSL: Embedded Domain Specific Languages). En este curso estudiaremos algunas técnicas de programación funcional que son muy útiles para el diseño e implementación de EDSLs. Este tipo de lenguajes son muy apropiados para la implementación de EDSLs, debido a la existencia de caracterıś ticas tales como los tipos de datos algebraicos, funciones de alto orden y sofisticados sistemas de tipos.

## Objetivos del curso

El objetivo de este curso es introducir a los estudiantes a los conceptos de DSL y EDSL, y presentar una serie de técnicas para el diseño e implementación de este tipo de lenguajes desde una perspectiva de programación funcional.

Programa
- Lenguajes de Dominio Especı́fico (DSL).
- Lenguajes de Dominio Especı́fico Embebidos (EDSL).
- Shallow embedding y deep embedding.
- Ejemplo de shallow embedding: parsers funcionales.
- Funtores aplicativos.
- Mónadas.
- Ejemplo de deep embedding: lenguaje de expresiones.

Prerrequisitos
Conocimientos básicos de programación funcional (preferiblemente en Haskell).

Bibliografía
- Gibbons, J. (2015). Functional Programming for Domain-Specific Languages. In: Zsók, V., Horváth, Z., Csató, L. (eds) Central European Functional Programming School. CEFP 2013. Lecture Notes in Computer Science(), vol 8606. Springer, Cham.
https://doi.org/10.1007/978-3-319-15940-9
- McBride, Conor and Paterson, Ross (2008). Applicative programming with effects. J. Funct. Program. 18, 1 (January 2008), 1–13.
- Wadler, P. (1995). Monads for Functional Programming. Advanced Functional Programming (p./pp. 24–52), London: Springer. ISBN: 3-540- 59451-5
- Graham Hutton and Erik Meijer. 1998. Monadic parsing in Haskell. J. Funct. Program. 8, 4 (July 1998), 437–444. https://doi.org/10.1017/S0956796898003050
- García-Garland, J., Pardo, A., Viera, M. (2019). Attribute grammars fly first-class… safer!: dealing with DSL errors in type-level programming. In Stutterheim, J. and Chin, W., editors, IFL ’19: Implementation and Application of Functional Languages, Singapore, September 25-27, 2019, pages 10:1–10:12. ACM.
- Kiselyov, O. (2010). Typed Tagless Final Interpreters. SSGIP 2010: 130-174
- Huttner, L., Merigoux, D. (2022) «Catala: Moving Towards the Future of Legal Expert Systems», Artif. Intell. Law.
