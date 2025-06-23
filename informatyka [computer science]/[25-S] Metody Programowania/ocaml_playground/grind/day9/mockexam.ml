(*task 1*)

let f x = x + y in (*x -> zwiazany przez let f x, y -> zwiaznay przez let y = 5*)
    let y = 5 in
    f (y + 1) (* y -> zwiazany przez let y = 5 *)

let rec map f lst =
    match lst with (*lst zwiazane przez let rec map f lst*)
    | [] -> []
    | h :: t -> f h :: map f t (*pierwszy f, zwiaznay przez let rec map f ..., drugi f wolny, drugi t wolny
    drugie h w tej linijce zwiazany przez h :: t,*)
in map (*map zwiazany przez let rec map ...*)

fun x ->
    let y = x + z in (*x -> zwiaznae przez fun x, z -> wolne*)
    fun z -> x + y + z (*x -> zwiazany przez fun x, y -> zwiazany przez let y, z -> zwiaznay ptzez fun z*)

let x = 10 in
    let f = fun y -> x + y in (*x -> zwiazany przez let x = 10, y -> zwiazany przez fun y*)
         let x = 20 in f x (*x zwiazany przez let x = 20, f -> zwiaznae przez let f = ...*)

(*task 2*)
a)  fun f x -> f (f x)
    typ: ('a -> 'a) -> 'a -> 'a
b)  fun x y z -> if x then y else z
    typ: bool -> 'a -> 'a -> 'a
c)  fun f g x -> f x && g x
    typ: ('a -> bool) -> ('a bool) -> 'a -> bool
d)  let rec length lst =
        match lst with
        | [] -> 0
        | _ :: t -> 1 + length t in length
    typ: 'a list -> int
e)  fun x -> (x 1, x "hello")
    typ: blad typu
f)  fun lst -> match lst with
            | [x; y] -> x + y
            | _ -> 0
    typ: int list -> int

(*task3*)

a)
let rec merge_lists pr =
    match pr with
    | ([], []) -> ([])
    | (x :: xs, y :: ys) -> x :: y :: (merge_lists (xs, ys))
    | _ -> failwith "lists should have got same length"

let rec lists_equal pr =
    match pr with
    | ([], []) -> true
    | (_ :: xs, _ :: ys) -> lists_equal (xs, ys)
    | (_ :: xs, []) -> false
    | ([], y :: ys) -> false

b)
let compose pr x = snd pr (fst pr x)
let apply_both pr x = (fst pr x, snd pr (fst pr x))

c)
let flatten_option x = match x with (*nie wiem, czy dobrze ta funkcja zwraca cos, ale typ pasuje, a o to mi chodzilo w zadaniu*)
    | Some (Some x) -> Some x
    | None -> None
    | _ -> failwith "type error"

let is_some_some x = match x with
    | Some (Some x) -> true
    | None -> false
    | _ -> failwith "type error"

(*task 4*)
type 'a tree =
    | Empty
    | Node of 'a tree * 'a * 'a tree

(*
Zasada indukcji:
Powiemy, że predykat p, spełnia drzewo t typu 'a tree, jesli:
| P(Empty)
| Jesli dla dowolnych drzew, t1, t2 i dowolnego v typu 'a zachodzi P(t1) and P(t2) and P(v) to
  P(Node(t1, v, t2))
*)

type expr =
    | Var of string
    | Add of expr * expr
    | Mul of expr * expr

(*
Zasada indukcji:
Powiemy, że predykat p, jest spełniony jesli:
| P(x) dla kazdego x
| Dla dowolnych e1, e2: jesli p(e1) and p(e2) to p(Add(e1, e2))
| Dla dowolnych e1, e2: jesli p(e1) and p(e2) to p(Mul(e1, e2))

*)


(*task 5*)
a)
Zal. ze mamy takie definicje:

let rec length lst =
    match lst with
    | [] -> 0
    | _ :: xs -> 1 + length lst

let rev lst =
    let rec rev_acc acc lst =
        match lst with
            | [] -> acc
            | hd :: tl -> rev_acc (hd :: acc) tl
    in rev_acc [] lst

Zauwazmy, ze:
let rev lst = rev_acc [] lst
Pokazemy najpierw podzadanie nr 1: rev (x :: xs) = rev(xs) @ [x]
Dla xs = []:
rev (x :: []) = rev_acc [x] [] = [x]
Zal. ze dla x :: xs zachodzi. Wtedy pokazemy dla y :: x :: xs
rev(x :: y :: xs) = rev_acc [y] [x :: xs],
a przeciez rev (x :: xs) = rev_acc [x] xs = xs @ [x] (*z zal. indukcyjnego*)
rev_acc [y] [x :: xs] = rev_acc [x; y] [xs] (*tu nwm jak ten lemat dokonczyc*)

Podzadanie nr 2:
length(xs @ ys) = length(xs) + length(ys)
1. xs = [], ys dow.
Wtedy length(xs @ ys) = length(ys) = length(xs) + length(ys) = 0 + length(ys)
L = P
2. xs dow. ys = []. symetrycznie
3. wezmy dow. xs i zal. ze length(xs @ ys) = length(xs) + length(ys).
Pokazemy dla x :: xs
L = length(x :: xs @ ys) = 1 + length(xs @ ys) = (*z zal. indx*) 1 + length(xs) + length(ys)
P = length(x :: xs) + length(ys) = 1 + length(xs) + length(ys) = L


Pokazemy, ze length ( rev lst ) = length lst
1. Dla lst = [] mamy:
   L = length ( rev [] ) = length ( [] ) = 0
   P = length ( [] ) = 0 = L
