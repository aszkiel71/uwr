let first_n n lst = if n > List.length lst then lst
                    else fst (List.fold_right
                    (fun x (xs, k) -> if k = 0 then (x :: xs, k) else (xs, k-1))
                    lst ([] , List.length lst - n) )

let drop_last lst = fst
    (List.fold_right (fun x (xs , k) -> if k = (List.length lst) then (xs, k-1) else (x :: xs, k - 1)) lst ([], List.length lst))

let index_of k lst =
  fst
    (List.fold_left
       (fun (res, idx) x ->
         if x = k then
           match res with
           | Some _ -> (res, idx + 1)
           | None -> (Some idx, idx + 1)
         else (res, idx + 1))
       (None, 0) lst)

let split_at n lst = fst (List.fold_right ( fun x ( (lst1, lst2) , k ) -> if k = 0 then ( (x :: lst1, lst2), k)
                           else ( (lst1, x :: lst2), k - 1 ) ) lst (([],[]), List.length lst - n) )

let count_occurrences elem lst = List.fold_left (fun acc x -> if x = elem then (acc+1) else acc) 0 lst
let alternate_sum lst = snd (List.fold_left
                        (fun (state, sum) x ->  if state = true then (false, sum + x) else (true, sum - x)) (true, 0) lst )


type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree

let rec fold_tree f a t =
    match t with
    | Leaf -> a
    | Node(l,v,r) -> f (fold_tree f a l) v (fold_tree f a r)

let tree_size t = fold_tree (fun l _ r -> l + r + 1) 1 t
let tree_product t = fold_tree (fun l v r -> l * v * r) 1 t
let tree_any p t = fold_tree (fun l v r -> (p v) || l || r ) false t

type 'a nested_list =
    | Item of 'a
    | List of 'a nested_list list
(*
Powiemy, ze predykat p spełnia t typu 'a nested_list gdy, spelnione jest:
| p(Item a) : dla dowolnego a
| dla Listy lst typu 'a nested_list, gdy zachodzi:
    1. p([])
    2. p(lst) => p(x :: lst) dla dow. x
*)

type binary_op = Add | Sub | Mul | Div
type formula =
    | Const of int
    | BinOp of binary_op * formula * formula

(*
Powiemy, ze predykat p spelnia binary_op gdy zachodzi:
| p(Add) | p(Sub) | p(Mul) | p(Div)

Powiemy, ze predykat p spelnia formule  gdy zachodzi:
| p(Const c) : dla dow. c
| dla f = (binop, f1, f2):
  p(binop) ^ p(f1) ^ p(f2) => p((binop, f1, f2))
*)

fun f lst -> List.filter (fun x -> not (f x)) lst
(*typ: ('a -> bool) -> 'a list -> 'a list *)

fun x -> match x with | [] -> 0 | [a] -> a | a :: b :: _ -> a + b
(*typ: int list -> int *)

fun x -> fun y -> fun z -> (x, y, z)
(*typ: 'a -> 'b -> 'c -> 'a * 'b * ' c *)

fun (f, g) x -> (f x, g x)
(*typ: (('a -> 'b) * ('a -> 'c)) -> 'a -> 'b * 'c *)

fun opt def -> match opt with | Some x -> x | None -> def
(*typ: 'a option -> 'a -> 'a *)

fun lst -> List.fold_left max (List.hd lst) lst
(*typ: 'a list -> 'a *)

fun f lst1 lst2 -> List.map2 f lst1 lst2
(*typ: ('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list *)

fun pred -> fun lst -> List.partition pred lst
(*typ: ('a -> bool) -> 'a list -> ('a list * 'a list) *)

fun f -> List.fold_right (fun x acc -> f x :: acc)
(*typ: ('a -> 'b) -> 'a list -> 'b list *)

fun x y z -> if x > y then z x else z y
(*typ: 'a -> 'a -> ('a -> 'b) -> 'b*)

fun lst -> List.fold_left (fun acc x -> x :: acc) []
(*typ: 'a list -> 'a list *)

fun opt -> match opt with | Some x -> x | None -> 0
(*typ: int option -> int *)

fun f g h x -> f (g x) (h x)
(*typ: ('a -> 'b -> 'c) -> ('d -> 'a) -> ('d -> 'b) -> 'd -> 'c *)

fun lst1 lst2 -> List.map2 (+) lst1 lst2
(*typ: int list -> int list -> int list *)

(*typ: ('a -> 'a) -> 'a -> 'a *)
fun f x -> max (f x) x

(*typ: int -> int list -> int list *)
fun x lst -> (x+1) :: lst

(*typ: ('a -> 'b) -> 'a option -> 'b option *)
fun f x -> match x with | Some x -> Some (f x) | None -> None

(*typ: 'a list -> 'a list -> 'a list *)
fun lst1 lst2 -> lst1 @ lst2

(*typ: ('a -> 'a -> int) -> 'a list -> 'a list *)
fun f lst -> match lst with | [] -> [] | [x] -> [x] | x :: y :: xs -> if (f x y) < 0 then xs else (y :: xs)

(*typ: bool -> 'a -> 'a -> 'a *)
fun state x y -> if state then x else y

(*typ: ('a -> bool) -> ('a -> bool) -> ('a -> bool) *)
(*niemozliwe*)

(*typ: 'a -> ('a -> 'b) -> 'b *)
fun x f -> f x

(*typ: ('a -> 'b -> 'c) -> ('a * 'b) -> 'c *)
fun f pr -> f (fst pr) (snd pr)

(*typ: int list -> (int -> bool) -> int option *)
fun lst f -> match lst with | [] -> None | x :: xs -> if (f (x+1)) then Some x else None

let tree_filter p t =
    match t with
    | Leaf -> Leaf
    | Node(l, v, r) -> if (p v) then Node(tree_filter p l, v, tree_filter p r) else Leaf

let tree_depth_at key t =
    let rec find t lvl =
        match t with
        | Leaf -> None
        | Node(l, v, r) -> if key = v then Some lvl
        else match (find t (lvl + 1)), (find t (lvl+1)) with
        | None, Some ans -> Some ans
        | Some ans1, Some ans2 -> Some (min ans1 ans2)
        | Some ans, None -> Some ans
        | None, None -> None
    in find t 0

let tree_fold_postorder t = fold_tree (fun l v r -> l @ r @ [v]) [] t

(*gramatyka dla l = {w w^r | w nalezy {a, b}
S = eps | A1 | A2
A1 = aA1a | bB1b | eps
B1 = bB1b | eps

A2 = bB2b | aA2a | eps
B2 = aA2a | eps

gramatyka dla SQL SELECT:
var = {*, x, y, a, b, c, ...}
tb = {nazwa tablicy}
cond = {warunek}

S = "SELECT" S1 | eps
S1 = var | var, S1 | S2
S2 = FROM T
T = tb | tb WH
WH = WHERE cond ND
ND = eps | AND cond
*)
