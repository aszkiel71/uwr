let rec fold_left f acc lst =
    match lst with
    | [] -> acc
    | x :: xs -> fold_left f (f acc x) xs

let rec fold_right f lst acc =
    match lst with
    | [] -> acc
    | x :: xs -> f x (fold_right f xs acc)



let min_list lst = List.fold_left (fun acc x -> match acc with | None -> Some x | Some y -> Some (min x y)) None lst
let last_elem lst = List.fold_left (fun acc x -> match acc with | None -> Some x | Some y -> Some x) None lst
let take_while_positive lst = List.fold_right (fun x acc -> if x < 0 then [] else (x :: acc)) lst []
let partition_even_odd lst = List.fold_right (fun x (lst1, lst2) -> if x mod 2 = 0 then (x :: lst1, lst2) else (lst1, x :: lst2)) lst ([], [])
let flatten_lists lst = List.fold_right (fun x acc -> x @ acc) lst []
let any_true lst = List.fold_left (fun acc x -> if x then true else acc) false lst
let string_length_sum lst = List.fold_left (fun acc x -> acc + (String.length x)) 0 lst
let remove_duplicates lst = List.rev (List.fold_left (fun acc x -> if (List.mem x acc) = true then acc else (x :: acc)) [] lst)
let zip_with_indices lst = snd (List.fold_right (fun x (idx, xs) -> (idx - 1, (idx, x) :: xs)) lst (List.length lst - 1, []));;
let group_by_sign lst = List.fold_right (fun x (neg, zr, pos) -> if x = 0 then (neg, x :: zr, pos) else if x < 0 then
                                        (x :: neg, zr, pos) else (neg, zr, x :: pos)) lst ([], [], [])

type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree

let rec fold_tree f acc t =
    match t with
    | Leaf -> acc
    | Node(l, v, r) -> f (fold_tree f acc l) v (fold_tree f acc r)

let count_leaves t = fold_tree (fun l _ r -> l + r) 1 t
let depth_tree t = fold_tree (fun l _ r -> 1 + max l r) 0 t
let tree_to_list_preorder t = fold_tree (fun l v r -> l @ [v] @ r) [] t
let find_in_tree x t = fold_tree (fun l v r -> l || r || x = v) false t
let tree_max t = fold_tree (fun l v r ->
                            match  l, r with
                            | Some ml, Some mr -> Some (max ml (max v mr))
                            | Some ml, None -> Some (max ml v)
                            | None, Some mr -> Some (max v mr)
                            | None, None -> Some v)
                            None t

let rec reverse lst = match lst with
    | [] -> []
    | x :: xs -> reverse xs @ [x]

let rec height_tree t = match t with
    | Leaf -> 0
    | Node(l, _ , r) -> 1 + max (height_tree l) (height_tree r)

let rec map_tree f t = match t with
    | Leaf -> Leaf
    | Node(l, v, r) -> Node(map_tree f l, f v, map_tree f r)

(*dowody indukcyjne:
A)
reverse(x :: xs) = reverse xs @ [x]
1. xs = []
reverse(x :: []) = (*def*) = reverse ([]) @ [x

2. wezmy dow. x::xs i zal. ze reverse(x::xs) = reverse(xs @ [x])
pokazemy dla y :: x :: xs.
L = reverse(y :: x :: xs) = (*def*) reverse(x :: xs) @ [y] = (*z zal.*)  reverse(xs) @ [x] @ [y] = P
Q.E.D.

B)
p := height (map_tree f t) = height t
1. t = Leaf
L = height (map tree f Leaf) = height (Leaf) = 0
P = height (Leaf) = 0
L = P

wezmy dow t = Node(l, v, r). Zal. ze p(l) ^ p(r)
L = height (map_tree f Node(l, v, r)) = height (Node(map_tree f l, f v, map_tree f r) =
1 + max (map_tree f l) (map_tree f r) = (*z zal*) 1 + max (height l) (height r)
P = height Node(l, v, r) = 1 + max (height l) + height(r)

C)
Coq proof trivial

Formulowanie zasad indukcji:

type 'a option_tree =
    | Empty
    | Node of 'a option_tree * 'a option * 'a option_tree

Powiemy, ze predykat p spelnia cos typu 'a option_tree gdy:
| zachodzi p(Empty)
| dla dow. t1, t2 typu 'a option_tree:
    p(t1) ^ p(t2) => p(Node(t1, v, t2) : dla dowolnego v

type instruction =
    | Push of int
    | Pop
    | Add
    | Dup

type program = instruction list

Powiemy, ze predykat p spelnia program, gdy dla dowolnej listy lst typu instruction list spelnia p(lst).
Powiemy, ze spelniona jest p(lst) jesli zachodzi:
| p(Push n) : dla dowolnego n
| p(Pop) | p(Add) | p(Dup)
*)

