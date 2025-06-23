(*task1*)

let rec f x =
    let rec g y =
        if x > y then f (g x) (*po kolei: x, zwiazane przez let rec f x,
        y -> zwiazane przez let rec g y, f -> zwiazane przez let rec f x, g -> zwiazane przez let rec g y,
        x -> zwiazane przez let rec f x*)
    else h (x + y) (*h -> wolne, x -> zwiazane przez let rec f x, y -> zwiazane przez let rec g y*)
in g (f z) (*g -> zwiazana przez let rec g y, f -> zwiazana przez let rec f, z -> wolne*)

fun x y ->
    let x = y in (*y -> zwiazane przez fun x y*)
    let y = x in (*x -> zwiazane przez let x (NIE PRZEZ FUN X Y)*)
    fun z -> x + y + z (*x, y -> zwiazane przez te dwa let'y, z -> zwiazane przez fun z*)

(*task2*)

fun f g x -> f (g x) (g x)  (*typ: ('a -> 'a -> 'b) -> ('c -> 'a) -> 'c -> 'b *)
fun f -> (f true, f 0) (*typ: type error, np expected bool, got int (got true, got 0)*)
let rec f x y = f y x in f (*typ: 'a -> 'a -> 'b *)
fun (f, g) -> fun x -> (f (g x), g (f x)) (*typ: ('a -> 'a) * ('a -> 'a) -> 'a -> ('a * 'a)  *)
fun x -> let rec f y = if y = 0 then x else f (f (y-1)) in f (*typ: int -> (int -> int) *)

(*task3*)
(*nie istnieje!!!!!!*)
fun f p -> match p with (a, b) -> f a b
fun f x k -> if k > 0 then (f x) else (f (f x))
fun (f, g) k -> g (f k)

(*task4*)
let split_at n lst = fst (List.fold_right (fun x ((lst1, lst2), k) ->
                                        if k = 0 then ((x :: lst1, lst2), k)
                                        else ((lst1, x :: lst2), k - 1)
                                        )
                                        lst
                                        (([],[]), List.length lst - n)
                                        )

let group_by p lst = List.rev (match lst with | x :: y :: xs -> fst (List.fold_left (fun (lst1, last) v ->
                                          if (p v last) then ([last; v] :: lst1 , v)
                                          else (lst1, v)
                                          )
                                          ([], x)
                                          (y :: xs)
                                          )
                                     | _ -> failwith "list should has got at least 2 args.")

let scan_left f init xs = fst (List.fold_right (fun x (acc1, acc2) -> ((f x acc2) :: acc1, f x acc2))
                                               xs
                                               ([init], init)
                                               )

(*task5*)
type 'a writer = 'a * string
let return x = (x, "")
let bind m f = (f m, "")

type ('s, 'a) state = 's -> ('a * 's)
let return x = fun s -> (x, s)
let bind m f = fun s -> (let v, s') = m s in (f f) s'

type 'a list_m = 'a list
let return x = [x]
let bind m f = List.concat (List.map f m)

(*task6*)
type 'a leaf_tree = Leaf of 'a | Branch of 'a leaf_tree * 'a leaf_tree

(*zasada indukcji:

Dla kazdego predykatu p, jesli zachodzi:
  | p(Leaf a) : dla dowolnego a
  | p(t1) ^ p(t2) => p(Branch(t1, t2))  : (dla jakis t1, t2)
Wtedy zachodzi dla kazdego drzewa

1. Wezmy dow. (a : 'a)
Wtedy:
L = count_leaves (map_tree f (Leaf a)) = count_leaves (Leaf (f a)) = 1
P = count_leaves (Leaf a) = 1
L = P

2. Wezmy dow. t1, t2 i zal. ze p(t1) ^ p(t2). Pokazemy p(Branch(t1, t2))

L = count_leaves (map_tree f (Branch(t1, t2)) = count_leaves (Branch(map_tree f t1, map_tree f t2)) =
count_leaves (map_tree f t1) + count_leaves (map_tree f t2) = (*z zal*) (count_leaves t1) + (count_leaves t2)
P = count_leaves (Branch(t1, t2)) = (count_leaves t1) + (count_leaves t2)
L = P
*)

type expr =
    | Int of int
    | Bool of bool
    | Var of string
    | Add of expr * expr
    | Sub of expr * expr
    | Mul of expr * expr
    | If of expr * expr * expr
    | Fun of string * expr
    | App of expr * expr
    | Let of string * expr * expr
type value =
    | VInt of int
    | VBool of bool
    | VClosure of string * expr * env
and env = (string * value) list


let rec lookup_env k env =
    match env with
    | (ky, v) :: rest -> if ky = k then v else lookup_env k rest
    | [] -> failwith "not found"

let rec eval (e : expr) (env : env) : value =
    match e with
    | Int i -> VInt i
    | Var s -> lookup_env s env
    | Bool b -> VBool b
    | Add(e1, e2) -> (match (eval e1 env, eval e2 env) with
                    | VInt x, VInt y -> VInt (x + y)
                    | _ -> failwith "expected 2 ints")
    | Sub(e1, e2) -> (match (eval e1 env, eval e2 env) with
                    | VInt x, VInt y -> VInt (x - y)
                    | _ -> failwith "expected 2 ints")
    | Mul(e1, e2) -> (match (eval e1 env, eval e2 env) with
                    | VInt x, VInt y -> VInt (x * y)
                    | _ -> failwith "expected 2 ints")
    | If(cond, e1, e2) -> (match (eval cond env) with
                            | VBool true -> eval e1 env
                            | VBool false -> eval e2 env
                            | _ -> failwith "condition must be bool")
    | Fun(id, e) -> VClosure (id, e, env)
    | App(e1, e2) -> let v1 = eval e1 env in
                     let v2 = eval e2 env in
                     (match v1 with
                     | VClosure(x, body, venv) ->
                      let new_env = ((x, v2) :: venv) in eval body new_env
                     | _ -> failwith "app requires function")
    | Let(id, e1, e2) -> let new_val = (eval e1 env) in (eval e2 ((id, new_val)::env))


(*task8*)

type typ =
    | TVar of string
    | TInt
    | TBool
    | TFun of typ * typ
    | TPair of typ * typ

type scheme = Forall of string list * typ

type expr =
    | EInt of int
    | EBool of bool
    | EVar of string
    | EAdd of expr * expr
    | EIf of expr * expr * expr
    | EFun of string * expr
    | EApp of expr * expr
    | ELet of string * expr * expr
    | EPair of expr * expr
    | EFst of expr
    | ESnd of expr

type type_env = (string * scheme) list

let rec type_infer (env : type_env) (e : expr) : typ =
    match e with
    | EInt _ -> TInt
    | EBool _ -> TBool
    | EVar s -> ...


(*task9*)
type expr =
    | Const of int
    | Var of string
    | Add of expr * expr
    | Mul of expr * expr
    | Let of string * expr * expr

type instr =
    | IPush of int
    | ILoad of string
    | IStore of string
    | IAdd
    | IMul
    | IPop

type env = (string * int) list



let rec compile (e : expr) (env : env) : instr list =
    match e with
    | Const i -> [IPush i]
    | Var s -> [ILoad s]
    | Add(e1, e2) -> (compile e1 env) @ (compile e2 env) @ [IAdd]
    | Mul(e1, e2) -> (compile e1 env) @ (compile e2 env) @ [IMul]
    | Let(vr, e1, e2) -> (match compile e1 env with
                        | [IPush i] -> compile e2 ((vr, i) :: env) @ [IPop] @ [IStore vr]
                        | _ -> failwith "expected [IPush i]")
