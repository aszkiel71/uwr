(*task1*)
let x = 5 in
let f y = x + y + z in (*x -> zwiazane przez let x = 5, z -> wolne, y -> zwiazane przez f y*)
f x (*x -> zwiazane przez let x = 5, f -> zwiazane przez f x*)

fun f ->
let x = f y in (*y -> wolne, f -> zwiazane przez fun f*)
fun y -> f x y (*y -> zwiazane przez fun y, f, x -> zwiazane (fun f, let x) *)

(*task2*)
fun x -> x :: [x; x] (*typ: 'a -> 'a list *)
fun f x -> if f x then x else x + 1 (*typ: (int -> bool) -> int -> int*)
fun x y -> x y y (*typ: ('a -> 'a -> 'b) -> 'a -> 'b *)
fun f -> f f (*typ: blad typu*)

(*task3*)
fun x y -> x
fun lst1 lst2 -> lst1 @ lst2
fun f x y -> f y x

(*task4*)
let last lst = List.fold_left (fun acc x -> match acc with | None -> Some x | Some acc -> Some x) None lst
let take_while p lst = List.fold_right (fun x acc -> if p x then (x :: acc) else []) lst []

(*task5*)
let rotate_left = function
    | Node(l, v, Node(rl, rv, rr, _), _) -> Node(Node(l, v, rl), rv, rr)
    | t -> t

let rotate_right = function
    | Node(Node (ll, lv, lr, _), v, r, _) -> Node(ll, lv, Node(lr, v, r))
    | t -> t

(*task6*)
(*

E ::= n | E + T | T
T ::= n | T * n | n

(*nie mam jak zrobic drzewa, wiec napisze po po porsut wyprowadzenie*)

E -> E + T -> E + T * n -> n + T * n -> n + n * n -> 2 + n * n -> 2 + 3 * n -> 2 + 3 * 4
*)


(*task7*)
type 'a option = None | Some of 'a
let return x = Some x
let bind m f = match m  with | Some x -> f x | None -> None

(*task8*)
type expr =
    | Const of int
    | Add of expr * expr
    | Mul of expr * expr
    | Var of string
    | Let of string * expr * expr

type env = (string * int) list

let rec lookup_env k env =
    match env with
    | (key, v) :: rest -> if key = k then v else lookup_env k rest
    | _ -> failwith "not found"

let rec eval env e =
    match e with
    | Const n -> n
    | Add(e1, e2) -> (eval env e1) + (eval env e2)
    | Mul(e1, e2) -> (eval env e1) * (eval env e2)
    | Var x -> lookup_env x env
    | Let(x, e1, e2) ->
        let v1 = eval env e1 in
        let new_env = (x, v1) :: env in
        eval new_env e2

(*task9*)
type typ = TInt | TBool | TFun of typ * typ
type expr =
    | EInt of int
    | EBool of bool
    | EVar of string
    | EIf of expr * expr * expr
    | EFun of string * typ * expr
    | EApp of expr * expr
    | EAdd of expr * expr

type tenv = (string * typ) list

let rec type_check tenv e =
    match e with
    | EInt _ -> TInt
    | EBool _ -> TBool
    | EVar x -> List.assoc x tenv
    | EIf (e1, e2, e3) ->
        if type_check tenv e1 = TBool then
        let t2 = type_check tenv e2 in
        let t3 = type_check tenv e3 in
        if t2 = t3 then t2 else failwith "branches got different types"
     else failwith "if condition must be bool"
    | EFun (x, t, body) -> match t with
            | (type_check tenv x), (type_check tenv body) -> t
            | _ -> failwlith "should got given type"
    | EApp (e1, e2) -> if (type_check tenv e1) = (type_check tenv e2) then (type_check tenv e1) else
        failwith "should got same type"
    | EAdd (e1, e2) ->
        if type_check tenv e1 = TInt && type_check tenv e2 = TInt then TInt
        else failwith "add requires tow ints"