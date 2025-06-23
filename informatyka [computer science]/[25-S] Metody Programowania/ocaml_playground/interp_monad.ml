type ident = string

type base_type = TInt | TBool | TUnit | TRef
type typ =
    | TBase of base_type
    | TFun of typ * typ
    | TList of typ
    | TRecord of (string * typ) list
    | TOption of typ
    | TRefType of typ

type expr =
    | Int of int
    | Bool of bool
    | Unit
    | Var of ident
    | Add of expr * expr
    | Sub of expr * expr
    | Mult of expr * expr
    | Div of expr * expr
    | Mod of expr * expr
    | Eq of expr * expr
    | Lt of expr * expr
    | Gt of expr * expr
    | Le of expr * expr
    | Ge of expr * expr
    | And of expr * expr
    | Or of expr * expr
    | Not of expr
    | If of expr * expr * expr
    | Let of ident * expr * expr
    | LetRec of ident * ident * expr * expr
    | Fun of ident * typ * expr
    | App of expr * expr
    | Nil
    | Cons of expr * expr
    | Head of expr
    | Tail of expr
    | IsEmpty of expr
    | Record of (string * expr) list
    | Get of expr * string
    | Set of expr * string * expr
    | Some of expr
    | None
    | Match of expr * (pattern * expr) list
    | Bind of expr * ident * expr
    | Return of expr
    | Assign of ident * expr
    | Seq of expr * expr
    | While of expr * expr
    | For of ident * expr * expr * expr
    | Ref of expr
    | Deref of expr
    | RefAssign of expr * expr

and pattern =
    | PVar of ident
    | PInt of int
    | PBool of bool
    | PNil
    | PCons of pattern * pattern
    | PSome of pattern
    | PNone

type value =
    | VInt of int
    | VBool of bool
    | VUnit
    | VClosure of ident * typ * expr * env
    | VList of value list
    | VRecord of (string * value) list
    | VOption of value option
    | VRef of int

and env = (ident * value) list
and tenv = (ident * typ) list
and store = (int * value) list

type state = {
    env: env;
    store: store;
    next_addr: int;
}

exception TypeError of string
exception RuntimeError of string

let return_m x = VOption (Some x)
let bind_m m f =
    match m with
    | VOption (Some x) -> f x
    | VOption None -> VOption None
    | _ -> raise (RuntimeError "Bind expects option")

let empty_env = []
let extend_env x v env = (x, v) :: env

let rec lookup_env x env =
    match env with
    | [] -> raise (RuntimeError ("Variable not found: " ^ x))
    | (y, v) :: rest ->
        if x = y then v else lookup_env x rest

let rec update_env x v env =
    match env with
    | [] -> extend_env x v env
    | (y, old_v) :: rest ->
        if x = y then (y, v) :: rest
        else (y, old_v) :: update_env x v rest

let empty_tenv = []
let extend_tenv x t tenv = (x, t) :: tenv

let rec lookup_tenv x tenv =
    match tenv with
    | [] -> raise (TypeError ("Type variable not found: " ^ x))
    | (y, t) :: rest ->
        if x = y then t else lookup_tenv x rest

let empty_store = []
let extend_store addr v store = (addr, v) :: store

let rec lookup_store addr store =
    match store with
    | [] -> raise (RuntimeError ("Address not found: " ^ string_of_int addr))
    | (a, v) :: rest ->
        if a = addr then v else lookup_store addr rest

let rec update_store addr v store =
    match store with
    | [] -> raise (RuntimeError ("Address not found: " ^ string_of_int addr))
    | (a, old_v) :: rest ->
        if a = addr then (a, v) :: rest
        else (a, old_v) :: update_store addr v rest

let init_state = { env = empty_env; store = empty_store; next_addr = 0 }

