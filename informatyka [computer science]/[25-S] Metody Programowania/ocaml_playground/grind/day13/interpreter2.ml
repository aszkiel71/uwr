type expr =
    | Int of int
    | Bool of bool
    | Var of string
    | Add of expr * expr
    | Lt of expr * expr
    | Let of string * expr * expr
    | Assign of string * expr
    | Seq of expr * expr
    | While of expr * expr
    | Skip

type value =
    | VInt of int
    | VBool of bool
    | VUnit

type env = (string * value) list

let rec lookup_env k env =
    match env with
    | (key, v) :: rest -> if key = k then v else lookup_env k rest
    | _ -> failwith "not found"

let rec update_env k new_val env =
    match env with
    | (key, v) :: rest ->
        if key = k then (key, new_val) :: rest
        else (key, v) :: update_env k new_val rest
    | [] -> (k, new_val) :: env

let rec eval e env =
    match e with
    | Int e -> (VInt e, env)
    | Bool b -> (VBool b, env)
    | Var k -> (lookup_env k env, env)
    | Add(e1, e2) ->
        let (v1, env1) = eval e1 env in
        let (v2, env2) = eval e2 env1 in
        (match v1, v2 with
         | VInt x, VInt y -> (VInt(x + y), env2)
         | _ -> failwith "type error")
    | Lt(e1, e2) ->
        let (v1, env1) = eval e1 env in
        let (v2, env2) = eval e2 env1 in
        (match v1, v2 with
         | VInt x, VInt y -> (VBool (x < y), env2)
         | _ -> failwith "type error")
    | Let(key, e1, e2) ->
        let (new_val, env1) = eval e1 env in
        eval e2 ((key, new_val) :: env1)
    | Seq(e1, e2) ->
        let (_, env1) = eval e1 env in
        eval e2 env1
    | Skip -> (VUnit, env)
    | Assign(key, e1) ->
        let (new_val, env1) = eval e1 env in
        (VUnit, update_env key new_val env1)
    | While(cond, body) ->
        let (cond_val, env1) = eval cond env in
        (match cond_val with
         | VBool true ->
             let (_, env2) = eval body env1 in
             eval (While(cond, body)) env2
         | VBool false -> (VUnit, env1)
         | _ -> failwith "while condition must be boolean")