(*task1*)
let x = 5 in
let f y = x + y + z in (*y -> zwiazane przez let g y, z -> wolne, x -> zwiazane przez let x = 5*)
f (x + 1) (*x -> zwiazany przez let x = 5, f -> zwiazane przez let f y*)

fun f ->
    let x = f 3 in (*f -> zwiazane przez fun f*)
    fun y -> x + (f y) + w (*x -> zwiazane przez let x = f 3, (f y) -> f zwiazane przez fun f, y -> zwiazane przez fun y, w -> wolne *)

let rec factorial n =
    if n <= 1 then 1 (*n -> zwiazane przez let wyzej*)
    else n * factorial (n-1) (*n, factorial zwiazane przez let rec factorial n*)
in factorial k (*k -> wolne, factorial -> zwiazane przez let rec factorial*)

fun g ->
    let h = fun x -> g x + y in (*g -> zwiazane przez fun g, x -> zwiazane przez fun x, y -> wolne*)
    fun y -> h (y + 1) (*h -> zwiazane przez let h, y > zwiazane przez fun y*)

let x = 10 in
let rec loop y =
    if y > 0 then x + loop (y - 1) (*y -> zwiazane przez let rec loop y, x -> zwiazane przez let x = 10, loop -> zwiazane przez let rec loop y*)
    else z (*z -> wolne*)
in loop x (*loop -> zwiazane przez let rec loop y, x -> zwiazane przez let x = 10*)