let rec type_check tenv = function
    | Int _ -> TBase TInt
    | Bool _ -> TBase TBool
    | Unit -> TBase TUnit
    | Var x -> lookup_tenv x tenv
    | Add(e1, e2) | Sub(e1, e2) | Mult(e1, e2) | Div(e1, e2) | Mod(e1, e2) ->
        (match type_check tenv e1, type_check tenv e2 with
         | TBase TInt, TBase TInt -> TBase TInt
         | _ -> raise (TypeError "Arithmetic operations require integers"))
    | Eq(e1, e2) | Lt(e1, e2) | Gt(e1, e2) | Le(e1, e2) | Ge(e1, e2) ->
        (match type_check tenv e1, type_check tenv e2 with
         | TBase TInt, TBase TInt -> TBase TBool
         | _ -> raise (TypeError "Comparison operations require integers"))
    | And(e1, e2) | Or(e1, e2) ->
        (match type_check tenv e1, type_check tenv e2 with
         | TBase TBool, TBase TBool -> TBase TBool
         | _ -> raise (TypeError "Logical operations require booleans"))
    | Not e ->
        (match type_check tenv e with
         | TBase TBool -> TBase TBool
         | _ -> raise (TypeError "Not requires boolean"))
    | If(cond, e1, e2) ->
        (match type_check tenv cond with
         | TBase TBool ->
             let t1 = type_check tenv e1 in
             let t2 = type_check tenv e2 in
             if t1 = t2 then t1 else raise (TypeError "If branches must have same type")
         | _ -> raise (TypeError "If condition must be boolean"))
    | Let(x, e1, e2) ->
        let t1 = type_check tenv e1 in
        let new_tenv = extend_tenv x t1 tenv in
        type_check new_tenv e2
    | LetRec(f, x, e1, e2) ->
        let arg_type = TBase TInt in
        let ret_type = type_check (extend_tenv x arg_type (extend_tenv f (TFun(arg_type, ret_type)) tenv)) e1 in
        let func_type = TFun(arg_type, ret_type) in
        let new_tenv = extend_tenv f func_type tenv in
        type_check new_tenv e2
    | Fun(x, arg_type, body) ->
        let new_tenv = extend_tenv x arg_type tenv in
        let ret_type = type_check new_tenv body in
        TFun(arg_type, ret_type)
    | App(e1, e2) ->
        (match type_check tenv e1, type_check tenv e2 with
         | TFun(t_arg, t_ret), t2 ->
             if t_arg = t2 then t_ret else raise (TypeError "Function argument type mismatch")
         | _ -> raise (TypeError "Application requires function"))
    | Assign(x, e) ->
        let _ = lookup_tenv x tenv in
        let _ = type_check tenv e in
        TBase TUnit
    | Seq(e1, e2) ->
        let _ = type_check tenv e1 in
        type_check tenv e2
    | While(cond, body) ->
        (match type_check tenv cond with
         | TBase TBool ->
             let _ = type_check tenv body in
             TBase TUnit
         | _ -> raise (TypeError "While condition must be boolean"))
    | For(x, start, stop, body) ->
        (match type_check tenv start, type_check tenv stop with
         | TBase TInt, TBase TInt ->
             let new_tenv = extend_tenv x (TBase TInt) tenv in
             let _ = type_check new_tenv body in
             TBase TUnit
         | _ -> raise (TypeError "For bounds must be integers"))
    | Ref e ->
        let t = type_check tenv e in
        TRefType t
    | Deref e ->
        (match type_check tenv e with
         | TRefType t -> t
         | _ -> raise (TypeError "Deref requires reference"))
    | RefAssign(e1, e2) ->
        (match type_check tenv e1 with
         | TRefType t ->
             let t2 = type_check tenv e2 in
             if t = t2 then TBase TUnit else raise (TypeError "RefAssign type mismatch")
         | _ -> raise (TypeError "RefAssign requires reference"))
    | Nil -> TList (TBase TInt)
    | Cons(e1, e2) ->
        let t1 = type_check tenv e1 in
        (match type_check tenv e2 with
         | TList t2 -> if t1 = t2 then TList t1 else raise (TypeError "Cons type mismatch")
         | _ -> raise (TypeError "Cons requires list"))
    | Head e | Tail e ->
        (match type_check tenv e with
         | TList t -> if e = Head e then t else TList t
         | _ -> raise (TypeError "Head/Tail requires list"))
    | IsEmpty e ->
        (match type_check tenv e with
         | TList _ -> TBase TBool
         | _ -> raise (TypeError "IsEmpty requires list"))
    | Record fields ->
        TRecord (List.map (fun (name, expr) -> (name, type_check tenv expr)) fields)
    | Get(e, field) ->
        (match type_check tenv e with
         | TRecord fields -> List.assoc field fields
         | _ -> raise (TypeError "Get requires record"))
    | Set(e1, field, e2) ->
        (match type_check tenv e1 with
         | TRecord fields ->
             let field_type = List.assoc field fields in
             let new_type = type_check tenv e2 in
             if field_type = new_type then TRecord fields
             else raise (TypeError "Set field type mismatch")
         | _ -> raise (TypeError "Set requires record"))
    | Some e ->
        let t = type_check tenv e in
        TOption t
    | None -> TOption (TBase TInt)
    | Return e ->
        let t = type_check tenv e in
        TOption t
    | Bind(e1, x, e2) ->
        (match type_check tenv e1 with
         | TOption t1 ->
             let new_tenv = extend_tenv x t1 tenv in
             type_check new_tenv e2
         | _ -> raise (TypeError "Bind requires option"))
    | Match(e, cases) ->
        let e_type = type_check tenv e in
        match cases with
        | (_, first_expr) :: _ ->
            let first_type = type_check tenv first_expr in
            first_type
        | [] -> raise (TypeError "Match requires at least one case")

let rec match_pattern pattern value env =
    match pattern, value with
    | PVar x, v -> extend_env x v env
    | PInt n, VInt m -> if n = m then env else raise (RuntimeError "Pattern match failed")
    | PBool b, VBool c -> if b = c then env else raise (RuntimeError "Pattern match failed")
    | PNil, VList [] -> env
    | PCons(p1, p2), VList (v :: vs) ->
        let env1 = match_pattern p1 v env in
        match_pattern p2 (VList vs) env1
    | PSome p, VOption (Some v) -> match_pattern p v env
    | PNone, VOption None -> env
    | _ -> raise (RuntimeError "Pattern match failed")

let rec eval_record_fields fields state =
    match fields with
    | [] -> ([], state)
    | (name, expr) :: rest ->
        let (v, state1) = eval expr state in
        let (rest_fields, state2) = eval_record_fields rest state1 in
        ((name, v) :: rest_fields, state2)

and update_record fields field new_val =
    match fields with
    | [] -> raise (RuntimeError "Field not found")
    | (f, v) :: rest ->
        if f = field then (f, new_val) :: rest
        else (f, v) :: update_record rest field new_val

