type expr =
    | Int of int
    | Var of string
    | Add of expr * expr
    | Let of string * expr * expr
    | Fun of string * expr
    | App of expr * expr

type instr =
    | Push of int
    | Load of int
    | Store of int
    | AddOp
    | MakeClosure of instr list
    | Apply

type env = (string * int) list

let rec lookup_idx key env =
    let rec find e idx =
        match e with
        | (k, _) :: rest -> if key = k then idx else find rest (idx + 1)
        | [] -> failwith "variable not found"
    in find env 0

let rec compile e env =
    match e with
    | Int n -> [Push n]
    | Var v -> [Load (lookup_idx v env)]
    | Add(e1, e2) ->
        (compile e1 env) @ (compile e2 env) @ [AddOp]
    | Let(v, e1, e2) ->
        let e1_code = compile e1 env in
        let new_env = (v, List.length env) :: env in
        let e2_code = compile e2 new_env in
        e1_code @ [Store (List.length env)] @ e2_code
    | Fun(param, body) ->
        let new_env = (param, 0) :: env in
        let body_code = compile body new_env in
        [MakeClosure body_code]
    | App(func, arg) ->
        let func_code = compile func env in
        let arg_code = compile arg env in
        func_code @ arg_code @ [Apply]

let remove_dead_code instrs =
    let rec remove acc = function
        | [] -> List.rev acc
        | Push n :: Store i :: Load j :: rest when i = j ->
            remove (Push n :: acc) rest
        | Push _ :: Store i :: rest ->
            remove acc rest
        | instr :: rest ->
            remove (instr :: acc) rest
    in remove [] instrs