(*task2*)
fun f g x -> f (g x) (g x) (*typ: ('a -> 'a -> 'b) -> ('c -> 'a) -> 'c -> 'b *)
fun lst -> List.fold_left (fun acc x -> x :: acc) [] lst (*typ: 'a list -> 'a list *)
fun x -> x x (*BRAK TYPU*)
fun f -> fun opt -> match opt with | Some x -> f x | None -> None (*typ: ('a -> 'b option) -> 'a option -> 'b option *)
fun pred lst -> List.fold_left (fun (yes, no) x -> if pred x then (x :: yes, no) else (yes, x :: no)) ([], []) lst (*typ: ('a -> bool) -> 'a list -> ('a list * 'a list) *)


(*task3*)

(*typ: ('a -> 'b -> 'c) -> 'b -> 'a -> 'c *) fun f a b -> f b a
(*typ: ('a -> bool) -> 'a list -> ('a list * 'a list) *) fun pred lst -> List.fold_left (fun (yes, no) x -> if pred x then (x :: yes, no) else (yes, x :: no)) ([], []) lst
(*typ: 'a option -> ('a -> 'b) -> 'b option *) fun x f -> match x with | Some y -> Some (f y) | None -> None

(*task4*)
fun x ->
    let a = x + 1 in
    fun y ->
    let b = y * 2 in
    x + y

let rec f x =
    let a = fun y -> x + y in
    f (a x)

fun g ->
    let h = fun a -> a + 1 in
    fun b -> g (b 5)

(*task5*)
type 'a btree =
    | Leaf of 'a
    | Node of 'a btree * 'a btree

(*
a)
Predykat p jest spełniony gdy zachodzi:
    | p(Leaf a) : dla dowolnego a
    | p(t1) ^ p(t2) => p(Node(t1, t2)) : dla dowolnych t1, t2
Wtedy p spelnia kazde (t : 'a btree)

b)

1. Wezmy dowolne (a : 'a)
Wtedy
L = leaf_count Leaf a = 1
P = node_count Leaf a + 1 = 0 + 1 = 1
L = P

2. Wezmy dowolne t1, t2 i zal. ze p(t1) ^ p(t2)
Pokazmey dla Node(t1, t2)
L = leaf_count (Node(t1, t2)) = (*def*) leaf_count t1 + leaf_count t2 = (*z zal*) node_count t1 + 1 + node_count t2 + 1 = node_count t1 + node_count t2 + 2
P = node_count (Node(t1, t2)) + 1 = node_count t1 + node_count t2 + 1 + 1 = node_count t1 + node_count t2 + 2
L = P

*)


(*task6*)
(* a) *)
let return x = Some x
let bind m f = match m with | None -> None | Some y -> f y
let map2 f opt1 opt2 = match opt1, opt2 with
                        | Some x, None -> None
                        | None, Some y -> None
                        | x, y -> Some (bind x f, bind y f)

(*task7*)
let max_element lst = List.fold_left (fun acc x -> match acc with | None -> Some x | Some y -> Some (max x y) ) None lst
let zip_with_index lst = fst (List.fold_right (fun x (xs, idx) -> ((idx, x) :: xs, idx - 1)) lst ([] , List.length lst - 1))
let take_while p lst = List.fold_right (fun x acc -> if p x then acc else []) lst [] (*to dziala!!!*)
let insert_sorted e xs = match xs with [] -> [e] | _ -> List.rev (fst (List.fold_left (fun (lst, cond) x -> if
    (x > e && cond = false) then ( x :: e :: lst, true) else if (List.length xs - 1 = List.length lst) then (e :: x :: lst , true) else (x :: lst, cond)) ([], false) xs  ) )
let group_by_parity lst = List.fold_right (fun x (lst1, lst2) -> if x mod 2 = 0 then (x :: lst1, lst2) else (lst1, x :: lst2)) lst ([], [])

(*task8*)
type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree
let rec tree_fold f init t =
    match t with
    | Leaf -> init
    | Node(l, v, r) -> f (tree_fold f init l) v (tree_fold f init r)

let tree_to_list t = tree_fold (fun l v r -> l @ [v] @ r) [] t
let tree_max t = tree_fold (fun l v r -> max l (max v r)) None t

(*task9*)
(*

a)
S = aSa | B | eps
B = bB | eps

b)
num = 1 | 2 | 3 | ...
S = binop | eps
binop = E + E | (-E) | (E * E)
E = num
*)

(*task10*)
type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree
let tree_search x t = tree_fold (fun l v r -> (v = x) || l || r ) false t
let rec tree_insert x t =
    match t with
    | Leaf -> Node(Leaf, x, Leaf)
    | Node(l, v, r) -> if x > v then (tree_insert x r) else (tree_insert x l)
let tree_min t = tree_fold (fun l v r -> min (l (min v r))) None t

(*task11*)
type expr =
    | Int of int
    | Bool of bool
    | Var of string
    | Add of expr * expr
    | Sub of expr * expr
    | Mult of expr * expr
    | Eq of expr * expr
    | Lt of expr * expr
    | And of expr * expr
    | Or of expr * expr
    | Not of expr
    | If of expr * expr * expr
    | Let of string * expr * expr
    | Fun of string * expr
    | App of expr * expr
    | FunRec of string * string * expr
    | Pair of expr * expr
    | Fst of expr
    | Snd of expr
    | Fix of string * expr

type value =
    | VInt of int
    | VBool of bool
    | VPair of value * value
    | VClosure of string * expr * env
    | VRecClosure of string * string * expr * env
and env = (string * value) list

let rec lookup_env k lst =
    match lst with | [] -> failwith "not found" | (ky, v) :: rest -> if ky = k then v else (lookup_env k rest)

let rec eval e env =
    match e with
    | Int i -> VInt i
    | Bool b -> VBool b
    | Var s -> lookup_env s env
    | Add(e1, e2) -> (match eval e1 env, eval e2 env with
                    | VInt x, VInt y -> VInt (x + y)
                    | _ -> failwith "expected 2 ints."
                     )
    | Sub(e1, e2) -> (match eval e1 env, eval e2 env with
                    | VInt x, VInt y -> VInt (x - y)
                    | _ -> failwith "expected 2 ints."
                     )
    | Mult(e1, e2) -> (match eval e1 env, eval e2 env with
                    | VInt x, VInt y -> VInt (x * y)
                    | _ -> failwith "expected 2 ints."
                    )
    | Eq(e1, e2) -> (match eval e1 env, eval e2 env
                    | VInt x, VInt y -> VBool (x = y)
                    | VBool x, VBooly -> VBool (x = y)
                    | _ -> failwith "cannot compare this, probably 2 different types"
                    )
    | Lt(e1, e2) -> (match eval e1 env, eval e2 env
                    | VInt x, VInt y -> VBool (x < y)
                    | VBool x, VBooly -> VBool (x < y)
                    | _ -> failwith "cannot compare this, probably 2 different types"
                    )
    | And(e1, e2) -> (match eval e1 env, eval e2 env with
                    | VBool e1, VBool e2 -> VBool (e1 && e2)
                    | _ -> failwith "cannot compare this, expected 2 bools, got sth different"
                     )
    | Or(e1, e2) -> (match eval e1 env, eval e2 env with
                    | VBool e1, VBool e2 -> VBool (e1 || e2)
                    | _ -> failwith "cannot compare this, expected 2 bools, got sth different"
                     )
    | Not e ->      (match eval e env with
                    | VBool b -> VBool (not b)
                    | _ -> failwith "expected bool"
                    )
    | If(cond, e1, e2) -> (match eval cond env with
                    | VBool true -> eval e1 env
                    | VBool false -> eval e2 env
                    | _ -> failwith "condition must be bool"
                    )
    | Let(str, e1, e2) -> let new_val = eval e1 env in eval e2 ((str, new_val) :: env)
    | Fun(str, e) -> VClosure(str, e, venv)
    | App(e1, e2) -> let funkcja = eval e1 env in let arg = eval e2 env in (match funkcja with
                | VClosure(s, e, venv) -> eval e ((s, arg) :: venv)
                | VRecClosure(s1, s2, e, venv) -> eval e ((s1, funkcja) :: (s2, arg) :: venv)
                | _ -> failwith "cannot applied to not a function"
                )
    | FunRec(s1, s2, e) -> VRecClosure(s1, s2, e, env)
    | Pair(e1, e2) -> VPair (eval e1 env, eval e2 env)
    | Fst(e) -> (match eval e env with
                | VPair(x, _) -> x
                | _ -> failwith "expected pair"
                )
    | Snd(e) -> (match eval e env with
                | VPair(_, y) -> y
                | _ -> failwith "expected pair"
                )
    | Fix(s, e) -> eval e ((s, VRecClosure(s, s, e, env)) :: env)

(*task12*)
type instr =
    | Push of int
    | Add | Sub | Mult
    | Dup | Swap | MakePair
    | Fst | Snd
type value = VInt of int | VPair of value * value

let rec eval_stack instrs stack = match instrs with
    | [] -> stack
    | Push i :: rest -> eval_stack rest ((VInt i) :: stack)
    | Add :: rest -> (match stack with
        | VInt x :: VInt y :: xs -> eval_stack rest (VInt(x + y) :: xs)
        | _ -> failwith "error"
    )
    | Sub :: rest -> (match stack with
        | VInt x :: VInt y :: xs -> eval_stack rest (VInt(x - y) :: xs)
        | _ -> failwith "error"
    )
    | Mult :: rest -> (match stack with
        | VInt x :: VInt y :: xs -> eval_stack rest (VInt(x * y) :: xs)
        | _ -> failwith "error"
    )
    | Dup :: rest -> (match stack with
        | x :: xs -> eval_stack rest (x :: x :: xs)
        | _ -> failwith "error"
    )
    | Swap :: rest -> (match stack with
        |  x :: y :: xs -> eval_stack rest (y :: x :: xs)
        | _ -> failwith "error"
    )
    | MakePair :: rest -> (match stack with
        |  x :: y :: xs -> eval_stack rest (VPair(x, y) :: xs)
        | _ -> failwith "error"
    )
    | Fst :: rest -> (match stack with
        |  VPair(x, _) -> eval_stack rest (x :: xs)
        | _ -> failwith "error"
    )
    | Snd :: rest -> (match stack with
        |  VPair(_, y) -> eval_stack rest (y :: xs)
        | _ -> failwith "error"
    )
(*b)
(3 + 5, 2 * 4) -> [Push 4; Push 2; Mult; Push 5; Push 3; Add; MakePair]
*)