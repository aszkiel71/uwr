open Ast

let parse (s : string) : expr =
    Parser.main Lexer.read (Lexing.from_string s)

let eval_op (op : bop) (v1 : float) (v2 : float) : float =
    match op with
    | Add -> v1 +. v2
    | Sub -> v1 -. v2
    | Mult -> v1 *. v2
    | Div -> v1 /. v2
    | Pow -> v1 ** v2 (*task6*)
    

let rec eval (e : expr) : float =
    match e with
    | Float f -> f
    | Binop (op, e1, e2) -> eval_op op (eval e1) (eval e2)
    | Log e -> log (eval e) (*task6*)   

let interp (s : string) : float =
    eval (parse s)
