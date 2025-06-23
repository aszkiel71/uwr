type instruction =
    | Push of int
    | AddOp | MulOp | SubOp | DivOp

type expr =
    | Int of int
    | Add of expr * expr
    | Mult of expr * expr
    | Div of expr * expr
    | Sub of expr * expr

let rec compile e =
    match e with
    | Int i -> [Push i]
    | Add (e1, e2) -> (compile e1) @ (compile e2) @ [AddOp]
    | Mult (e1, e2) -> (compile e1) @ (compile e2) @ [MulOp]
    | Sub (e1, e2) -> (compile e1) @ (compile e2) @ [SubOp]
    | Div (e1, e2) -> (compile e1) @ (compile e2) @ [DivOp]

type value =
    | VInt of int

let rec eval (instr : instruction list) (stk : value list) =
  match instr with
      | [] -> stk
      | Push i :: rest -> eval rest (VInt i :: stk)
      | AddOp :: rest ->
        (match stk with
         | VInt x :: VInt y :: xs -> eval rest (VInt (x + y) :: xs)
         | _ -> failwith "got not enough elements")
      | SubOp :: rest ->
        (match stk with
         | VInt x :: VInt y :: xs -> eval rest (VInt (y - x) :: xs)
         | _ -> failwith "got not enough elements")
      | MulOp :: rest ->
        (match stk with
         | VInt x :: VInt y :: xs -> eval rest (VInt (x * y) :: xs)
         | _ -> failwith "got not enough elements")
      | DivOp :: rest ->
        (match stk with
         | VInt x :: VInt y :: xs -> eval rest (VInt (y / x) :: xs)
         | _ -> failwith "got not enough elements")

 let eval_expr instr = eval instr []