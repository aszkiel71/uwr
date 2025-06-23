(*task1*)

(*typ: ('a -> 'b) -> 'a list -> 'b list *)
fun f lst -> match lst with | [] -> [] | x :: xs -> [f x]

(*typ: ('a -> 'a -> int) -> 'a list -> 'a list *)
fun f lst -> match lst with | [] -> [] | [x] -> [x] | x :: y :: ys -> if (f x y) > 0 then ys else [x]

(*typ: ('a -> bool) -> ('a -> 'b) -> ('a -> 'b ) -> 'a -> 'b *)
fun f g h x -> if (f x) then (g x) else (h x)

(*task2*)
let rec f x y =
    let g = fun z -> x + z in (*z -> zwiazane przez fun z, x -> zwiazane przez let rec f x y*)
    if y > 0 then g (f x (y - 1)) (*y(w dwoch miejscach) -> zwiazane przez let rec f x y,
     g -> zwiazane przez let g = fun z ..., x -> zwiazane przez let rec f x y, f -> zwiazane przez let rec f x y*)
    else h x (*h -> wolne, x -> zwiazane przez let rec f x y*)

fun x ->
    let rec loop y =
        if y = 0 then x (*y -> zwiazane przez let rec loop y, x -> zwiazane przez fun x*)
        else loop (y - 1) (*loop -> zwiazane przez let rec loop, y -> zwiaznae przez let rec loop y*)
    in loop z (*loop -,. zwiazane przez let rec loop, z -> wolne*)

(*task 3*)
fun f g x -> f (g x) = g (f x) (*typ: ('a -> 'a) -> ('a -> 'a) -> 'a -> bool *)
fun x -> if x then x else not x (*typ: bool -> bool*)
let rec f x = f in f (*blad typu*)
fun (x, y) -> (y, x, x = y) (*typ: ('a * 'a) -> ('a * 'a * bool) *)
fun f -> let x = f 0 in let y = f true in x + y (*blad typu, np f 0, f true *)

(*task 4*)
type 'a slist =
    | SNil of 'a
    | SCons of 'a * 'a slist

(*
a)
Powiemy, ze predykat p jest spelniony gdy zachodzi:
| p(SNil a) : dla dowolnego a
| p(a) ^ p(lst) => p(SCons(a, lst)) : dla dow. (a : 'a) ^ (lst : 'a slist)
Wtedy spelnione jest dla dow. czegos typu 'a slist

b)
Wezmy dow. a : 'a
Wtedy:
 L = smap f (sfold g a) = (*def*) smap f (a) = (*def*) = SNil (f a)
 P = sfold g (smap f a) = (*def*) sfold g (SNil (f a)) = (*def*) SNil (f a)
 L = P

Wezmy dow. a oraz lst i zal. ze p(a) ^ p(lst).
Czyli, ze smap f (sfold g a) = sfold g (smap f a), oraz
smap f (sfold g lst) = sfold g (smap f lst)
Pokazemy dla p(SCons(a, lst)) [dla dowolnych f, g]

 L = smap f ( sfold g SCons(a, lst) ) = (*def*)
   = smap f (  g a ( sfold g lst )  ) =
   = f (g a) (smap f (sfold g lst ) )

 P = sfold g (smap f Cons(a, lst) ) = sfold g ( SCons (f a, smap f lst) ) =
   = sfold SCons (g (f a), sfold g (smap f lst) ) = g (f a) (sfold g (smap f lst))  (* z zal *)
   = g (f a) (smap f (sfold g lst ))

 L = P
*)

(*task 5*)

type 'a counted = int * 'a
let return x = (0, x)
let bind m f = let (count_m, value_m) = m in let (count_f_result, value_f_result) = f value_m in
    (count_m + count_f_result, value_f_result)

let count_calls () = (1, ())


(*task 6*)
let partition p xs = List.fold_right (fun x (lst1, lst2) -> if (p x) then (x :: lst1, lst2) else (lst1, x :: lst2)) xs ([], [])


(*task 7
B ::= true | false | B and B | B or B | not B | (B)
a) Nie, np B -> true
           B -> not B -> not false -> true

b) nwm
*)


