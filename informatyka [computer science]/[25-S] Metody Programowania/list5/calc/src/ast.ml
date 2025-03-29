type bop = Add | Sub | Mult | Div | Pow (*task6*)

type expr = 
    | Float of float  (* - - - *)
    | Binop of bop * expr * expr
    | Log of expr (*task6*)
    | Const of float (*task6*)