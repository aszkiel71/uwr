type bop = Add | Sub | Mult | Div

type expr = 
    | Float of float  (* - - - *)
    | Binop of bop * expr * expr
