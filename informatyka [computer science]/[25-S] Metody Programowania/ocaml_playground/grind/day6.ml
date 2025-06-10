type 'a tree =
    | Leaf
    | Node of 'a tree * 'a * 'a tree

let rec mirror_tree t =
    match t with
    | Leaf -> Leaf
    | Node(l, v, r) -> Node(mirror_tree r, v, mirror_tree l)

let rec count_leaves t =
    match t with
    | Leaf -> 1
    | Node(l, _, r) -> count_leaves l + count_leaves r

let rec tree_height t =
    match t with
    | Leaf -> 0
    | Node(l, _, r) -> 1 + max (tree_height l)  (tree_height r)

let rec tree_sum t =
    match t with
    | Leaf -> 0
    | Node(l, v, r) -> v + tree_sum l + tree_sum r

let rec tree_map f t =
    match t with
    | Leaf -> Leaf
    | Node(l, v, r) -> Node(tree_map f l, f v, tree_map f r)

let rec tree_fold f acc t =
    match t with
    | Leaf -> acc
    | Node(l, v, r) -> f (tree_fold f acc l) v (tree_fold f acc r)

let rec is_balanced t =
    match t with
    | Leaf -> true
    | Node(l, _, r) -> if (abs (tree_height l - tree_height r) > 1) then false
        else is_balanced l && is_balanced r

(*ponumeruj dfs, v -> (v, time) *)

let dfs t =
    let rec it time tree =
        match tree with
        | Leaf -> (time, Leaf)
        | Node (l, v, r) -> (time, Node((it (time+1) l), v, it (time + 1) r))
        in it 0 t

(*dowody indukcyjne
A6)

Pokaż, że count_leaves (mirror_tree t) = count_leaves t
1. Rozważmy t = Leaf;
Wtedy:
L = count_leaves (mirror_tree Leaf) = count_leaves Leaf = R

2.
Wezmy dowolny t = (l, v, r)
i zakladamy, ze zachodzi P(l), P(r)
Cel: P(t).
L = count_leaves (mirror_tree (l, v, r)) =
count_leaves ( (mirror_tree r, v, mirror_tree l) ) =
count_leaves (mirror_tree r) + count_leaves (mirror_tree l) =
count_leaves l + count_leaves r  = R
(z zal. indukcyjnego)

A7)

Pokaż, że tree_height t >= 0 dla dowolnego t.
1. t = Leaf
wtedy tree_height Leaf = 0 >= 0

2. Wezmy dowolny t = (l, v, r) i zal. ze P(l) and P(r)
Pokazemy, ze P(t).

tree_height (l, v, r) = 1 + max (tree_height l) (tree_height r)
Z zal. indukcyjnego tree_height l >= 0 oraz tree_height r >= 0
Wtedy 1 max (tree_height l) (tree_height r) >= 0 (2 nieujemne rzeczy dodane do siebie sa nieujemne, i max z 2 nieujemnych gwarantuje nieujemnosc)
*)

(*Part B*)

type expr =
    | Num of int
    | Add of expr * expr
    | Mult of expr * expr
    | Let of string * expr * expr
    | Eq of expr * expr
    | Var of string
    | Lt of expr * expr
    | If of expr * expr * expr
    | True of bool
    | False of bool

let rec eval_expr (e : expr) : int =
    match e with
    | Num e -> e
    | Add (e1, e2) -> eval_expr e1 + eval_expr e2
    | Mult (e1, e2) -> eval_expr e1 * eval_expr e2
    | _ -> failwith "not implemented until we got env"

let rec expr_to_string (e : expr) : string =
    let rec it e acc =
        match e with
        | Num e -> string_of_int e ^ acc
        | Add(e1, e2) -> "Add(" ^ expr_to_string e1 ^ "," ^ expr_to_string e2 ^ ")"
        | Add(e1, e2) -> "Mult(" ^ expr_to_string e1 ^ "," ^ expr_to_string e2 ^ ")"
        | _ -> failwith "type error"
    in it e ""

let rec count_operations e =
    match e with
    | Num e -> 0
    | Add(e1, e2) -> 1 + count_operations e1 + count_operations e2
    | Mult(e1, e2) -> 1 + count_operations e1 + count_operations e2
    | _ -> failwith "not implemented"

let rec optimize e =
    match e with
    | Num e -> e
    | Add(e1, e2) ->
        match (eval_expr e1, eval_expr e2) with
        | (0, x) -> x
        | (x, 0) -> x
        | (v1, v2) -> v1 + v2
        | _ -> failwith "type error"
    | Mult(e1, e2) ->
        match (eval_expr e1, eval_expr e2) with
        | (0, x) -> 0
        | (x, 0) -> 0
        | (1, x) -> x
        | (x, 1) -> x
        | (v1, v2) -> v1 * v2
        | _ -> failwith "type error"
    | _ -> eval_expr e

(*Czesc C*)

let rec expr_to_tree e =
    match e with
    | Add(e1, e2) -> Node(expr_to_tree e1, "+", expr_to_tree e2)
    | Mult(e1, e2) -> Node(expr_to_tree e1, "*", expr_to_tree e2)
    | _ -> failwith "not implemented"


let rec tree_eval t =
    match t with
    | Leaf -> CHUJ WIE
    | Node(l, v, r) -> match v with
        | "+" -> Add(tree_eval l, tree_eval r)
        | "*" -> Add(tree_eval l, tree_eval r)
        | _ -> failwith "not implemented"
    | _ -> failwith "type error"