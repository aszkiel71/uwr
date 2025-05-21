type typ =
  | TUnit
  | TInt
  | TBool
  | TPair  of typ * typ
  | TArrow of typ * typ

type bop =
  (* arithmetic *)
  | Add | Sub | Mult | Div
  (* logic *)
  | And | Or
  (* comparison *)
  | Eq | Neq | Leq | Lt | Geq | Gt

type ident = string

type 'a node =
  { data : 'a
  ; pos  : Lexing.position * Lexing.position
  }

type expr = expr_data node
and expr_data =
  | Unit
  | Int    of int
  | Bool   of bool
  | Var    of ident
  | Binop  of bop * expr * expr
  | If     of expr * expr * expr
  | Let    of ident * expr * expr
  | Pair   of expr * expr
  | App    of expr * expr
  | Fst    of expr
  | Snd    of expr
  | Fun    of ident * typ * expr
  | Funrec of ident * ident * typ * typ * expr