fun f x y -> f y x (*typ: ('a -> 'b -> 'c) -> 'b -> 'a -> 'c *)
fun lst -> List.length lst + 1 (*typ: 'a list -> int *)
fun x -> fun y -> fun z -> (x, y, z) (*typ: 'a -> 'b -> 'c -> ('a * 'b * 'c) *)
fun (f, g) x -> (f x, g x) (*typ: ('a -> 'b) * ('a -> 'c) -> 'a -> 'b * 'c  *)
fun pred lst -> List.exists pred lst (*typ: ('a -> bool) -> 'a list -> bool *)
fun x -> x :: x :: [] (*typ: 'a -> 'a list*)
fun f lst -> List.fold_right f lst [] (*typ: ('a -> 'b list -> 'b list) -> 'a list -> 'a list -> 'b list*)
fun opt -> match opt with | Some x -> x | None -> 0 (*typ: int option -> int *)
fun f g h x -> f (g x) (h x) (*typ: ('a -> 'b -> 'c) -> ('d -> 'a) -> ('d -> 'b) -> 'd -> 'c *)
fun lst1 lst2 -> List.map2 (+) lst1 lst2 (*typ: int list -> int list -> int list*)

(*typ: 'a -> 'b -> 'b *)
fun x y -> y

(*typ: ('a -> 'b) -> ('c -> 'a) -> 'c -> 'b *)
fun f g x -> f (g x)

(*typ: 'a list -> int *)
fun lst -> match lst with | [] -> 1 | _ -> 2

(*typ: 'a -> 'a option *)
fun x -> Some x

(*typ: ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a *)
fun f x lst -> match lst with | [] -> x | y :: ys -> (f x y)

(*typ: 'a * 'b -> 'a *)
fun (a, b) -> a

(*typ: ('a -> bool) -> ('a -> bool) -> 'a -> 'bool *)
fun f g x -> if (f x) = true then if (g x) = true then true else false else false

(*typ: 'a list -> 'a list -> bool *)
fun lst1 lst2 -> match lst1, lst2 with | [], [] -> true | x :: xs, y :: ys -> if x < y then true else false | _ -> false

(*typ: int -> 'a -> 'a list *)
fun x y -> if x > 0 then [y] else [];;

(*typ ('a option -> 'b) -> 'a list -> 'b list *)
fun f lst -> match lst with | [] -> [] | [x] -> [f (Some x)] | _ -> []

let rec rotate_left t =
    match t with
    | Leaf -> Leaf
    | Node(l, v, Leaf) -> Node(l, v, Leaf)
    | Node(l, v, Node(b, y, c)) ->
    Node(Node(l, v, b), y, c)

let rec tree_zip t1 t2 =
    match t1, t2 with
    | Leaf, Leaf -> Leaf
    | Node (l1, v1, r1), Leaf ->
          Node (tree_zip l1 Leaf, (Some v1, None), tree_zip r1 Leaf)
    | Leaf, Node (l2, v2, r2) ->
          Node (tree_zip Leaf l2, (None, Some v2), tree_zip Leaf r2)
    | Node (l1, v1, r1), Node (l2, v2, r2) ->
          Node (tree_zip l1 l2, (Some v1, Some v2), tree_zip r1 r2)

(*gramatyka L = {a^i b^j c^k | i = j lub j = k,   i, j, k >= 0 *) (*zakladamy, ze to klauzula, a nie XOR*)
(* S -> symbol startowy
 S -> S1 | S2

 S1 -> A1C
 A1 -> aA1b | e
 C -> cC | e

 S2 -> A2B2
 A2 -> aA2 | e
 B2 -> bB2c | e
 *)


 type expr =
    | Int of int
    | Bool of bool
    | Add of expr * expr
    | If of expr * expr * expr

type instr =
    | Push of int
    | PushBool of bool
    | AddOp
    | JumpIfFalse of int
    | Jump of int

let rec compile e =
    match e with
    | Int e -> [Push e]
    | Bool b -> [PushBool b]
    | Add(e1, e2) -> (compile e1) @ (compile e2) @ [AddOp]
    | If(cond, e1, e2) -> match (compile cond) with
                        | [PushBool true] -> (compile e1)
                        | [PushBool false] -> match compile e2 with
                                    | [Push e] -> [JumpIfFalse e]
                        | _ -> failwith "type error"