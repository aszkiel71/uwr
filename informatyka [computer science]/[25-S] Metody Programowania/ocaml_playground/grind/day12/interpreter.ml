type ident = string

exception RuntimeException of value

type expr =
    | Int of int
    | Bool of bool
    | Var of string
    | Add of expr * expr
    | Sub of expr * expr
    | Mult of expr * expr
    | Let of ident * expr * expr
    | And of expr * expr
    | Or of expr * expr
    | Fun of ident * expr
    | App of expr * expr
    | If of expr * expr * expr
    | Eq of expr * expr
    | Lt of expr * expr
    | Fix of ident * expr
    | Funrec of ident * ident * expr
    | Div of expr * expr
    | Mod of expr * expr
    | Nil
    | Cons of expr * expr
    | Head of expr
    | Tail of expr
    | IsEmpty of expr
    | Throw of expr
    | TryCatch of expr * ident * expr

type value =
    | VInt of int
    | VBool of bool
    | VClosure of ident * expr * env
    | VList of value list

and env = (ident * value) list

let empty_env = []

let extend_env x v env = (x, v) :: env

let rec lookup_env x env =
    match env with
    | [] -> failwith "not found"
    | (y , v) :: rest ->
        if x = y then v else lookup_env x rest

let rec eval e env =
    match e with
    | Int e -> VInt e
    | Bool b -> VBool b
    | Var x -> lookup_env x env
    | Add(e1, e2) -> match (eval e1 env, eval e2 env) with
                            | (VInt e1, VInt e2) -> VInt (e1 + e2)
                            | _ -> failwith "type error"
    | Sub(e1, e2) -> match (eval e1 env, eval e2 env) with
                            | (VInt e1, VInt e2) -> VInt (e1 - e2)
                            | _ -> failwith "type error"
    | Div(e1, e2) -> match (eval e1 env, eval e2 env) with
                            | (VInt e1, VInt 0) -> failwith "cannot divide by zero"
                            | (VInt e1, VInt e2) -> VInt (e1 / e2)
                            | _ -> failwith "type error"
    | Mod(e1, e2) -> match (eval e1 env, eval e2 env) with
                            | (VInt e1, VInt 0) -> failwith "cannot mod by zero"
                            | (VInt, e1, VInt e2) -> VInt (e1 mod e2)
                            | _ -> failwith "type error"
    | Mult(e1, e2) -> match (eval e1 env, eval e2 env) with
                            | (VInt e1, VInt e2) -> VInt (e1 * e2)
                            | _ -> failwith "type error"
    | And(e1, e2) -> match (eval e1 env, eval e2 env) with
                            | (VBool b1, VBool b2) -> VBool (b1 && b2)
                            | _ -> failwith "type error"
    | Or(e1, e2) -> match (eval e1 env, eval e2 env) with
                            | (VBool b1, VBool b2) -> VBool (b1 || b2)
                            | _ -> failwith "type error"
    | Let(v, e1, e2) ->
        let v1 = eval e1 env in let new_env = (v, v1) :: env in eval e2 new_env
    | Eq(e1, e2) -> match (eval e1 env, eval e2 env) with
                            | (VInt e1, VInt e2) -> VBool (e1 = e2)
                            | _ -> failwith "type error"
    | Lt(e1, e2) -> match (eval e1 env, eval e2 env) with
                            | (VInt e1, VInt e2) -> VBool (e1 < e2)
                            | _ -> failwith "type error"
    | If(cond, e1, e2) -> match eval cond env with
                            | VBool true -> eval e1 env
                            | VBool false -> eval e2 env
                            | _ -> failwith "some error"
    | Fun(param, body) ->
            VClosure(param, body, env)
    | App(func_expr, arg_expr) ->
        let func_val = eval func_expr env in
        let arg_val = eval arg_expr env in
        match func_val with
        | VClosure(param, body, closure_env) ->
            let new_env = (param, arg_val) :: closure_env in
            eval body new_env
    | Fix(f, e) ->
        eval (Let(f, Fix(f, e), e)) env
    | Funrec(fname, param, body) ->
        let rec closure_env = (fname, VClosure(param, body, closure_env)) :: env in
        VClosure(param, body, closure_env)
    | Nil -> VList []
    | Cons(e1, e2) ->
        let v1 = eval e1 env in
        let v2 = eval e2 env in
            (match v2 with
             | VList lst -> VList (v1 :: lst)
             | _ -> failwith "Cons: second argument must be a list")

    | Head(e) ->
        (match eval e env with
         | VList [] -> failwith "Head of empty list"
         | VList (x :: _) -> x
         | _ -> failwith "Head expects list")

    | Tail(e) ->
        (match eval e env with
         | VList [] -> failwith "Tail of empty list"
         | VList (_ :: xs) -> VList xs
         | _ -> failwith "Tail expects list")

    | IsEmpty(e) ->
        (match eval e env with
         | VList [] -> VBool true
         | VList _ -> VBool false
         | _ -> failwith "IsEmpty expects list")
    | Throw(e) ->
        let v = eval e env in
        raise (RuntimeException v)

    | TryCatch(e1, x, e2) ->
        try eval e1 env
        with RuntimeException v ->
            let new_env = (x, v) :: env in
            eval e2 new_env