2. Wezmy dow. xs i zal. ze length ( rev xs ) = length xs
   Pokazemy, ze zachodzi dla x :: xs:
   L = length ( rev (x :: xs) ) = length ( rev xs @ [x] ) = length (rev xs) + length [x] = (*z zal indukcjnego*) length xs + 1
   P = length (x :: xs) = 1 + length xs = L

   QED

b)
Zal. definicje:

let rec tree_height t =
    match t with
    | Leaf -> 0
    | Node(l, _, r) -> 1 + max (tree_height l) (tree_height r)

let rec mirror_tree t =
    match t with
    | Leaf -> Leaf
    | Node(l, v, r) -> Node(mirror_tree r, v, mirror_tree l)

Cel: p(t) := tree_height (mirror_tree t) = tree_height t
Wezmy dow. t = (l, v, r)
Zal. ze p(l) ^ p(r)
Pokazemy, ze p(t)

(*powinno byc oczywiscie Node(l, v, r) ale dla uproszczenia nie pisze :)) *)
L = tree_height (mirror_tree (l, v, r)) = (*def*) tree_height (mirror_tree r, v mirror_tree l) = (*def*)
= 1 + max (tree_ height (mirror_tree r)) (tree_height (mirror_tree l)) = (*zal indk*)
1 + max (tree_height r) (tree_height l)

P = tree_height (l, v, r) = 1 + max (tree_height l) (tree_height r) = 1 + (tree_height r) (tree_height l) = L
QED

(*task 6*)

type expr =
    | Num of int
    | Add of expr * expr
    | Mul of expr * expr
(* () niepotrzebne w AST *)
type num = int (*tu nie wiem czy dobrze*)

"2 + 3 * 4" = Add(2, Mul(3, 4))


Expr ::= Let of string * expr | Var of string | If of expr * expr * expr | Blok of expr list | While of expr * stmt

(*task 7*)

type expr =
    | Num of int
    | Bool of bool
    | Var of string
    | Add of expr * expr
    | Sub of expr * expr
    | Eq of expr * expr
    | Lt of expr * expr
    | And of expr * expr
    | Or of expr * expr
    | If of expr * expr * expr
    | Let of string * expr * expr
    | Fun of string * expr
    | App of expr * expr
    | Fix of string * expr

type value =
    | VInt of int (*zamiast VNum*)
    | VBool of bool
    | VFun of string * expr * env
and env = (string * value) list

let rec eval env e =
    match e with
    | Num e -> VInt e
    | Bool e -> VBool e
    | Var e -> env.assoc e
    | Add(e1, e2) ->
        match (eval env e1, eval env e2) with
        | (e1, e2) -> VInt (e1 + e2)
        | _ -> failwith "type error"
    | Sub(e1, e2) ->
        match (eval env e1, eval env e2) with
        | (e1, e2) -> VInt (e1 - e2)
        | _ -> failwith "type error"
    | Eq(e1, e2) ->
        match (eval env e1, eval env e2) with
        | (e1, e2) -> VBool (e1 = e2)
        | _ -> failwith "type error"
    | Lt(e1, e2) ->
        match (eval env e1, eval env e2) with
        | (e1, e2) -> VBool (e1 < e2)
        | _ -> failwith "type error"
    | And(e1, e2) ->
        match (eval env e1, eval env e2) with
        | (e1, e2) -> VBool (e1 && e2)
        | _ -> failwith "type error"
    | Or(e1, e2) ->
        match (eval env e1, eval env e2) with
        | (e1, e2) -> VBool (e1 || e2)
        | _ -> failwith "type error"
    | If(cnd, yes, no) ->
        match (eval env cnd) with
         | VBool true -> (eval env yes)
         | VBool false -> (eval env no)
         | _ -> failwith "type error"
    | Let(vl, e1, e2) ->
        let val1 = eval env e1 in let new_env = (v, val1) :: env in eval new_env e2
    | _ (*nie umiem zaimplementowac, potem do tego wrocimy*)

b), c) (*nie umime, potem do tego wrocimy*)

(*task 8*)

nie wiem, musze pocwiczyc

(*task 9*)

type simple_expr =
    | SNum of int
    | SAdd of simple_expr * simple_expr
    | SMul of simple_expr * simple_expr

type instruction =
    | Push of int
    | Add
    | Mul

type machine = { stack: int list }

a)

let rec compile e =
    match e with
    | SNum e -> Push e
    | SAdd(e1, e2) -> SNum (e1 + e2)
    | SMul(e1, e2) -> SNum (e1 * e2)

b)

let rec execute instlst maszyna =
    match instlst with
    | Push e :: xs -> execute xs (stack = e :: maszyna.stack)
    | Add :: rest -> match maszyna with
            | x :: y :: xs -> execute rest (stack = (y + x) :: xs)
            | _ -> failwith "need at least 2 args"
    | Mul :: rest -> match maszyna with
        | x :: y :: xs -> execute rest (stack = (y * x) :: xs)
        | _ -> failwith "need at least 2 args"
    | _ -> failwith " not implemented"

c)
2 + 3 * 4 :== [Push 3, Push 4, Push 2, Mul, Add] (*mul: bierze 3, 4 i kladzie 12 na stos, add bierze 12, 2 i dodaje*)


(*task 10*)

type simple_expr =
    | SNum of int
    | SAdd of simple_expr * simple_expr
    | SMul of simple_expr * simple_expr

let rec optimize e =
    match e with
    | SNum e -> e
    | SAdd(e1, e2) -> if optimize e1 = 0 then e2 else if optimize e2 = 0 then e1 else (e1 + e2)
    | SMul(e1, e2) -> if optimize e1 = 1 then e2 else if optimize e2 = 1 then e1 else (e1 * e2)
    | SMul(e1, e2) -> if optimize e1 = 0 then 0 else if optimize e2 = 0 then 0 else (e1 * e2)
