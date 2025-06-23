(* Sprawdzanie czy wszystkie zmienne są związane *)

(* Typ wyrażeń *)
type expr =
  | Var of string
  | Int of int
  | Bool of bool
  | Fun of string * expr          (* lambda - wiąże zmienną *)
  | App of expr * expr
  | Let of string * expr * expr   (* let - wiąże zmienną *)
  | LetRec of string * expr * expr (* let rec - wiąże zmienną *)
  | If of expr * expr * expr
  | Add of expr * expr
  | Mul of expr * expr
  | Pair of expr * expr
  | Fst of expr
  | Snd of expr
  | Match of expr * (pattern * expr) list

(* Wzorce - też mogą wiązać zmienne *)
and pattern =
  | PVar of string     (* Wiąże zmienną *)
  | PInt of int
  | PBool of bool
  | PPair of pattern * pattern
  | PWildcard          (* _ nie wiąże zmiennej *)

(* Środowisko - lista związanych zmiennych *)
type env = string list

(* Pomocnicza funkcja - sprawdza czy zmienna jest w środowisku *)
let rec is_bound env x =
  match env with
  | [] -> false
  | y :: rest -> x = y || is_bound rest x

(* Wyciąga zmienne związane przez wzorzec *)
let rec pattern_vars pat =
  match pat with
  | PVar x -> [x]                    (* Wzorzec zmiennej wiąże tę zmienną *)
  | PInt _ | PBool _ | PWildcard -> [] (* Te wzorce nie wiążą zmiennych *)
  | PPair(p1, p2) ->
      pattern_vars p1 @ pattern_vars p2  (* Łączymy zmienne z obu wzorców *)

(* Główna funkcja sprawdzająca *)
let rec all_vars_bound (env : env) (e : expr) : bool =
  match e with
  (* Literały nie mają zmiennych *)
  | Int _ | Bool _ -> true

  (* Zmienna - sprawdzamy czy jest związana *)
  | Var x -> is_bound env x

  (* Funkcja - dodajemy parametr do środowiska *)
  | Fun(x, body) ->
      let new_env = x :: env in      (* x jest teraz związane *)
      all_vars_bound new_env body

  (* Aplikacja - sprawdzamy obie części *)
  | App(e1, e2) ->
      all_vars_bound env e1 && all_vars_bound env e2

  (* Let - najpierw sprawdzamy e1, potem e2 z nowym środowiskiem *)
  | Let(x, e1, e2) ->
      all_vars_bound env e1 &&       (* e1 w starym środowisku *)
      let new_env = x :: env in       (* x związane dla e2 *)
      all_vars_bound new_env e2

  (* Let rec - zmienna jest związana już w e1 (dla rekurencji) *)
  | LetRec(x, e1, e2) ->
      let new_env = x :: env in       (* x związane od razu *)
      all_vars_bound new_env e1 &&   (* e1 widzi x *)
      all_vars_bound new_env e2      (* e2 też widzi x *)

  (* If - sprawdzamy wszystkie 3 części *)
  | If(cond, e_then, e_else) ->
      all_vars_bound env cond &&
      all_vars_bound env e_then &&
      all_vars_bound env e_else

  (* Operacje binarne *)
  | Add(e1, e2) | Mul(e1, e2) ->
      all_vars_bound env e1 && all_vars_bound env e2

  (* Pary *)
  | Pair(e1, e2) ->
      all_vars_bound env e1 && all_vars_bound env e2

  | Fst e | Snd e ->
      all_vars_bound env e

  (* Pattern matching - najbardziej skomplikowane *)
  | Match(e, cases) ->
      all_vars_bound env e &&         (* Wyrażenie matchowane *)
      List.for_all (fun (pat, expr) ->
        let pat_vars = pattern_vars pat in  (* Zmienne związane przez wzorzec *)
        let new_env = pat_vars @ env in     (* Dodajemy je do środowiska *)
        all_vars_bound new_env expr         (* Sprawdzamy wyrażenie przypadku *)
      ) cases

(* Funkcja pomocnicza - znajduje wszystkie niezwiązane zmienne *)
let rec find_unbound_vars (env : env) (e : expr) : string list =
  match e with
  | Int _ | Bool _ -> []

  | Var x ->
      if is_bound env x then [] else [x]

  | Fun(x, body) ->
      find_unbound_vars (x :: env) body

  | App(e1, e2) ->
      find_unbound_vars env e1 @ find_unbound_vars env e2

  | Let(x, e1, e2) ->
      find_unbound_vars env e1 @
      find_unbound_vars (x :: env) e2

  | LetRec(x, e1, e2) ->
      let new_env = x :: env in
      find_unbound_vars new_env e1 @
      find_unbound_vars new_env e2

  | If(cond, e_then, e_else) ->
      find_unbound_vars env cond @
      find_unbound_vars env e_then @
      find_unbound_vars env e_else

  | Add(e1, e2) | Mul(e1, e2) ->
      find_unbound_vars env e1 @ find_unbound_vars env e2

  | Pair(e1, e2) ->
      find_unbound_vars env e1 @ find_unbound_vars env e2

  | Fst e | Snd e ->
      find_unbound_vars env e

  | Match(e, cases) ->
      find_unbound_vars env e @
      List.concat (List.map (fun (pat, expr) ->
        let new_env = pattern_vars pat @ env in
        find_unbound_vars new_env expr
      ) cases)

(* Przykłady użycia *)
let example1 = Fun("x", Add(Var "x", Var "y"))  (* y niezwiązane *)
let example2 = Let("y", Int 5, Fun("x", Add(Var "x", Var "y")))  (* wszystko ok *)
let example3 = Match(Var "z", [(PVar "x", Var "x"); (PInt 0, Var "w")])  (* z i w niezwiązane *)

(*
Testy:
- all_vars_bound [] example1 = false
- all_vars_bound [] example2 = true
- all_vars_bound ["z"] example3 = false (bo w dalej niezwiązane)
- find_unbound_vars [] example1 = ["y"]
- find_unbound_vars [] example3 = ["z"; "w"]
*)