let sum_list lst = List.fold_left (fun acc x -> x + acc) 0 lst
let product_list lst = List.fold_left (fun acc x -> x * acc) 1 lst
let length_list lst = List.fold_left (fun acc x -> 1 + acc) 0 lst
let reverse_list lst = List.fold_left (fun acc x -> x :: acc) [] lst
let max_list lst = List.fold_left (fun acc x -> match acc with | None -> Some x | Some y -> Some (max x y)) None lst
let concat_strings lst = List.fold_right (fun x acc -> x ^ acc) lst ""
let filter_positive lst = List.fold_right (fun x acc -> if x > 0 then (x::acc) else acc) lst []
let map_double lst = List.fold_right (fun x acc -> 2*x :: acc) lst []
let count_true lst = List.fold_left (fun acc x -> if x then (1+acc) else acc) 0 lst
let all_even lst = List.fold_left (fun acc x -> if (x mod 2) = 0 then false else acc) true lst

type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree

let rec fold_left f acc lst =
    match lst with
    | [] -> acc
    | x :: xs -> fold_left f (f acc x) xs

let rec fold_right f lst acc =
    match lst with
    | [] -> acc
    | x :: xs -> f x (fold_right f xs acc)


let rec fold_tree f acc t =
    match t with
    | Leaf -> acc
    | Node(l, v, r) -> f (fold_tree f acc l) v (fold_tree f acc r)

let extree1 = Leaf
let extree2 = Node (Leaf, 5, Leaf)
let extree3 = Node (Node (Leaf, 2, Leaf), 10, Node (Leaf, 15, Leaf))
let extree4 = Node (Leaf, "apple", Node (Leaf, "banana", Leaf))
let extree5 = Node (Node (Leaf, -2, Leaf), 10, Node (Leaf, -15, Leaf))

let sum_tree t = fold_tree (fun l v r -> l + v + r) 0 t
let count_nodes t = fold_tree (fun l _ r -> 1 + l + r) 0 t
let height_tree t = fold_tree (fun l _ r -> 1 + max l r) 0 t
let collect_values t = fold_tree (fun l v r -> l @ [v] @ r) [] t
let all_positive t = fold_tree (fun l v r -> v >= 0 && l && r) true t


let rec length lst =
    match lst with
    | [] -> 0
    | _ :: xs -> 1 + length xs

let rec reverse lst =
     match lst with
     | [] -> []
     | x :: xs -> reverse xs @ [x]

let rec count_leaves t =
    match t with
    | Leaf -> 1
    | Node(l, _, r) -> count_leaves l + count_leaves r

let rec mirror_tree t =
    match t with
    | Leaf -> Leaf
    | Node(l, v, r) -> Node(mirror_tree r, v, mirror_tree l)

(*
A) length(reverse lst) = length(lst)
1. Pokazmy dla lst = []:
L = length(reverse []) = length( [] ) = P
2. Zal. ze zachodzi dla xs. Pokazmy dla x :: xs.
(*LEMMA: length (xs @ ys) = length(xs) + length(ys)
1. xs = []:
length([] @ ys) = length(ys)
2. zal. ze dla xs.
Cel: dla x :: xs zachodzi
length(x :: xs @ ys) = 1 + length(xs @ ys) = (*zal*) = 1 + length(xs) + length(ys)
*)
L = length(reverse (x :: xs)) = length(xs @ [x]) = length(xs) + length([x]) = 1 + length(xs)
P = length(x :: xs) = 1 + length(xs)

B) reverse(xs @ ys) = reverse ys @ reverse xs
1. xs = []
reverse([] @ ys) = reverse(ys) = reverse ys @ reverse( [] ) = reverse(ys)
2. wezmy dow. xs i zal. ze zachodzi. pokazemy dla x :: xs.
reverse(x :: xs @ ys) = reverse (xs @ ys) @ [x] = (z zal) reverse(ys) @ reverse(xs) @ [x]

C)
count_leaves (mirror t) = count_leaves t
1. t = Leaf
wtedy:
L = count_leaves (mirror Leaf) = count_Leaves ( Leaf ) = P
2. wezmy dow. t i zal. ze count_leaves (mirror l) = count_leaves l and count_leaves (mirror r) = count_leaves r
Pokazemy, ze count_leaves(mirror t) = count_leaves(t)

