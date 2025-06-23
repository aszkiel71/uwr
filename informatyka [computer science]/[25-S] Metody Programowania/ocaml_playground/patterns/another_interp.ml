type expr =
  | Int of int
  | Bool of bool
  | Add of expr * expr
  | Let of string * expr * expr
  | Fun of string * expr
  | FunRec of string * string * expr
  | App of expr * expr
  | Ref of expr
  | Deref of int
  | Assign of int * expr
  | Var of string

 type value =
    | VInt of int
    | VBool of bool
    | VClosure of string * expr * env
    | VRecClosure of string * string * expr * env
    | VUnit
    | VRef of int
    and
 env = (string * value) list

let return x = Some x
let bind m f = match m with | None -> None | Some y -> f y

let id = ref 0

let rec eval e env stk =
    match e with
    | Int i -> return (VInt i, stk)
    | Bool b -> return (VBool b, stk)
    | Add(e1, e2) -> bind (eval e1 env stk) (fun (v1, stk) ->
    bind (eval e2 env stk) (fun (v2, stk) -> match v1, v2 with
        | VInt x, VInt y -> return (VInt (x + y), stk)
        | _, _ -> None))
    | Var s -> return (List.assoc s env, stk)
    | Let(str, e1, e2) -> bind (eval e1 env stk) (fun (v1, stk) -> eval e2 ((str, v1) :: env) stk )
    | App(e1, e2) ->
    (bind (eval e1 env stk) (fun (v1, stk) ->
        match v1 with
        | VClosure(x, body, venv) ->
            bind (eval e2 env stk) (fun (v2, stk) ->
                eval body ((x, v2) :: venv) stk
            )
        | VRecClosure(f, x, body, venv) ->
            bind (eval e2 env stk) (fun (v2, stk) ->
                eval body ((f, v1) :: (x, v2) :: venv) stk
            )
        | _ -> failwith "expected function"
    ))
    | Fun(str, e1) -> return(VClosure(str, e1, env),stk)
    | FunRec(f, str, e) -> return(VRecClosure(f, str, e, env), stk)
    | Ref e -> id := !id + 1; bind (eval e env stk) (fun (v1, stk) -> return ((VRef !id), ((!id, v1) :: stk)))
    | Deref i -> bind (List.assoc_opt i stk) (fun v1 -> return(v1, stk))
    | Assign(i, e) -> bind (eval e env stk) (fun (v1, stk) -> return ((VUnit), (i, v1) :: (List.remove_assoc i stk)))