type expr =
    | Int of int
    | Bool of bool
    | Var of string
    | If of expr * expr * expr
    | Let of string * expr * expr
    | Fun of string * expr
    | App of expr * expr
    | Pair of expr * expr
    | Match of expr * string * string * expr

let rec all_vars_bound (bound_vars : string list) (e : expr) : bool =
  match e with
      | Int _ -> true
      | Bool _ -> true
      | Var x -> List.mem x bound_vars
      | If (e1, e2, e3) ->
          all_vars_bound bound_vars e1 &&
          all_vars_bound bound_vars e2 &&
          all_vars_bound bound_vars e3
      | Let (x, e1, e2) ->
          all_vars_bound bound_vars e1 &&
          all_vars_bound (x :: bound_vars) e2
      | Fun (x, body) ->
          all_vars_bound (x :: bound_vars) body
      | App (e1, e2) ->
          all_vars_bound bound_vars e1 &&
          all_vars_bound bound_vars e2
      | Pair (e1, e2) ->
          all_vars_bound bound_vars e1 &&
          all_vars_bound bound_vars e2
      | Match (e, x1, x2, body) ->
          all_vars_bound bound_vars e &&
          all_vars_bound (x1 :: x2 :: bound_vars) body

type instr =
    | IConst of int
    | IPair
    | IFst
    | ISnd
    | ISwap
    | IDup

type value = VInt of int | VPair of value * value
type stack = value list

let rec eval instrs stck =
    match instrs with
    | [] -> stck
    | IConst i :: rest -> eval rest (VInt i :: stck)
    | IPair :: rest ->
        match stck with
        | VInt e1 :: VInt e2 :: xs -> eval rest (VPair(VInt e1, VInt e2) :: xs)
        | VPair (e0, e1) :: VInt e2 :: xs -> eval rest (VPair(VPair e1, VInt e2) :: xs)
        | VInt e1 :: VPair (e2, e3) :: xs -> eval rest (VPair (VInt e1, VPair (e2, e3)) :: xs)
        | VPair (e0, e1) :: VPair (e2, e3) :: xs -> eval rest (VPair(VPair (e0, e1), VPair (e2, e3)) :: xs)
        | _ -> failwith "some error"
    | IFst :: rest ->
        match stck with
        | VPair(VInt e, _) :: xs -> eval rest (VInt e :: xs)
        | VPair(VPair (e1, e2), _) :: xs -> eval rest (VPair (e1, e2) :: xs)
        | _ -> failwith "expected VPair"
    | ISnd :: rest ->
        match stck with
        | VPair(_, VInt e) :: xs -> eval rest (VInt e :: xs)
        | VPair(_, VPair (e1, e2)) :: xs -> eval rest (VPair (e1, e2) :: xs)
        | _ -> failwith "expected VPair"
    | ISwap :: rest ->
        match stck with
        | VInt x :: VInt y :: xs -> eval rest (VInt y :: VInt x :: xs)
        | VPair (x0, x1) :: VInt y :: xs -> eval rest (VInt y :: VPair (x0, x1) :: xs)
        | VPair (x0, x1) :: VPair (y0, y1) :: xs -> eval rest (VPair (y0, y1) :: VPair (x0, x1) :: xs)
        | VInt x :: VPair (y0, y1) :: xs -> eval rest (VPair (y0, y1) :: VInt x :: xs)
        | _ -> failwith "expected at leasts 2 args"
    | IDup :: rest ->
        match stck with
        | VInt x :: xs -> eval rest (VInt x :: VInt x :: xs)
        | VPair (x0, x1) :: xs -> eval rest (VPair (x0, x1) :: VPair (x0, x1) :: xs)
        | _ -> failwith "expected VInt or VPair"

let compile_nested_pair a b c = [IConst a; IConst b; IConst c; IPair; IPair]