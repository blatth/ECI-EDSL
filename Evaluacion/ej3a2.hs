{-# LANGUAGE GADTs #-}

data Expr t where
    Val :: Int -> Expr Int
    Eq  :: Expr Int -> Expr Int -> Expr Bool
    Lt  :: Expr Int -> Expr Int -> Expr Bool
    Not :: Expr Bool -> Expr Bool
    And :: Expr Bool -> Expr Bool -> Expr Bool
    Or  :: Expr Bool -> Expr Bool -> Expr Bool


pPExpr :: Expr t -> String
pPExpr (Val n)     = show n
pPExpr (Eq e1 e2)  = "(" ++ pPExpr e1 ++ " = " ++ pPExpr e2 ++ ")"
pPExpr (Lt e1 e2)  = "(" ++ pPExpr e1 ++ " < " ++ pPExpr e2 ++ ")"
pPExpr (Not e)     = "∼ (" ++ pPExpr e ++ ")"
pPExpr (And e1 e2) = "(" ++ pPExpr e1 ++ " /\\ " ++ pPExpr e2 ++ ")"
pPExpr (Or e1 e2)  = "(" ++ pPExpr e1 ++ " \\/ " ++ pPExpr e2 ++ ")"

-- Funciones de prueba
test1 = pPExpr (Eq (Val 4) (Val 5))   -- -> "(4 = 5)"
test2 = pPExpr (Or (Eq (Val 4) (Val 4)) (Eq (Val 4) (Val 6))) -- -> -> "((~(4 < 3)) \/ (4 = 4))"
test3 = pPExpr (Or (Not (Lt (Val 4) (Val 3))) (Eq (Val 4) (Val 4)))  -- -> "((~(4 < 3)) /\ (4 = 4))"
test4 = pPExpr (And (Not (Lt (Val 4) (Val 3))) (Or (Eq (Val 4) (Val 4)) (Lt (Val 4) (Val 2)))) -- -> "(~ ((4 < 3)) /\\ ((4 = 4) \\/ (4 < 2)))"