(*task1

let x = 3 in x
in x -> zwiazany przez let x = 3

let x = 3 in let y = x + y in x + y
x + y -> x zwiazany przez let x = 3, y zwiazany przez let y
w drugim tak samo

fun f x -> f (x  + y) -> y wolna, f x zwiazane przez fun f x
let x = z in x - y
z -> wolne, y -> wolne, x -> zwiazane przez let x

let x = z in   -> z wolny
fun z -> z f x -> z f x : z -> zwiazany przez fun z, f wolny, x zwiazany przez let x

fun z -> x - z
x -> wolny, z zwiazane przez fun z

*)

type 'a bst =
    | Leaf
    | Node of 'a bst * 'a * 'a bst

let rec insert_bst k t =
    match t with
    | Leaf -> Node(Leaf, k, Leaf)
    | Node(l, v, r) -> if k > v then Node(l, v, insert_bst k r)
                       else Node(insert_bst k l, v, r)

let list_to_bst lst = List.fold_left (fun acc x -> insert_bst x acc) Leaf lst

let rec bst_to_list t =
    match t with
    | Leaf -> []
    | Node(l, v, r) -> bst_to_list l @ [v] @ bst_to_list r

(*task 4*)

type 'a form =
    | VarF of 'a
    | BotF
    | ImpF of 'a form * 'a form

(*indukcja:
Powiemy, ze predykat p spelnia kazde formule 'a form jezeli:
| dla dowolnego VarF zachodzi P(VarF)
| zachodzi P(BotF)
| dla dowolnych 'a form mamy, ze
jezeli zachodzi Impf( P('a form), P('a form) ) to zachodzi P(ImpF ('a form), ('a form))
*)

(*task7*)

