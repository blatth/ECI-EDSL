{-# LANGUAGE GADTs #-}
data Expr t where
    Val :: Int -> Expr Int
    Eq  :: Expr Int -> Expr Int -> Expr Bool
    Lt  :: Expr Int -> Expr Int -> Expr Bool
    Not :: Expr Bool -> Expr Bool
    And :: Expr Bool -> Expr Bool -> Expr Bool
    Or  :: Expr Bool -> Expr Bool -> Expr Bool

eval :: Expr t -> t
eval (Val n)     = n
eval (Eq e1 e2)  = eval e1 == eval e2
eval (Lt e1 e2)  = eval e1 < eval e2
eval (Not e)     = not (eval e)
eval (And e1 e2) = eval e1 && eval e2
eval (Or e1 e2)  = eval e1 || eval e2

-- Funciones de prueba
test1 = eval (Eq (Val 4) (Val 5))   -- -> False
test2 = eval (Or (Eq (Val 4) (Val 4)) (Eq (Val 4) (Val 6))) -- -> True
test3 = eval (Or (Not (Lt (Val 4) (Val 3))) (Eq (Val 4) (Val 4)))  -- -> True
test4 = eval (And (Not (Lt (Val 4) (Val 3))) (Or (Eq (Val 4) (Val 4)) (Lt (Val 4) (Val 2)))) -- -> True