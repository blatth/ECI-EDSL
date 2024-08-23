import Prelude hiding (not, and, or)

class EDSL repr where
    val :: Int -> repr Int
    eq  :: repr Int -> repr Int -> repr Bool
    lt  :: repr Int -> repr Int -> repr Bool
    not :: repr Bool -> repr Bool
    and :: repr Bool -> repr Bool -> repr Bool
    or  :: repr Bool -> repr Bool -> repr Bool

newtype R a = R { unR :: a }

instance EDSL R where
    val n             = R n
    eq  (R x) (R y)   = R (x == y)
    lt  (R x) (R y)   = R (x < y)
    not (R b)         = R (if b then False else True)
    and (R b1) (R b2) = R (b1 && b2)
    or  (R b1) (R b2) = R (b1 || b2)

-- Funciones de prueba
test1 = unR $ eq (val 4) (val 5)   -- -> False
test2 = unR $ or (not (lt (val 4) (val 3))) (eq (val 4) (val 4))  -- -> True
test3 = unR $ and (not (lt (val 4) (val 3))) (eq (val 4) (val 4))  -- -> True
test4 = unR $ and (not (lt (val 4) (val 3))) (or (eq (val 4) (val 4)) (lt (val 4) (val 2))) -- -> True