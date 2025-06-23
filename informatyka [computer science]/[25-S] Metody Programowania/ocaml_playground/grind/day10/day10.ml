(*fold_list*)
let reverse_fold lst = List.fold_left (fun acc x -> x :: acc) [] lst
let map_fold f lst = List.fold_right (fun x acc -> f x :: acc) lst []
let filter_fold f lst = List.fold_right (fun x acc -> if f x then x :: acc else acc) lst []
let flatten_fold lst = List.fold_right (fun x acc -> x @ acc) lst []
let split_at_predicate p lst = fst (List.fold_left (fun ((lst1, lst2), on1) x -> if on1 = true then
                                                if p x then ((lst1, x :: lst2), false) else
                                                ((x :: lst1, lst2), true) else ((lst1, x :: lst2), false)) (([], []), true) lst)
                                                (*tylko kolejnosci, nie zachowuje ale trudno*)
let intersperse k lst = List.fold_right (fun x acc -> x :: k :: acc) lst []
let rec zip_with f lst1 lst2 =
    match (lst1, lst2) with
    | (x :: xs, y :: ys) -> (f x y) :: (zip_with f xs ys)
    | ([], []) -> []
    | (x :: xs, []) -> failwith "list should got same size"
    | ([], y :: ys) -> failwith "list should got same size"

(*fold_tree*)

type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree
let rec fold_tree f acc t =
    match t with
    | Leaf -> acc
    | Node(l, v, r) -> f (fold_tree f acc l) v (fold_tree f acc r)

let tree_sum t = fold_tree (fun l v r -> l + v + r) 0 t
let tree_map f t = fold_tree (fun l v r -> Node(l, f v, r)) Leaf t
let tree_filter p t = fold_tree (fun l v r -> if p v then Node(l, v, r) else Leaf) Leaf t


(*typowanie*)
fun f g h x -> f (g x) (h x) (*
g: 'a -> 'b
h: 'a -> 'c
f: 'b -> 'c -> 'd
('b -> 'c -> 'd) -> ('a -> 'b) -> ('a -> 'c) -> 'a -> 'd
*)
fun f x -> f (f x) (f x x) (*blad typu*)

let rec fix f = f (fix f)
typ: ('a -> 'a) -> 'a

fun f -> fun x -> fun y -> f y x
typ: ('a -> 'b -> 'c) -> 'b -> 'a -> 'c

fun p f g x -> if p x then f x else g x
p x: 'a -> bool
f: 'a -> 'b
g: 'a -> 'b
('a -> bool) -> ('a -> 'b) -> ('a -> 'b) -> 'a -> 'b

fun f g -> fun x -> fun y -> f (g x y) (g y x)
typ:
g: 'a -> 'a -> 'b
f: 'b -> 'b -> 'c
('b -> 'b -> 'c) -> ('a -> 'a -> 'b) -> 'a -> 'a -> 'c

let rec map f xs =
    match xs with
    | [] -> []
    | x :: xs' -> f x :: map f xs'

('a -> b) -> 'a list -> 'b list

fun f -> (fun x -> f (x x)) (fun x -> f (x x)) (*type error*)

fun cmp lst ->
    let rec sorted lst =
        match lst with
        | [] | [_] -> true
        | x :: y :: xs -> cmp x y && sorted (y :: xs)
    in sorted lst

('a -> 'a -> bool) -> 'a list -> bool

fun fold f acc xs ->
    let rec loop acc xs =
        match xs with
        | [] -> acc
        | x :: xs -> loop (f acc x) xs
    in loop acc xs

'a -> ('b -> 'c -> 'b) -> 'b -> 'c list -> 'b

(*zmienne wolne/zwiazane

let x = y + 1 in x * z
y -> wolne, x -> zwiazany przez let x = y + 1, z -> wolny

fun f ->
    let x =
    f y    (* f zwiazany przez fun f, y -> wolny *)
    in x + f x  (* x -> zwiazany przez let x *)

let f = fun x ->
fun y ->
x + y + z  (*x, y -> zwiazane przez fun x, fun y; z -> wolne*)
in f a b (*a, b -> wolne)

let rec fact n =
if n = 0 then 1 (*n -> zwiazany przez let rec fact n *)
else n * fact (n - 1) (*n -> zwiazany przez let rec fact n, fact zwiazane przez definicje let rec fact*)

let x = 5 in
fun x -> (*x -> zwiaznay, aler pzez fun x*)
let y = x + z in  (*z -> wolne, x -> zwiazane przez fun x*)
fun z -> x + y + z (*z -> zwiaznay przez fun z, x -> zwiazane przez fun x, y -> zwiazane przez let y = ... *)


(fun x -> x + y)  (*y -> wolny, x -> zwiaznae przez fun x*)
(let y = 3 in y + 1) (*y -> zwiaznay przez let y = 3*)

let f = fun g ->
fun x -> g (g x) in (*x ->  zwiaznae przez fun x, g -> zwiazane przez fun g*)
let h = fun y -> y + 1 in (*y -> zwiazane przez fun y*)
f h z (*f, h, -. zwiazane przez let f, let h, z -> wolne*)


let x = 1 and
y = x + 2 in x + y (*x -> zwiazane przez let x = 1, y -> zwiaznae przez and y*)


fun f ->
let rec g x =
f x + g (x - 1)  (*x -> zwiaznae przez let rec g x, f -> zwiazane przez fun f, g -> zwiazane przez let rec g x*)
in g 5 (*g -> zwiazane przez let rec g x*)

let outer = fun x ->
    let inner = fun x -> x + y (* x-> zwiazane przez fun x (ta nowa przyslania), y -> wolne *)
    in
    fun y -> inner x + y (*y -> zwiaznae przez fun y, x -> zwiazane przez pierwszego fun x *)
in outer a b (*a, b -> wolne*)

*)