L = count_leaves(mirrot t) = count_leaves (Node(mirror r, v, mirror l)) = (*def*) =
count_leaves (mirror r) + count_leaves (mirror l) = (*z zal*) =
count_leaves (r) + count_leaves (l)
P = count_leaves(Node(l, v, r)) = (*def*) = count_leaves (l) + count_leaves (r) = L

Q.E.D.
*)

type expr =
    | Var of string
    | Add of expr * expr
    | Mult of expr * expr

type 'a rlist =
    | Empty
    | Single of 'a
    | Concat of 'a rlist * 'a rlist

(*zasady indukcji:
A) Powiemy, ze predykat p spelnia expr gdy:
1. p(x) : dla kazdego x
2. p(e1) ^ p(e2) => p(e1 + e2)  : dla dowolnych e1, e2
3. p(e1) ^ p(e2) => p(e1 * e2)  : dla dowolnych e1, e2

B) Powiemy, ze predykat p spelnia 'a rlist gdy:
1) p(Empty)
2) p(x) : dla kazdego 'a x
3) p(e1) ^ p(e2) => p(Concat(e1, e2))  : dla dowolnych e1, e2

*)

fun x -> x + 1 (*typ: int -> int *)
fun f x -> f (f x) (*typ: ('a -> 'a) -> 'a -> 'a *)
fun x y -> if x > 0 then y else (y+1) (*typ: int -> int -> int *)
fun f g x -> f (g x) (*typ: ('b -> 'c) -> ('a -> 'b) -> 'a -> 'c *)
fun x -> (x, x) (*typ: 'a -> a' * 'a *)
fun (x, y) -> x + y (*typ: int * int -> int *)
fun f lst -> List.map f lst (*typ: ('a -> 'b) -> 'a list -> 'b list *)
fun x y z -> x (y z) (*typ: ('b -> 'c) -> ('a -> 'b) -> 'a -> 'c*)
fun pred lst -> List.filter pred lst (*typ: 'a -> bool -> 'a list -> 'a list*)
fun f acc lst -> List.fold_left f acc lst (*typ: ('a -> 'b -> 'a) -> 'a -> 'a list -> 'a *)

(*typ: int -> int -> int*)
fun x y -> y + x
(*typ: 'a -> 'a list *)
fun x -> [x]
(*typ: ('a -> 'b) -> 'a list -> 'b list *)
fun f lst1 -> List.map f lst1
(*typ: 'a list -> 'a list -> 'a list *)
fun lst1 lst2 -> lst1 @ lst2
(*typ: ('a -> bool) -> 'a list -> 'a list *)
fun p lst -> match lst with | [] -> [] | x :: xs -> if p x then xs else lst
(*typ: 'a -> 'b -> 'a *)
fun a b -> a
(*typ: ('a -> 'b -> 'c) -> 'b -> 'a -> 'c *)
fun f a b -> f b a
(*typ: 'a option -> 'a -> 'a *)
fun a b -> match a with | Some x -> x | None -> b
(*typ: ('a -> 'a -> bool) -> 'a list -> 'a list *)
fun f lst1 -> match lst1 with | [] -> [] | [x] -> [x] | x :: y :: ys -> if f x y then ys else x :: y :: ys
(*typ: int -> (int -> int) -> int *)
fun x f -> (f x) + x

let rec flatten_tree t =
    match t with
    | Leaf -> []
    | Node(l, v, r) -> (flatten_tree l) @ [v] @ (flatten_tree r)

let rec map_tree f t =
    match t with
    | Leaf -> Leaf
    | Node(l, v, r) -> Node(map_tree f l, f v, map_tree f r)

type gramma1 =
    | Block_B of int
    | WrapAC of gramma1

type gramma2 =
    | Empty
    | Paren of gramma2
    | Concat of gramma2 * gramma2


type expr =
    | Int of int
    | Add of expr * expr
    | Mult of expr * expr

type instr =
    | Push of int
    | AddOp
    | MultOp

let rec compile e =
    match e with
    | Int n -> [Push n]
    | Add(e1, e2) -> (compile e2) @ (compile e1) @ [AddOp]
    | Mult(e1, e2) -> (compile e2) @ (compile e1) @ [MultOp]

