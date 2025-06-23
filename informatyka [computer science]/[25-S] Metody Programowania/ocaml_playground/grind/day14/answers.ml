(*task1*)
let f x =
    let x = x (*x -> zwiazane przez let f x*)
    and y = x + y in (*x -> zwiaznae przez let f x, y -> przez and y*)
f x y z (*z -> wolne*) (*x -> zwiazane przez let x = x, y -> zwiazane przez and y*)

fun f x ->
    let x = x + y in (*x -> zwiazane przez fun f x, y -> wolne*)
    let z = x + y in (*x -> zwiazane przez let x, y -> wolne*)
    fun y -> g x y z (*g x y z -> g -> wolne, x -> zwiazane przez let x, y -> zwiazane przez fun y
                      z -> zwiazane przez let z*)

let rec f x =
    let g y = x + y in (*x -> zwiazane przez let rec f x, y -> zwiazane przez let g y*)
    if g x > g y (*x -> zwiazane przez let rec f x, g -> zwiazane przez let g y, y -> zwiazane przez let g y*)
    then g (f x) else h y (*g -> zwaizane przez let g y, (f x) zwiazane przez let rec f x,
                            h -> wolne, y -> zwiazane przez let g y*)

(*task2*)
fun x y -> x + y > 2 (*typ: int -> int -> bool *)
fun x y z -> x y && z (* ('a -> bool) -> 'a -> bool -> bool *)
fun x y z -> x z (y z) (*typ: ('a -> 'b -> 'c) -> ('a -> 'b) -> 'a -> 'c *)
fun f -> (fun x -> f x x) (fun x -> f x x) (*type error*)
fun f x -> f (f x) > x (*typ: ('a -> 'a) -> 'a -> bool *)
fun f x -> f (f x) && x > 0 (*typ: type error*)

(*task3*)
let product f xs = List.fold_left (fun acc x -> acc * (f x)) 1 xs
let reverse xs = List.fold_left (fun acc x -> x :: acc) [] xs
let map f xs = List.fold_right (fun x acc -> (f x) :: acc) xs []

(*task4*)
(*
np. () moze byc wyprowadzone jako:
S -> (S) -> ()
S -> (S) -> (SS) -> (S) -> ()
*)

(*zadanie 5*)
type value =
    | VInt of int
    | VRef of string * int
    | VClosure of sting * expr * env
    | VExn of string

(*zadanie 6*)
type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree

let split_list lst =
  let len = List.length lst in
  if len = 0 then ([], None, [])
  else
    let mid_idx = len / 2 in
    let left_half = take mid_idx lst in
    let middle_val = List.nth lst mid_idx in
    let right_half = drop (mid_idx + 1) lst in
    (left_half, Some middle_val, right_half)

let rec take n xs =
  match xs with
  | [] -> []
  | h :: t -> if n > 0 then h :: (take (n - 1) t) else []


let rec drop n xs =
  match xs with
  | [] -> []
  | _ :: t -> if n > 0 then drop (n - 1) t else xs

let list_to_balanced_tree xs =
  let rec it lst =
    match split_list lst with
    | ([], None, []) -> Leaf
    | (left_part, Some v, right_part) ->
        Node (it left_part, v, it right_part)
    | _ -> failwith "type error"
  in
  it xs

(*tak, geneurje nieuzytki*)

(*task7
type 'a tree =
    | Leaf
    | Node of 'a tree * 'a * 'a tree

Powiemy, ze predykat p spelnia drzewo (t : 'a tree) gdy zachodzi:
    | P(Leaf)
    | Dla dowolnego v i drzewa Node(l, v, r):
    p(l) ^ p(r) => p(Node(l, v, r)

*)

type var = string
type expr =
    | Unit
    | Num of int
    | Var of var
    | Seq of expr * expr
    | Fun of var * tp * expr
    | App of expr * expr
    | Fix of var * tp * tp * var * expr
    | ArrayNew of expr * expr
    | ArrayGet of expr * expr
    | ArraySet of expr * expr * expr

type tp =
    | TUnit
    | TInt
    | TArrow of tp * tp
    | TArray of tp

let rec infer_type env e ->
    match e with
    | ...
    | App(e1, e2) -> match infer_type e1 with
        | TArrow(tp, tp') -> check_type env e2 tp

type op = Add | Sub
type cmd = Int of int | Op of op
type prog = cmd list

let rec eval_vm p stack =
    match p, stack with
    | [], [k] -> k
    | Int k :: p, s -> eval_vm p (k :: s)
    | Op op :: p, e2 :: e1 :: s -> eval_vm p (eval_op e1 e2 :: s)

let eval p = eval_vm p []

let rec calc_stack_length p =
    let rec it p sz =
    match p with
    | (Int i) :: rest -> 1 + (calc_stack_length rest)
    | (Op op) :: rest -> max sz ((calc_stack_length rest) - 1) (*2 schodza, 1 wchodzi*)
    | [] -> 0
    in it p 0