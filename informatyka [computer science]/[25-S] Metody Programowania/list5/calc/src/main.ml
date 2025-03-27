open Ast

let parse (s : string) : expr =
    Parser.main Lexer.read (Lexing.from_string s)

let eval_op (op : bop) (v1 : int) (v2 : int) : int =
    match op with
    | Add -> v1 + v2
    | Sub -> v1 - v2
    | Mult -> v1 * v2
    | Div -> v1 / v2

let rec eval (e : expr) : int =
    match e with
    | Int i -> i
    | Binop (op, e1, e2) -> eval_op op (eval e1) (eval e2)

let interp (s : string) : int =
    eval (parse s)

