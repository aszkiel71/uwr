type expr =
    | Int of int
    | Bool of bool
    | Var of string
    | Add of expr * expr
    | Sub of expr * expr
    | Mult of expr * expr
    | Div of expr * expr
    | Lt of expr * expr
    | Gt of expr * expr
    | Let of string * expr * expr
    | Fun of string * expr
    | App of expr * expr
    | Or of expr * expr
    | Not of expr
    | FunRec of string * string * expr
    | Pair of expr * expr
    | Fst of expr
    | Snd of expr
    | Ref of expr
    | Deref of expr
    | Assign of expr * expr
    | Fix of string * expr
    | TryCatch of expr * expr

type value =
    | VInt of int
    | VBool of bool
    | VPair of value * value
    | VClosure of string * expr * env
    | VRecClosure of string * string * expr * env
    | VRef of int
and env = (string * value) list
and store = (int * value) list

let counter = ref 0
let fresh_loc () = let l = !counter in counter := !counter + 1; l

let rec lookup_env k env =
    match env with
    | (ky, v) :: rest -> if ky = k then v else lookup_env k rest
    | [] -> failwith "not found"

let rec eval e env stk =
    match e with
    | Int i -> (VInt i, stk)
    | Bool b -> (VBool b, stk)
    | Var s -> (lookup_env s env, stk)
    | Add(e1, e2) -> (match eval e1 env stk, eval e2 env stk with
                | (VInt x, s1), (VInt y, s2) -> (VInt (x + y), s2)
                | _ -> failwith "expected 2 ints."
                )
    | Sub(e1, e2) -> (match eval e1 env stk, eval e2 env stk with
                | (VInt x, s1), (VInt y, s2) -> (VInt (x - y), s2)
                | _ -> failwith "expected 2 ints."
                )
    | Mul(e1, e2) -> (match eval e1 env stk, eval e2 env stk with
                | (VInt x, s1), (VInt y, s2) -> (VInt (x * y), s2)
                | _ -> failwith "expected 2 ints."
                )
    | Div(e1, e2) -> (match eval e1 env stk, eval e2 env stk with
                | (VInt x, s1), (VInt 0, s2) -> (failwith "cannot divide by zero")
                | (VInt x, s1), (VInt y, s2) -> (VInt (x - y), s2)
                | _ -> failwith "expected 2 ints."
                )
    | Lt(e1, e2) -> (match eval e1 env stk, eval e2 env stk with
                | (VInt x, s1), (VInt y, s2) -> (VBool (x < y), s2)
                | _ -> failwith "expected 2 ints."
                )
    | Gt(e1, e2) -> (match eval e1 env stk, eval e2 env stk with
                | (VInt x, s1), (VInt y, s2) -> (VBool (x > y), s2)
                | _ -> failwith "expected 2 ints."
                )
    | Or(e1, e2) -> (match eval e1 env stk, eval e2 env stk with
                | (VInt x, s1), (VInt y, s2) -> (VBool (x || y), s2)
                | _ -> failwith "expected 2 ints."
                )
    | And(e1, e2) -> (match eval e1 env stk, eval e2 env stk with
                | (VInt x, s1), (VInt y, s2) -> (VBool (x && y), s2)
                | _ -> failwith "expected 2 ints."
                )
    | Not(e) -> (match eval e env stk with
                | (VBool b, s) -> (VBool (not b), s)
                | _ -> failwith "expected 2 ints."
                )
    | Let(str, e1, e2) -> let (v1, s1) = (eval e1 env stk) in (eval e2 ((str, v1) :: env) stk, s1)
    | Fun(s1, e) -> (VClosure (s1, e, env), stk)
    | App(e1, e2) -> let (funs, s1) = (eval e1 env stk) in let (args, s2) = (eval e2 env stk) in (match funs with
                         | VClosure(s, body, fenv) -> eval body ((s, args) :: fenv) stk
                         | VRecClosure(f, x, body, fenv) -> eval body ((f, funs) :: (x, args) :: fenv) stk
                         )
    | FunRec(s1, s2, e) -> (VRecClosure (s1, s2, e, env), stk)
    | Fst(e) -> (match eval e env stk with
                | (VPair(x, _), s) -> (x, s)
                | _ -> failwith "expected 2 ints."
                )
    | Snd(e) -> (match eval e env stk with
                | (VPair(_, y), s) -> (y, s)
                | _ -> failwith "expected 2 ints."
                )
    | Fix (s, e) -> eval e ((s, VRecClosure(s, s, e, env)) :: env) stk
    | Ref(e) -> let (v1, s1) = eval e env stk in let loc = fresh_loc () in (VRef loc, (loc, v1) :: s1)
    | Deref e1 ->
      let (v1, s1) = eval e1 env stk in
      (match v1 with
      | VRef loc -> (try (List.assoc loc s1, s1)
                     with Not_found -> failwith "invalid reference")
      | _ -> failwith "expected reference.")
    | Assign(e1, e2) ->
      let (v1, s1) = eval e1 env stk in
      let (v2, s2) = eval e2 env s1 in
      (match v1 with
      | VRef loc ->
          let new_store = (loc, v2) :: List.remove_assoc loc s2 in
          (v2, new_store)
      | _ -> failwith "expected reference.")
    | TryCatch(e1, e2) ->
      try eval e1 env stk
      with _ -> eval e2 env stk
