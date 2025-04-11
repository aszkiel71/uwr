open Ast

let parse (s : string) : expr =
  Parser.main Lexer.read (Lexing.from_string s)

type value =
  | VInt of int
  | VBool of bool
  | VPair of value * value
  | VUnit of unit

let eval_op (op : bop) (val1 : value) (val2 : value) : value =
  match op, val1, val2 with
  | Add,  VInt  v1, VInt  v2 -> VInt  (v1 + v2)
  | Sub,  VInt  v1, VInt  v2 -> VInt  (v1 - v2)
  | Mult, VInt  v1, VInt  v2 -> VInt  (v1 * v2)
  | Div,  VInt  v1, VInt  v2 -> VInt  (v1 / v2)
  | And,  VBool v1, VBool v2 -> VBool (v1 && v2)
  | Or,   VBool v1, VBool v2 -> VBool (v1 || v2)
  | Leq,  VInt  v1, VInt  v2 -> VBool (v1 <= v2)
  | Eq,   _,        _        -> VBool (val1 = val2)
  | _,    _,        _        -> failwith "type error"

let rec subst (x : ident) (s : expr) (e : expr) : expr =
  match e with
  | Binop (op, e1, e2) -> Binop (op, subst x s e1, subst x s e2)
  | If (b, t, e) -> If (subst x s b, subst x s t, subst x s e)
  | Pair (one,two) -> Pair (subst x s one, subst x s two)
  | Var y -> if x = y then s else e
  | Let (y, e1, e2) ->
      Let (y, subst x s e1, if x = y then e2 else subst x s e2)
  | _ -> e

let rec reify (v : value) : expr =
  match v with
  | VInt a -> Int a
  | VBool b -> Bool b
  | VUnit u -> Unit u
  | VPair (a,b) -> Pair (reify a, reify b)

let eval_uop (op: uop) (e: value) : value = match op, e with
|  Fst, VPair(e,_) -> e
|  Snd, VPair(_, e) -> e 
| _,_ -> failwith "type error"

let rec eval (e : expr) : value =
  match e with
  | Unit () -> VUnit ()
  | Int i -> VInt i
  | Bool b -> VBool b
  | Pair (one, two) -> VPair (eval one, eval two)
  | Uop (op, e) -> eval_uop op (eval e)
  | Binop (op, e1, e2) ->
      eval_op op (eval e1) (eval e2)
  | If (b, t, e) ->
      (match eval b with
           | VBool true -> eval t
           | VBool false -> eval e
           | _ -> failwith "type error")
  | Let (x, e1, e2) ->
      eval (subst x (reify (eval e1)) e2)
      
  | Match(e1,x1,x2,e2) ->( match (reify (eval e1)) with
    | Pair(a,b) -> eval (subst x1 a (subst x2 b e2)) 
    | _ -> failwith "expected pair")
  
  | Var x -> failwith ("unknown var " ^ x)

  


let interp (s : string) : value =
  eval (parse s)
