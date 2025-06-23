module StringMap = Map.Make(String)
module IntMap = Map.Make(Int)
type expr =
 | Int of int
 | Bool of bool
 | Var of string
 | Add of expr * expr
 | Sub of expr * expr
 | Mul of expr * expr
 | Div of expr * expr
 | And of expr * expr
 | Or of expr * expr
 | If of expr * expr * expr
 | IsEqual of expr * expr
 | Let of string * expr * expr
 | Fun of string * typ * expr
 | Apply of expr * expr
 | TryCatch of expr * expr
 | Throw
 | Ref of expr
 | Deref of int
 | Assign of int * expr
 | Unit
 | FunRec of string * string * typ * expr * typ
 | Fix of expr

and
typ =
 | TInt
 | TBool
 | TUnit
 | TRef
 | TLambda of typ * typ

type 'a env = 'a StringMap.t and

value =
 | VInt of int
 | VBool of bool
 | VClosure of string * expr *  value env
 | VRecClosure of string * string * expr *  value env
 | VRef of int
 | VUnit

let return v = Some v

let bind v f =
  match v with
  | None -> None
  | Some v -> f v

type 'a stack = 'a IntMap.t

let id = ref 0

let rec eval (env : value env) (e : expr) (stk : value stack) : (value * value stack) option =
  match e with
  | Int i -> return ((VInt i) , stk)
  | Bool b -> return ((VBool b), stk)
  | Var x -> ( match (StringMap.find_opt x env) with
    | Some v -> return (v, stk)
    | None -> None
  )
  | Add (e1 ,e2) -> bind (eval env e1 stk) (fun (v1, stk) ->
    bind (eval env e2 stk) (fun (v2, stk) ->
      match v1, v2 with
      | VInt v1, VInt v2 -> return ((VInt (v1 + v2)), stk)
      | _, _ -> None
      )
    )
  | Sub (e1 ,e2) -> bind (eval env e1 stk) (fun (v1, stk) ->
    bind (eval env e2 stk) (fun (v2, stk) ->
      match v1, v2 with
      | VInt v1, VInt v2 -> return ((VInt (v1 - v2)), stk)
      | _, _ -> None
      )
    )
  | Mul (e1 ,e2) -> bind (eval env e1 stk) (fun (v1, stk) ->
    bind (eval env e2 stk) (fun (v2, stk) ->
      match v1, v2 with
      | VInt v1, VInt v2 -> return ((VInt (v1 * v2)), stk)
      | _, _ -> None
      )
    )
  | Div (e1 ,e2) -> bind (eval env e1 stk) (fun (v1, stk) ->
    bind (eval env e2 stk) (fun (v2, stk) ->
      match v1, v2 with
      | VInt v1, VInt v2 -> if v2 = 0 then None else return ((VInt (v1 / v2)), stk)
      | _, _ -> None
      )
    )
  | And (e1 ,e2) -> bind (eval env e1 stk) (fun (v1, stk) ->
    bind (eval env e2 stk) (fun (v2, stk) ->
      match v1, v2 with
      | VBool v1, VBool v2 -> return ((VBool (v1 && v2)), stk)
      | _, _ -> None
      )
    )
  | Or (e1 ,e2) -> bind (eval env e1 stk) (fun (v1, stk) ->
    bind (eval env e2 stk) (fun (v2, stk) ->
      match v1, v2 with
      | VBool v1, VBool v2 -> return ((VBool (v1 || v2)), stk)
      | _, _ -> None
      )
    )
  | IsEqual (e1 ,e2) -> bind (eval env e1 stk) (fun (v1, stk) ->
    bind (eval env e2 stk) (fun (v2, stk) ->
      match v1, v2 with
      | VBool v1, VBool v2 -> return ((VBool (v1 = v2)), stk)
      | VInt v1, VInt v2 -> return ((VBool (v1 = v2)), stk)
      | _, _ -> None
      )
    )
  | If (e1, e2, e3) -> bind (eval env e1 stk) (fun (v1, stk) ->
    match v1 with
    | VBool true -> eval env e2 stk
    | VBool false -> eval env e3 stk
    | _ -> None
    )
  | Let (x, e1, e2) -> bind (eval env e1 stk) (fun (v1 ,stk) ->
    eval (StringMap.add x v1 env) e2 stk)
  | Fun (x, _, body) -> return ((VClosure (x, body, env)), stk)
  | Apply (f, e) -> bind (eval env f stk) (fun (v1, stk) ->
    match v1 with
    | VClosure (x, body ,env') -> bind (eval env e stk) (fun (v2, stk) ->
      eval (StringMap.add x v2 env') body stk
      )
    | VRecClosure (f, x ,body, env') -> bind (eval env e stk) (fun (v2, stk) ->
      eval (env' |> StringMap.add f v1 |> StringMap.add x v2) body stk
      )
    | _ -> None
    )
  | Throw -> None
  | TryCatch (e1, e2) -> let result = eval env e1 stk in
    ( match result with
    | Some (v, stk) -> return (v, stk)
    | None -> eval env e2 stk )
  | Ref e -> id := !id + 1; bind (eval env e stk) (fun (v1, stk) ->
    return ((VRef !id) , IntMap.add !id v1 stk)
    )
  | Deref i ->  bind (IntMap.find_opt i stk) (fun v1 -> return (v1 ,stk))
  | Assign (i, e) -> bind (eval env e stk) (fun (v1, stk) ->
    return ((VUnit) ,IntMap.add i v1 stk)
    )
  | Unit -> return (VUnit, stk)
  | FunRec (f, x, _, body, _) -> return (VRecClosure(f, x, body, env), stk)
  | Fix e1 ->
    bind (eval env e1 stk) (fun (v, stk) ->
      match v with
      | VClosure (x, body, env') ->
          let rec_closure = VRecClosure ("f", x, body, env') in
          eval (StringMap.add "f" rec_closure env') body stk
      | _ -> None
    )

let typ_id = ref 0

let rec type_checker (env : typ env) (stk : typ stack) (e: expr) : typ =
  let check (e : expr) (t : typ) =
  if (type_checker env stk e) = t then ()
  else failwith "type error" in
  match e with
  | Int i -> TInt
  | Bool b -> TBool
  | Var x -> (StringMap.find x env)
  | Add (e1, e2) -> check e1 TInt; check e2 TInt; TInt
  | Mul (e1, e2) -> check e1 TInt; check e2 TInt; TInt
  | Div (e1, e2) -> check e1 TInt; check e2 TInt; TInt
  | Sub (e1, e2) -> check e1 TInt; check e2 TInt; TInt
  | And (e1, e2) -> check e1 TBool; check e2 TBool; TBool
  | Or (e1, e2) -> check e1 TBool; check e2 TBool; TBool
  | If (e1, e2, e3) -> check e1 TBool;
    let t = type_checker env stk e2 in check e3 t; t
  | IsEqual (e1, e2) ->
    let t = type_checker env stk e1 in check e2 t; TBool
  | Let (x, e1, e2) ->
    let t = type_checker env stk e1
    in type_checker (StringMap.add x t env) stk e2
  | Fun (x, t, body) ->
    let t1 = type_checker (StringMap.add x t env) stk body
    in TLambda (t, t1)
  | FunRec (f, x, t, body, t2) ->
          TLambda (t, t2)
  | Unit -> TUnit
  | Apply (f, e) -> (match type_checker env stk f with
            | TLambda (t1, t2) -> check e t1; t2
            | _ -> failwith "type error")
  | TryCatch (e1, e2) ->
    let t = type_checker env stk e1 in check e2 t; t
  | Throw -> TUnit
  | Fix e -> (match type_checker env stk e with |
        TLambda (t1, t2) when t1 = t2 -> t1 | _ -> failwith "type error in Fix")
  | _ -> failwith "fatal error"
