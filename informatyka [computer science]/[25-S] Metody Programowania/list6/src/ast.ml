type bop =
  | Add | Sub | Mult | Div
  | And | Or
  | Eq | Leq

type ident = string

type uop = Fst | Snd

type expr = 
  | Int   of int
  | Binop of bop * expr * expr
  | Bool  of bool
  | If    of expr * expr * expr
  | Let   of ident * expr * expr
  | Var   of ident
  | Match of expr * ident * ident * expr
  | Sum of ident * expr * expr * expr

  | Pair of expr * expr
  | Uop of uop * expr
  | Unit of unit
