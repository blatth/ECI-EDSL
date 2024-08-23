import Prelude hiding (not, and, or)

class EDSL repr where
    val :: Int -> repr Int
    eq  :: repr Int -> repr Int -> repr Bool
    lt  :: repr Int -> repr Int -> repr Bool
    not :: repr Bool -> repr Bool
    and :: repr Bool -> repr Bool -> repr Bool
    or  :: repr Bool -> repr Bool -> repr Bool

newtype Pretty a = Pretty { pP :: String }

instance EDSL Pretty where
    val n                       = Pretty (show n)
    eq  (Pretty e1) (Pretty e2) = Pretty ("(" ++ e1 ++ " = " ++ e2 ++ ")")
    lt  (Pretty e1) (Pretty e2) = Pretty ("(" ++ e1 ++ " < " ++ e2 ++ ")")
    not (Pretty e)              = Pretty ("∼ (" ++ e ++ ")")
    and (Pretty e1) (Pretty e2) = Pretty ("(" ++ e1 ++ " /\\ " ++ e2 ++ ")")
    or  (Pretty e1) (Pretty e2) = Pretty ("(" ++ e1 ++ " \\/ " ++ e2 ++ ")")

instance Show (Pretty a) where
    show (Pretty s) = show s

-- Funciones de prueba
test1 = pP $ eq (val 4) (val 5)   -- -> "(4 = 5)"

test2 = pP $ or (not (lt (val 4) (val 3))) (eq (val 4) (val 4))  -- -> "((~ (4 < 3)) \/ (4 = 4))"

test3 = pP $ and (not (lt (val 4) (val 3))) (eq (val 4) (val 4))  -- -> "((~ (4 < 3)) /\ (4 = 4))"
test4 = pP $ and (not (lt (val 4) (val 3))) (or (eq (val 4) (val 4)) (lt (val 4) (val 2))) -- -> "(~ ((4 < 3)) /\\ ((4 = 4) \\/ (4 < 2)))"