type expr =
    | Int of int | Bool of bool | Var of string
    | Add of expr * expr | If of expr * expr * expr
    | Let of string * expr * expr | Fun of string * typ * expr
    | FunRec of string * string * typ * typ * expr
    | Ref of expr | Deref of expr | Assign of expr * expr
    | Pair of expr * expr | Fst of expr | Snd of expr
    | TryCatch of expr * expr | Fix of expr
    | App of expr * expr
and typ =
    | TInt | TBool | TRef of typ | TPair of typ * typ
    | TLambda of typ * typ | TUnit

type value =
    | VInt of int | VBool of bool | VRef of value
    | VClosure of string * expr * env | VUnit
    | VRecClosure of string * string * expr * env
and env = (string * value) list

type tenv = (string * typ) list

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
    | Var s -> return(lookup_env s env , stk)
    | Add(e1, e2) -> bind (eval e1 env stk) (fun (v1, s1) ->
        bind (eval e2 env s1) (fun (v2, s2) ->
        match v1, v2 with
        | VInt x, VInt y -> return (VInt (x + y), stk)
        | _ -> failwith "expected 2 ints"
        ))
    | If(cond, e1, e2) -> bind (eval e1 env stk) (fun (v, s) ->
        match v with
        | VBool true -> eval e1 env s
        | VBool false -> eval e2 env s
        | _ -> failwith "condition must be bool")
    | Let(s, e1, e2) -> bind (eval e1 env stk) (fun (v, s1) ->
                        eval e2 ((s, v) :: env) stk)
    | Fun(s, _, e) -> return(VClosure(s, e, env), stk)
    | FunRec(f, x, _, _, e) -> return(VRecClosure(f, x, e, env), stk)
    | Ref(e) -> id := !id + 1; bind (eval e env stk) (fun (v, s) ->
                               return (VRef !id, (!id, v) :: s))
    | Deref(e) -> bind (eval e env stk) (fun (v, s) ->
                    match v with
                    | VRef i -> return(List.assoc i s, s)
                    | _ -> failwith "expected reference"
                    )
    | Assign(e1, e2) -> bind (eval e1 env stk) (fun (v, s) ->
                        bind (eval e2 env s) (fun (v2, s2) ->
                        match v with
                         | VRef k -> return (VUnit, (k ,v2) :: (List.remove_assoc v s2 )), s2)
                         | _ -> failwith "expected reference")
    | Pair(e1, e2) -> bind (eval e1 env stk) (fun (v1, s1) ->
                           (eval e2 env s1) (fun (v2, s2) ->
                           return (VPair(v1, v2), s2)))
    | Fst(e) -> bind (eval e env stk) (fun (v, s) ->
             match v with
             | VPair(x, _) -> return(x, s)
             | _ -> failwith "expected pair")
    | Snd(e) -> bind (eval e env stk) (fun (v, s) ->
             match v with
             | VPair(_, y) -> return(y, s)
             | _ -> failwith "expected pair")
    | TryCatch(e1, e2) -> (match eval e1 env stk with
            | Some (v1, s1) -> return (v1, s1)
            | None -> eval e2 env stk)
    | Fix(e) ->