open Ast

module M = Map.Make(String)

type env = value M.t

and value =
  | VInt of int
  | VBool of bool
  | VUnit
  | VPair of value * value
  | VClosure of var * expr * env
  | VRecClosure of var * var * expr * env
  | VBuiltin of (value -> value)

let builtin_int_fun op =
  VBuiltin (fun v1 ->
    VBuiltin (fun v2 ->
      match v1, v2 with
      | VInt n1, VInt n2 -> VInt (op n1 n2)
      | _ -> failwith "Type error"))

let builtin_int_cmp op =
  VBuiltin (fun v1 ->
    VBuiltin (fun v2 ->
      match v1, v2 with
      | VInt n1, VInt n2 -> VBool (op n1 n2)
      | _ -> failwith "Type error"))

let builtin_bool_fun op =
  VBuiltin (fun v1 ->
    VBuiltin (fun v2 ->
      match v1, v2 with
      | VBool n1, VBool n2 -> VBool (op n1 n2)
      | _ -> failwith "Type error"))

let builtin_tab =
  [ "fst", VBuiltin (fun v ->
      match v with
      | VPair(v1, _) -> v1
      | _ -> failwith "Type error")
  ; "snd", VBuiltin (fun v ->
      match v with
      | VPair(_, v2) -> v2
      | _ -> failwith "Type error")
  ; "add",  (builtin_int_fun (+))
  ; "sub",  (builtin_int_fun (-))
  ; "mult", (builtin_int_fun ( * ))
  ; "div",  (builtin_int_fun (/))
  ; "leq",  (builtin_int_cmp ( <= ))
  ; "geq",  (builtin_int_cmp ( >= ))
  ; "lt",   (builtin_int_cmp ( < ))
  ; "gt",   (builtin_int_cmp ( > ))
  ; "and",  (builtin_bool_fun ( && ))
  ; "or",   (builtin_bool_fun ( || ))
  ; "eq", VBuiltin (fun v1 ->
    VBuiltin (fun v2 -> VBool (v1 = v2)))
  ; "neq", VBuiltin (fun v1 ->
    VBuiltin (fun v2 -> VBool (v1 <> v2)))
  ] |> List.to_seq |> Hashtbl.of_seq

let rec show_value v =
  match v with
  | VInt n -> string_of_int n
  | VBool v -> string_of_bool v
  | VUnit -> "()"
  | VPair (v1,v2) -> "(" ^ show_value v1 ^ ", " ^ show_value v2 ^ ")"
  | VClosure _ | VRecClosure _ | VBuiltin _ -> "<fun>"

let rec eval_env (env : env) (e : expr) : value =
  match e with
  | Int i -> VInt i
  | Bool b -> VBool b
  | If (b, t, e) ->
      (match eval_env env b with
        | VBool true -> eval_env env t
        | VBool false -> eval_env env e
        | _ -> failwith "type error")
  | Var x ->
     (match M.find_opt x env with
       | Some v -> v
       | None -> failwith "unknown var")
  | Let (x, e1, e2) ->
      eval_env (M.add x (eval_env env e1) env) e2
  | Pair (e1, e2) -> VPair (eval_env env e1, eval_env env e2)
  | Unit -> VUnit
  | Fun (x, e) -> VClosure (x, e, env)
  | Funrec (f, x, e) -> VRecClosure (f, x, e, env)
  | App (e1, e2) ->
      let v1 = eval_env env e1 in
      let v2 = eval_env env e2 in
      (match v1 with
        | VClosure (x, body, clo_env) ->
            eval_env (M.add x v2 clo_env) body
        | VRecClosure (f, x, body, clo_env) as c ->
            eval_env (clo_env |> M.add x v2 |> M.add f c) body
        | VBuiltin f ->
            f v2
        | _ -> failwith "not a function")
  | Builtin name ->
    Hashtbl.find builtin_tab name

let eval = eval_env M.empty
