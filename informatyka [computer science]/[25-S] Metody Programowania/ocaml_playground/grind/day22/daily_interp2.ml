type expr =
    | Int of int | Bool of bool | Var of string | Let of string * expr * expr
    | Fun of string * expr | FunRec of string * string * expr
    | Add of expr * expr | If of expr * expr * expr
    | Ref of expr | Deref of expr | Assign of expr * expr
    | Pair of expr * expr | Fst of expr | Snd of expr
    | App of expr * expr

type value =
    | VInt of int | VBool of bool
    | VRef of int
    | VClosure of string * expr * env
    | VRecClosure of string * string * expr * env
and env = (string * value) list

let rec lookup_env k env =
    match env with
    | (ky, v) :: rest -> if ky = k then v else lookup_env k rest
    | [] -> failwith "not found"

let return x = Some x
let bind m f = match m with | None -> None | Some y -> f y

let id = ref 0

let rec eval e env stk =
    match e with
    | Int i -> return(VInt i, stk)
    | Bool b -> return(VBool b, stk)
    | Var s -> return(lookup_env s env, stk)
    | Let(s, e1, e2) -> bind (eval e1 env stk) (fun (v1, stk) -> eval (e2 ((s, v1) :: env) stk))
    | Fun(s, e) -> return(VClosure(s, e, env) , stk)
    | FunRec(s1, s2, e) -> return(VRecClosure(s1, s2, e, env) , stk)
    | Add(e1, e2) -> bind (eval e1 env stk) (fun (v1, s1) ->
    bind (eval e2 env stk) (fun (v2, s2) ->
    match v1, v2 with
        | VInt x, VInt y -> return(VInt (x + y), s2)
        | _ -> failwith "expected 2 ints."
    ))
    | If(cond, e1, e2) -> bind (eval cond env stk) (fun (v1, s1) ->
    match v1 with
    | Bool true -> eval e1 env stk
    | Bool false -> eval e2 env stk
    | _ -> failwith "condition must be bool"
    )
    | Ref e -> id := !id + 1; bind (eval e env stk) (fun (v, stk) -> return (VRef !id , (v, !id) :: stk))
    | Deref