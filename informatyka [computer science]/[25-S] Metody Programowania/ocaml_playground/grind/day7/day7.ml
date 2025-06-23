(*task 2*)

(*
a) (int -> int -> 'a) -> int -> int -> 'a
b) int list -> int
c) ('a -> 'a) -> 'a -> 'a
d) type error
e) int = 42
f) int list -> int
g) 'a list -> int
h) ('a -> bool) -> ('a -> bool) -> 'a -> bool
*)

(*task 3*)
a) let exist p lst = List.fold_left (fun acc x -> if p x then true else acc) false lst
b) let find_index elem lst = fst (List.fold_left (fun acc x -> if (snd (snd acc)) = false then if
                                                  x = elem then (fst (snd acc), (fst (snd acc) , true))
                                                  else (-1, (fst (snd acc) + 1, false))
                                                  else acc) (-1, (0, false)) lst)

c) let take n lst = List.rev (List.fold_left (fun acc x -> if List.length acc < n then x :: acc else acc) [] lst)
d) let partition p lst = List.fold_left (fun acc x -> if p x then ((x :: fst acc), (snd acc)) else (fst acc, x :: snd acc)) ([], []) lst

(*------------*)

type 'a btree =
    | Leaf
    | Node of 'a btree * 'a * 'a btree

let rec tree_size t =
    match t with
    | Leaf -> 0
    | Node(l, _, r) -> 1 + tree_size l + tree_size r

let rec tree_depth t =
    match t with
    | Leaf -> 0
    | Node(l, _, r) -> 1 + max (tree_depth l) (tree_depth r)

let rec in_order t =
    match t with
    | Leaf -> []
    | Node(l, v, r) -> (in_order l) @ [v] @ (in_order r)

let rec tree_fold f acc t =
    match t with
    | Leaf -> acc
    | Node(l, v, r) -> f (tree_fold f acc l) v (tree_fold f acc r)


type 'a sized_list = {
    data: 'a list;
    length: int;
}

let sl_empty lst = {data = []; length = 0}
let sl_cons x lst = {data = x :: lst.data;
                    length = lst.length + 1;}
let sl_append lst1 lst2 = {data = lst1.data @ lst2.data;
                           length = lst1.length + lst2.length}
(*__________________*)
(*task5*)

type expr =
    | Int of int
    | Bool of bool
    | Var of string
    | Add of expr * expr
    | Mul of expr * expr
    | Eq of expr * expr
    | Lt of expr * expr
    | If of expr * expr * expr
    | Let of string * expr * expr

type value =
    | VInt of int
    | VBool of bool

type env = (string * value) list

let rec eval env e =
    match e with
    | Int n -> VInt n
    | Bool b -> VBool b
    | Var x -> List.assoc x env
    | Add(e1, e2) -> match (eval env e1, eval env e2) with
                | (VInt v1, VInt v2) -> VInt (v1 + v2)
                | _ -> failwith "type error"
    | Mult(e1, e2) -> match (eval env e1, eval env e2) with
                | (VInt v1, VInt v2) -> VInt (v1 * v2)
                | _ -> failwith "type error"

    | Eq(e1, e2) -> match (eval env e1, eval env e2) with
                | (VInt v1, VInt v2) -> VBool ( v1 = v2 )
                | (VBool v1, VBool v2) -> VBool ( v1 = v2 )
                | _ -> failwith "type error"
    | Lt(e1, e2) -> match (eval env e1, eval env e2) with
                | (VInt v1, VInt v2) -> VBool ( v1 < v2 )
                | _ -> failwith "type error"

    | If(cond, e1, e2) -> match eval env cond with
                | VBool true -> eval env e1
                | VBool false -> eval env e2
                | _ -> failwith "type error"

    | Let(v, e1, e2) -> let val1 = eval env e1 in let new_env = (v, val1) :: env in eval new_env e2

(*maszyna stosowa --- zadanie 6*)

type instruction =
    | Push of int
    | Add | Mult | Sub
    | Load of string
    | Store of string
    | Jump of int
    | JumpIfZero of int

type machine_state = {
    stack: int list;
    vars: (string * int) list;
    pc: int;
}

let rec execute_instruction instr state =
    match instr with
    | Push n -> {stack = n :: state.stack;
                 vars = state.vars;
                 pc = state.pc}
    | Add -> {stack =
                   match state.stack with
                   | x :: y :: xs -> (y + x) :: xs
                   | _ -> failwith "needed at least 2 args";
                   vars = state.vars;
                   pc = state.pc}
    | Mult -> {stack =
                   match state.stack with
                   | x :: y :: xs -> (y * x) :: xs
                   | _ -> failwith "needed at least 2 args";
                   vars = state.vars;
                   pc = state.pc}
    | Sub -> {stack =
                   match state.stack with
                   | x :: y :: xs -> (y - x) :: xs
                   | _ -> failwith "needed at least 2 args";
                   vars = state.vars;
                   pc = state.pc}
   | Load v -> {stack = (List.assoc v state.vars) :: state.stack;
                vars = state.vars;
                pc = state.pc}
   | Store v -> {stack = match state.stack with
                        | x :: xs -> xs
                        | _ -> failwith "needed at least 1 arg to store";
                vars = match state.stack with
                        | x :: xs -> (v, x) :: state.vars
                        | _ -> failwith "even not possible";
                pc = state.pc
                }
   | Jump idx -> {stack = state.stack;
                  vars = state.vars;
                  pc = idx} (*zakladamy, ze dajemy poprawne instrukcje*)
   | JumpIfZero idx ->
    match state.stack with
        | 0 :: xs -> { state with stack = xs; pc = idx }
        | x :: xs -> { state with stack = xs; pc = state.pc }
        | [] -> failwith "Stack underflow"

let rec run_program program state =
 if state.pc >= Array.length program then state
 else
   let current_instr = program.(state.pc) in
   let new_state = execute_instruction current_instr state in
   let final_state =
     match current_instr with
     | Jump _ | JumpIfZero _ -> new_state
     | _ -> { new_state with pc = new_state.pc + 1 }
   in
   run_program program final_state


(*task 9*)
let option_map f a =
    match a with
    | Some x -> Some (f x)
    | None -> None

let option_bind a f =
    match a with
    | Some x -> f x
    | None -> None

