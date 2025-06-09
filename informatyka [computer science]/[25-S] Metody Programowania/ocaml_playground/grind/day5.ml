type value =
  | VInt of int
  | VBool of bool

type env = (string * value) list

type expr =
  | Int of int
  | Bool of bool
  | Var of string
  | Add of expr * expr
  | Sub of expr * expr
  | Mul of expr * expr
  | Div of expr * expr
  | Eq of expr * expr
  | Lt of expr * expr
  | Gt of expr * expr
  | Le of expr * expr
  | Ge of expr * expr
  | And of expr * expr
  | Or of expr * expr
  | Not of expr
  | Let of string * expr * expr
  | If of expr * expr * expr

let rec eval (env : env) (e : expr) : value =
  match e with
  | Int n -> VInt n
  | Bool b -> VBool b
  | Var x -> List.assoc x env

  | Add (e1, e2) ->
      begin match eval env e1, eval env e2 with
      | VInt n1, VInt n2 -> VInt (n1 + n2)
      | _ -> failwith "type error"
      end

  | Sub (e1, e2) ->
    match eval env e1, eval env e2 with
    | VInt n1, VInt n2 -> VInt (n1 - n2)
    | _ -> failwith "type error"

  | Mul (e1, e2) ->
    match eval env e1, eval env e2 with
    | VInt n1, VInt n2 -> VInt (n1 * n2)
    | _ -> failwith "type error"

  | Div (e1, e2) ->
    match eval env e1, eval env e2 with
    | VInt n1, VInt n2 -> VInt (n1 / n2)
    | _ -> failwith "type error"

  | Eq (e1, e2) ->
    match eval env e1, eval env e2 with
    | VInt n1, VInt n2 -> VBool (n1 = n2)
    | _ -> failwith "type error"

  | Lt (e1, e2) ->
    match eval env e1, eval env e2 with
    | VInt n1, VInt n2 -> VBool (n1 < n2)
    | _ -> failwith "type error"

  | Gt (e1, e2) ->
    match eval env e1, eval env e2 with
    | VInt n1, VInt n2 -> VBool (n1 > n2)
    | _ -> failwith "type error"

  | Le (e1, e2) ->
    match eval env e1, eval env e2 with
    | VInt n1, VInt n2 -> VBool (n1 <= n2)
    | _ -> failwith "type error"

  | Ge (e1, e2) ->
    match eval env e1, eval env e2 with
    | VInt n1, VInt n2 -> VBool (n1 >= n2)
    | _ -> failwith "type error"

  | And (e1, e2) ->
    match eval env e1, eval env e2 with
    | VBool n1, VBool n2 -> VBool (n1 && n2)
    | _ -> failwith "type error"

  | Or (e1, e2) ->
    match eval env e1, eval env e2 with
    | VBool n1, VBool n2 -> VBool (n1 || n2)
    | _ -> failwith "type error"

  | Not e1 ->
    match eval env e1 with
    | VBool n1 -> VBool (not n1)
    | _ -> failwith "type error"

  | Let (x, e1, e2) ->
      let v = eval env e1 in
      eval ((x, v) :: env) e2

  | If (cond, e1, e2) ->
      begin match eval env cond with
      | VBool true -> eval env e1
      | VBool false -> eval env e2
      | _ -> failwith "type error"
      end
