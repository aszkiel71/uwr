type expr =
    | Int of int
    | Bool of bool
    | Var of string
    | Add of expr * expr
    | Let of string * expr * expr
    | Record of (string * expr) list
    | Get of expr * string
    | Set of expr * string * expr

type value =
    | VInt of int
    | VBool of bool
    | VRecord of (string * value) list

type env = (string * value) list

let rec lookup_env k env = match env with
    | (key, v) :: rest -> if key = k then v else lookup_env k rest
    | _ -> failwith "not found"

let rec eval_record_fields fields env =
    match fields with
    | [] -> []
    | (name, expr_val) :: rest ->
        (name, eval expr_val env) :: eval_record_fields rest env

and update_record fields key new_val =
    match fields with
    | [] -> failwith "field not found"
    | (k, v) :: rest ->
        if k = key then (k, new_val) :: rest
        else (k, v) :: update_record rest key new_val

and eval e env =
    match e with
    | Int e -> VInt e
    | Bool b -> VBool b
    | Var k -> lookup_env k env
    | Add(e1, e2) ->
        match eval e1 env, eval e2 env with
        | VInt e1, VInt e2 -> VInt (e1 + e2)
        | _ -> failwith "type error"
    | Let(v, e1, e2) ->
        let v1 = eval e1 env in
        let new_env = (v, v1) :: env in
        eval e2 new_env
    | Record fields ->
        VRecord (eval_record_fields fields env)
    | Get (e1, key) ->
        (match eval e1 env with
         | VRecord fields -> List.assoc key fields
         | _ -> failwith "type error")
    | Set (e1, key, e2) ->
        (match eval e1 env with
         | VRecord fields ->
             let new_val = eval e2 env in
             VRecord (update_record fields key new_val)
         | _ -> failwith "type error")