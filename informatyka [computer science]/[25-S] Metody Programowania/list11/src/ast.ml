type var = string

type expr =
  | Unit
  | Int     of int
  | Bool    of bool
  | Var     of var
  | If      of expr * expr * expr
  | Let     of var * expr * expr
  | App     of expr * expr
  | Pair    of expr * expr
  | Fun     of var * expr
  | Funrec  of var * var * expr
  | Builtin of string
