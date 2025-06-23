(*task1*)
let f x y =
    let g z = x + z in (*x -> zwiazane przez let f x y, z -> zwiazane przez let g z*)
    g (y + w) (*g -> zwiazane przez przez let g z, y -> zwiazane przez let f x y, w -> wolne*)

fun x ->
    let rec f y =
        if y > 0 then x + f (y - 1) (*y -> zwiaznse przez let rec f y, f -> zwiazane przez let rec f y, x -> zwiazane przez fun x*)
        else g x (*g -> wolne, x -> zwiazane przez fun x*)
    in f x (*x -> zwiazane przez fun x, f -> zwiazane przez let rec f y *)

let x = y + 1 in (*y -> wolne*)
let y = x + 2 in (*x -> zwiazane przez let x = ...*)
fun z -> x + y + z (*x, y -> zwiazane przez te lety wyzej, z -> zwiazane przez fun z *)

(*task2*)
fun x -> let y = x + 1 in fun new_x -> new_x + y (*glupie troche polecneie wiec zrobie jak dla b) i tak tez to ocen*)

let rec f x =
    let g y = f (x + y) in
    g x (*bez zmian zadnych*)

fun x -> let y = x + z in fun a -> y + a

(*task3*)
fun f g x -> g (f x x)  (*typ: ('a -> 'a -> 'b) -> ('b -> 'c) -> 'a -> 'b *)
fun x -> (x, 1, x true, x []) (*typ: blad typu*)
let rec f x = f (f x) in f (*typ: 'a -> 'a *)
fun f -> let g x = f (x, x) in g (*typ: (('a * 'a) -> 'b) -> 'a -> 'b*)

(*task4*)

(*typ: ('a -> 'b -> 'c) -> 'b -> 'a -> 'c *)
fun f a b -> f b a

(*typ: ('a -> 'a -> bool) -> 'a list -> 'a list list *)
fun f lst -> match lst with | x :: y :: xs -> if (f x y) then [[x]; [y]] else [[y]; [x]; xs]
                            | _ -> []

(*typ: (('a -> 'b) -> 'c) -> (('a -> 'b) -> 'c),   nie istnieje taka funkcja, bo nie ma jak przemycic c, jezeli sie da, daj kontrprzyklad i sprawdz w utopie*)


(*task5*)
let sum_of_squares lst = List.fold_left (fun acc x -> x * x + acc) 0 lst
let filter p lst = List.fold_right (fun x acc -> if (p x) then (x :: acc) else acc) lst []
let partition p lst = List.fold_right (fun x (lst1, lst2) -> if (p x) then (x :: lst1 ,lst2) else (lst1, x :: lst2)) lst ([], [])
(*map2 nie ma sensu na foldach, ale mozna to zrobic tak:*)
let rec map2 f lst1 lst2 =
    match lst1, lst2 with
    | x :: xs, y :: ys -> (f x y) :: (map2 f xs ys)
    | [], [] -> []

let takewhile p lst = List.fold_right (fun x acc -> if p x then (x :: acc) else []) lst [] (*wiem, ze to dziwne ale to serio dziala XD, fold przechodzi od konca, wiec zeruje poprzez [] jak nie spelnia*)
let index_of e lst = snd (List.fold_left (fun (idx, res) x -> if res = None then if e = x then (idx, Some idx) else (idx + 1, None) else (idx, res)) (0, None) lst)
let unique lst = List.rev (List.fold_left (fun acc x -> if (List.mem x acc) then acc else (x :: acc)) [] lst)

(*task6*)
type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree
let rec fold_tree f a t =
    match t with
    | Leaf -> a
    | Node(l, v, r) -> f (fold_tree f a l) v (fold_tree f a r)

let tree_sum t = fold_tree (fun l v r -> l + v + r) 0 t
let tree_height t = fold_tree (fun l _ r -> 1 + max l r) 0 t
let tree_map f t = fold_tree (fun l v r -> Node(l, f v, r)) Leaf t
let tree_filter p t = fold_tree (fun l v r -> if (p v) then l @ [v] @ r else (l @ r)) [] t

(*task7*)
let rec mirror_tree t = match t with Leaf -> Leaf | Node (l ,v, r) -> Node(mirror_tree r, v, mirror_tree l)

(*task8 - nie oceniaj tego zadania, usun je z punktacji*)

(*task9
Niech L = liczby
S -> (S) | BINOP
BINOP -> (L - L) | L + L | (L * L) | L + (BINOP - L) | L * (BINOP - L) | L + (BINOP * L)
b) nie jest, ale nie chce mi sie podawac przyklady
*)

(*task10*)
type value =
    | VClosure of string * expr * env
    | VLazyEw of expr * expr
    | VBool of bool
    | VStruct of value

(*task12*)
type expr =
    | ENum of int
    | EVar of string
    | EAdd of expr * expr
    | ESub of expr * expr
    | EMul of expr * expr
    | EDiv of expr * expr
    | ELet of string * expr * expr
    | EIf of expr * expr * expr

type rpn_instr =
    | Push of int
    | Load of string
    | Store of string
    | Add | Sub | Mul | Div
    | Dup | Swap | Drop
    | JumpIfNotPositive of int | Jump of int

let rec compile (env : string list) (e : expr) : rpn_instr list =
    match e with
    | ENum i -> [Push i]
    | EVar s -> [Load s]
    | EAdd (e1, e2) -> (compile env e1) @ (compile env e2) @ [Add]
    | ESub (e1, e2) -> (compile env e1) @ (compile env e2) @ [Sub]
    | EMul (e1, e2) -> (compile env e1) @ (compile env e2) @ [Mul]
    | EDiv (e1, e2) -> (compile env e1) @ (compile env e2) @ [Div]
    | ELet (str, e1, e2) -> (compile env e1) @ [Store str] @ (compile env e2) @ [Swap] @ [Drop]
    | EIf  (cond, e1, e2) -> (match compile env cond with
                              | [Push i] -> if i > 0 then (match compile env e1 with | [Push j] -> [Jump j] | _ -> failwith "expected int")
                                            else (match compile env e2 with | [Push j] -> [JumpIfNotPositive j] | _ -> failwith "expected int")
                              | _ -> failwith "expected int"
                              )

(*task13*)
type typ =
    | TInt | TBool | TFun of typ * typ
    | TRef of typ

let rec type_check env e =
    match e with
    | Int _ -> TInt | Bool _ -> TBool | Var s -> (List.assoc s env)
    | Fun (s, tp , e1) -> (match tp with | Some t -> TFun(t, type_check env e1) | None -> failwith "type was not given")
    | App(e1, e2) -> (match type_check env e1 with | TFun(t1, t2) -> if (type_check env e2) = t1 then t2 else failwith "type does not match")
    | Let(s, e1, e2) -> let t = type_check env e1 in type_check ((s, t) :: env) e2
    | Ref e -> TRef (type_check env e)
    | Deref e -> let t = type_check env e in (match t with | TRef x -> x | None -> "type error")
    | Assign(e1, e2) -> let (t1, t2) = (type_check env e1, type_check env e2) in (match (t1, t2) with
                        | TRef t1, TRef t2 -> if t1 = t2 then t2 else failwith "type does not match"
                        | _ -> failwith "type does not match"
                        )
    | Seq(e1, e2) -> let _ type_check env e1 in type_check env e2
    | If(cond, e1, e2) -> (match type_check env cond with
                        | TBool -> (match type_check env e1, type_check env e2 with
                                        t1, t2 -> if t1 = t2 then t2 else failwith "different types in if/else branches"
                                        )
                        | _ -> failwith "condition must be bool")
    | Equal(e1, e2) -> let (t1, t2) = (type_check env e1, type_check env e2) in
                        if t1 = t2 then TBool else failwith "type does not match"


type expr =
  | Int of int
  | Bool of bool
  | Var of string
  | Fun of string * typ option * expr
  | App of expr * expr
  | Let of string * expr * expr
  | Ref of expr
  | Deref of expr
  | Assign of expr * expr
  | Seq of expr * expr
  | If of expr * expr * expr
  | Equal of expr * expr

and typ =
  | TInt
  | TBool
  | TFun of typ * typ
  | TRef of typ  (* Poprawnie uzupełnione *)

type tenv = (string * typ) list

exception Type_error of string

let rec type_check (env : tenv) (e : expr) : typ =
  match e with
  (* Literały *)
  | Int _ -> TInt
  | Bool _ -> TBool

  (* Zmienne *)
  | Var x ->
      (try List.assoc x env
       with Not_found -> raise (Type_error ("Unbound variable: " ^ x)))

  (* Funkcje - wymagają anotacji typu *)
  | Fun(x, Some t_arg, body) ->
      (* Dodajemy x:t_arg do środowiska i sprawdzamy ciało *)
      let t_body = type_check ((x, t_arg) :: env) body in
      TFun(t_arg, t_body)

  | Fun(_, None, _) ->
      raise (Type_error "Function requires type annotation")

  (* Aplikacja *)
  | App(e1, e2) ->
      let t1 = type_check env e1 in
      let t2 = type_check env e2 in
      (match t1 with
       | TFun(t_arg, t_result) ->
           if t_arg = t2 then t_result
           else raise (Type_error "Function argument type mismatch")
       | _ -> raise (Type_error "Application of non-function"))

  (* Let binding *)
  | Let(x, e1, e2) ->
      let t1 = type_check env e1 in
      type_check ((x, t1) :: env) e2

  (* Referencje *)
  | Ref e ->
      TRef (type_check env e)

  | Deref e ->
      (match type_check env e with
       | TRef t -> t
       | _ -> raise (Type_error "Dereference of non-reference"))

  | Assign(e1, e2) ->
      (match type_check env e1 with
       | TRef t ->
           let t2 = type_check env e2 in
           if t = t2 then
             TInt  (* Assign zwraca unit, ale używamy TInt jako unit *)
           else
             raise (Type_error "Assignment type mismatch")
       | _ -> raise (Type_error "Assignment to non-reference"))

  (* Sekwencje *)
  | Seq(e1, e2) ->
      let _ = type_check env e1 in  (* Ignorujemy wynik e1 *)
      type_check env e2

  (* If-then-else *)
  | If(cond, e_then, e_else) ->
      if type_check env cond <> TBool then
        raise (Type_error "If condition must be boolean");
      let t_then = type_check env e_then in
      let t_else = type_check env e_else in
      if t_then = t_else then t_then
      else raise (Type_error "If branches have different types")

  (* Porównanie *)
  | Equal(e1, e2) ->
      let t1 = type_check env e1 in
      let t2 = type_check env e2 in
      if t1 = t2 then TBool
      else raise (Type_error "Equality comparison of different types")

(* Przykład użycia:
   Let("r", Ref(Int 5),
     Let("x", Deref(Var "r"),
       Seq(Assign(Var "r", Int 10),
           Equal(Deref(Var "r"), Var "x"))))

   Zwróci typ: TBool
*)