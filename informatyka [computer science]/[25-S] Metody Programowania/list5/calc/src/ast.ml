type bop = Add | Sub | Mult | Div

type expr = 
    | Int of int
    | Binop of bop * expr * expr
