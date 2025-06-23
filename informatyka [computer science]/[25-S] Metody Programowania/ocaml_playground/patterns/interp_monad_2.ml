type expr =
  | Int of int
  | Bool of bool
  | Var of string
  | Add of expr * expr
  | Sub of expr * expr
  | Mult of expr * expr
  | Eq of expr * expr
  | Lt of expr * expr
  | And of expr * expr
  | Or of expr * expr
  | Not of expr
  | If of expr * expr * expr
  | Let of string * expr * expr
  | Fun of string * expr
  | App of expr * expr
  | FunRec of string * string * expr
  | Pair of expr * expr
  | Fst of expr
  | Snd of expr
  | Fix of string * expr
  | Ref of expr
  | Deref of expr
  | Assign of expr * expr

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

let rec lookup_env k lst =
  match lst with
  | [] -> failwith ("Unbound variable: " ^ k)
  | (ky, v) :: rest -> if ky = k then v else lookup_env k rest

let rec eval e env store =
  match e with
  | Int i -> (VInt i, store)
  | Bool b -> (VBool b, store)
  | Var s -> (lookup_env s env, store)
  | Add(e1, e2) ->
      let (v1, s1) = eval e1 env store in
      let (v2, s2) = eval e2 env s1 in
      (match v1, v2 with
      | VInt x, VInt y -> (VInt (x + y), s2)
      | _ -> failwith "expected 2 ints.")
  | Sub(e1, e2) ->
      let (v1, s1) = eval e1 env store in
      let (v2, s2) = eval e2 env s1 in
      (match v1, v2 with
      | VInt x, VInt y -> (VInt (x - y), s2)
      | _ -> failwith "expected 2 ints.")
  | Mult(e1, e2) ->
      let (v1, s1) = eval e1 env store in
      let (v2, s2) = eval e2 env s1 in
      (match v1, v2 with
      | VInt x, VInt y -> (VInt (x * y), s2)
      | _ -> failwith "expected 2 ints.")
  | Eq(e1, e2) ->
      let (v1, s1) = eval e1 env store in
      let (v2, s2) = eval e2 env s1 in
      (match v1, v2 with
      | VInt x, VInt y -> (VBool (x = y), s2)
      | VBool x, VBool y -> (VBool (x = y), s2)
      | _ -> failwith "cannot compare different types.")
  | Lt(e1, e2) ->
      let (v1, s1) = eval e1 env store in
      let (v2, s2) = eval e2 env s1 in
      (match v1, v2 with
      | VInt x, VInt y -> (VBool (x < y), s2)
      | _ -> failwith "expected 2 ints.")
  | And(e1, e2) ->
      let (v1, s1) = eval e1 env store in
      let (v2, s2) = eval e2 env s1 in
      (match v1, v2 with
      | VBool x, VBool y -> (VBool (x && y), s2)
      | _ -> failwith "expected 2 bools.")
  | Or(e1, e2) ->
      let (v1, s1) = eval e1 env store in
      let (v2, s2) = eval e2 env s1 in
      (match v1, v2 with
      | VBool x, VBool y -> (VBool (x || y), s2)
      | _ -> failwith "expected 2 bools.")
  | Not e1 ->
      let (v, s1) = eval e1 env store in
      (match v with
      | VBool b -> (VBool (not b), s1)
      | _ -> failwith "expected bool.")
  | If(cond, e1, e2) ->
      let (vcond, s1) = eval cond env store in
      (match vcond with
      | VBool true -> eval e1 env s1
      | VBool false -> eval e2 env s1
      | _ -> failwith "condition must be bool.")
  | Let(str, e1, e2) ->
      let (v1, s1) = eval e1 env store in
      eval e2 ((str, v1) :: env) s1
  | Fun(str, e) -> (VClosure(str, e, env), store)
  | App(e1, e2) ->
      let (fun_val, s1) = eval e1 env store in
      let (arg_val, s2) = eval e2 env s1 in
      (match fun_val with
      | VClosure(s, body, fenv) -> eval body ((s, arg_val) :: fenv) s2
      | VRecClosure(f, x, body, fenv) -> eval body ((f, fun_val) :: (x, arg_val) :: fenv) s2
      | _ -> failwith "not a function.")
  | FunRec(f, x, body) -> (VRecClosure(f, x, body, env), store)
  | Pair(e1, e2) ->
      let (v1, s1) = eval e1 env store in
      let (v2, s2) = eval e2 env s1 in
      (VPair(v1, v2), s2)
  | Fst e1 ->
      let (v, s1) = eval e1 env store in
      (match v with
      | VPair(x, _) -> (x, s1)
      | _ -> failwith "expected pair.")
  | Snd e1 ->
      let (v, s1) = eval e1 env store in
      (match v with
      | VPair(_, y) -> (y, s1)
      | _ -> failwith "expected pair.")
  | Fix(s, e1) ->
      eval e1 ((s, VRecClosure(s, s, e1, env)) :: env) store
  | Ref e1 ->
      let (v1, s1) = eval e1 env store in
      let loc = fresh_loc () in
      (VRef loc, (loc, v1) :: s1)
  | Deref e1 ->
      let (v1, s1) = eval e1 env store in
      (match v1 with
      | VRef loc -> (try (List.assoc loc s1, s1)
                     with Not_found -> failwith "invalid reference")
      | _ -> failwith "expected reference.")
  | Assign(e1, e2) ->
      let (v1, s1) = eval e1 env store in
      let (v2, s2) = eval e2 env s1 in
      (match v1 with
      | VRef loc ->
          let new_store = (loc, v2) :: List.remove_assoc loc s2 in
          (v2, new_store)
      | _ -> failwith "expected reference.")
