(* Alpha-równoważność i przekształcanie wyrażeń *)

(* Typ wyrażeń *)
type expr =
  | Var of string
  | Int of int
  | Bool of bool
  | Fun of string * expr
  | App of expr * expr
  | Let of string * expr * expr
  | LetRec of string * expr * expr
  | If of expr * expr * expr
  | Add of expr * expr
  | Mul of expr * expr
  | Pair of expr * expr
  | Fst of expr
  | Snd of expr
  | Match of expr * (pattern * expr) list

and pattern =
  | PVar of string
  | PInt of int
  | PBool of bool
  | PPair of pattern * pattern
  | PWildcard

(* Generator świeżych nazw zmiennych *)
let fresh_counter = ref 0

let fresh_var base =
  incr fresh_counter;
  base ^ "_" ^ string_of_int !fresh_counter

(* Resetowanie licznika (przydatne do testów) *)
let reset_fresh () = fresh_counter := 0

(* Podstawianie - zamienia zmienną na wyrażenie *)
let rec subst (x : string) (s : expr) (e : expr) : expr =
  match e with
  | Var y -> if x = y then s else Var y
  | Int n -> Int n
  | Bool b -> Bool b

  | Fun(y, body) ->
      if x = y then
        Fun(y, body)  (* y przesłania x *)
      else if List.mem y (free_vars s) then
        (* Unikamy przechwycenia - alpha konwersja *)
        let z = fresh_var y in
        let body' = subst y (Var z) body in
        Fun(z, subst x s body')
      else
        Fun(y, subst x s body)

  | App(e1, e2) -> App(subst x s e1, subst x s e2)

  | Let(y, e1, e2) ->
      let e1' = subst x s e1 in
      if x = y then
        Let(y, e1', e2)
      else if List.mem y (free_vars s) then
        let z = fresh_var y in
        let e2' = subst y (Var z) e2 in
        Let(z, e1', subst x s e2')
      else
        Let(y, e1', subst x s e2)

  | LetRec(y, e1, e2) ->
      if x = y then
        LetRec(y, e1, e2)
      else if List.mem y (free_vars s) then
        let z = fresh_var y in
        let e1' = subst y (Var z) e1 in
        let e2' = subst y (Var z) e2 in
        LetRec(z, subst x s e1', subst x s e2')
      else
        LetRec(y, subst x s e1, subst x s e2)

  | If(cond, e_then, e_else) ->
      If(subst x s cond, subst x s e_then, subst x s e_else)

  | Add(e1, e2) -> Add(subst x s e1, subst x s e2)
  | Mul(e1, e2) -> Mul(subst x s e1, subst x s e2)
  | Pair(e1, e2) -> Pair(subst x s e1, subst x s e2)
  | Fst e -> Fst(subst x s e)
  | Snd e -> Snd(subst x s e)

  | Match(e, cases) ->
      let e' = subst x s e in
      let cases' = List.map (fun (pat, expr) ->
        let bound = pattern_vars pat in
        if List.mem x bound then
          (pat, expr)  (* x związane przez wzorzec *)
        else
          (* Sprawdź czy trzeba alpha-konwersja *)
          let conflicts = List.filter (fun y -> List.mem y (free_vars s)) bound in
          if conflicts = [] then
            (pat, subst x s expr)
          else
            (* Przemianuj konfliktujące zmienne *)
            let renaming = List.map (fun y -> (y, fresh_var y)) conflicts in
            let pat' = rename_pattern renaming pat in
            let expr' = List.fold_left (fun e (old, new_) ->
              subst old (Var new_) e
            ) expr renaming in
            (pat', subst x s expr')
      ) cases in
      Match(e', cases')

(* Pomocnicze funkcje *)
and free_vars e =
  match e with
  | Var x -> [x]
  | Int _ | Bool _ -> []
  | Fun(x, body) -> List.filter (fun y -> y <> x) (free_vars body)
  | App(e1, e2) -> free_vars e1 @ free_vars e2
  | Let(x, e1, e2) ->
      free_vars e1 @ List.filter (fun y -> y <> x) (free_vars e2)
  | LetRec(x, e1, e2) ->
      List.filter (fun y -> y <> x) (free_vars e1 @ free_vars e2)
  | If(cond, e1, e2) -> free_vars cond @ free_vars e1 @ free_vars e2
  | Add(e1, e2) | Mul(e1, e2) -> free_vars e1 @ free_vars e2
  | Pair(e1, e2) -> free_vars e1 @ free_vars e2
  | Fst e | Snd e -> free_vars e
  | Match(e, cases) ->
      free_vars e @
      List.concat (List.map (fun (pat, expr) ->
        let bound = pattern_vars pat in
        List.filter (fun x -> not (List.mem x bound)) (free_vars expr)
      ) cases)

and pattern_vars = function
  | PVar x -> [x]
  | PInt _ | PBool _ | PWildcard -> []
  | PPair(p1, p2) -> pattern_vars p1 @ pattern_vars p2

and rename_pattern renaming = function
  | PVar x ->
      (try PVar (List.assoc x renaming)
       with Not_found -> PVar x)
  | PPair(p1, p2) -> PPair(rename_pattern renaming p1, rename_pattern renaming p2)
  | p -> p

(* Alpha-konwersja - przemianowanie związanych zmiennych *)
let rec alpha_convert ?(suffix="") (e : expr) : expr =
  match e with
  | Var x -> Var x
  | Int n -> Int n
  | Bool b -> Bool b

  | Fun(x, body) ->
      let x' = x ^ suffix in
      let body' = subst x (Var x') body in
      Fun(x', alpha_convert ~suffix body')

  | App(e1, e2) ->
      App(alpha_convert ~suffix e1, alpha_convert ~suffix e2)

  | Let(x, e1, e2) ->
      let x' = x ^ suffix in
      let e1' = alpha_convert ~suffix e1 in
      let e2' = subst x (Var x') e2 in
      Let(x', e1', alpha_convert ~suffix e2')

  | LetRec(x, e1, e2) ->
      let x' = x ^ suffix in
      let e1' = subst x (Var x') e1 in
      let e2' = subst x (Var x') e2 in
      LetRec(x', alpha_convert ~suffix e1', alpha_convert ~suffix e2')

  | If(cond, e_then, e_else) ->
      If(alpha_convert ~suffix cond,
         alpha_convert ~suffix e_then,
         alpha_convert ~suffix e_else)

  | Add(e1, e2) -> Add(alpha_convert ~suffix e1, alpha_convert ~suffix e2)
  | Mul(e1, e2) -> Mul(alpha_convert ~suffix e1, alpha_convert ~suffix e2)
  | Pair(e1, e2) -> Pair(alpha_convert ~suffix e1, alpha_convert ~suffix e2)
  | Fst e -> Fst(alpha_convert ~suffix e)
  | Snd e -> Snd(alpha_convert ~suffix e)

  | Match(e, cases) ->
      let e' = alpha_convert ~suffix e in
      let cases' = List.map (fun (pat, expr) ->
        let pat' = rename_pattern_suffix suffix pat in
        let renaming = List.map2 (fun old new_ -> (old, new_))
          (pattern_vars pat) (pattern_vars pat') in
        let expr' = List.fold_left (fun e (old, new_) ->
          subst old (Var new_) e
        ) expr renaming in
        (pat', alpha_convert ~suffix expr')
      ) cases in
      Match(e', cases')

and rename_pattern_suffix suffix = function
  | PVar x -> PVar (x ^ suffix)
  | PPair(p1, p2) -> PPair(rename_pattern_suffix suffix p1,
                           rename_pattern_suffix suffix p2)
  | p -> p

(* Sprawdzanie alpha-równoważności *)
let rec alpha_equal (e1 : expr) (e2 : expr) : bool =
  match (e1, e2) with
  | (Var x, Var y) -> x = y
  | (Int n1, Int n2) -> n1 = n2
  | (Bool b1, Bool b2) -> b1 = b2

  | (Fun(x1, body1), Fun(x2, body2)) ->
      (* Przemianuj obie funkcje do wspólnej nazwy *)
      let z = fresh_var "tmp" in
      let body1' = subst x1 (Var z) body1 in
      let body2' = subst x2 (Var z) body2 in
      alpha_equal body1' body2'

  | (App(f1, a1), App(f2, a2)) ->
      alpha_equal f1 f2 && alpha_equal a1 a2

  | (Let(x1, e1, b1), Let(x2, e2, b2)) ->
      alpha_equal e1 e2 &&
      let z = fresh_var "tmp" in
      let b1' = subst x1 (Var z) b1 in
      let b2' = subst x2 (Var z) b2 in
      alpha_equal b1' b2'

  | (If(c1, t1, e1), If(c2, t2, e2)) ->
      alpha_equal c1 c2 && alpha_equal t1 t2 && alpha_equal e1 e2

  | (Add(a1, b1), Add(a2, b2)) | (Mul(a1, b1), Mul(a2, b2)) ->
      alpha_equal a1 a2 && alpha_equal b1 b2

  | _ -> false

(* Specjalna wersja alpha-konwersji używająca kierunku *)
let alpha_convert_directional (e : expr) : expr =
  let rec convert path e =
    match e with
    | Var x -> Var x
    | Int n -> Int n
    | Bool b -> Bool b

    | Fun(x, body) ->
        let x' = x ^ "_" ^ path ^ "f" in
        let body' = subst x (Var x') body in
        Fun(x', convert (path ^ "b") body')

    | App(e1, e2) ->
        App(convert (path ^ "l") e1, convert (path ^ "r") e2)

    | Let(x, e1, e2) ->
        let x' = x ^ "_" ^ path ^ "let" in
        let e1' = convert (path ^ "1") e1 in
        let e2' = subst x (Var x') e2 in
        Let(x', e1', convert (path ^ "2") e2')

    | LetRec(x, e1, e2) ->
        let x' = x ^ "_" ^ path ^ "rec" in
        let e1' = subst x (Var x') e1 in
        let e2' = subst x (Var x') e2 in
        LetRec(x', convert (path ^ "1") e1', convert (path ^ "2") e2')

    | If(cond, e_then, e_else) ->
        If(convert (path ^ "c") cond,
           convert (path ^ "t") e_then,
           convert (path ^ "e") e_else)

    | Add(e1, e2) -> Add(convert (path ^ "l") e1, convert (path ^ "r") e2)
    | Mul(e1, e2) -> Mul(convert (path ^ "l") e1, convert (path ^ "r") e2)
    | Pair(e1, e2) -> Pair(convert (path ^ "l") e1, convert (path ^ "r") e2)
    | Fst e -> Fst(convert (path ^ "fst") e)
    | Snd e -> Snd(convert (path ^ "snd") e)

    | Match(e, cases) ->
        let e' = convert (path ^ "m") e in
        let cases' = List.mapi (fun i (pat, expr) ->
          let case_path = path ^ "case" ^ string_of_int i in
          let pat' = rename_pattern_with_path case_path pat in
          let renaming = List.map2 (fun old new_ -> (old, new_))
            (pattern_vars pat) (pattern_vars pat') in
          let expr' = List.fold_left (fun e (old, new_) ->
            subst old (Var new_) e
          ) expr renaming in
          (pat', convert case_path expr')
        ) cases in
        Match(e', cases')

  and rename_pattern_with_path path = function
    | PVar x -> PVar (x ^ "_" ^ path)
    | PPair(p1, p2) ->
        PPair(rename_pattern_with_path (path ^ "l") p1,
              rename_pattern_with_path (path ^ "r") p2)
    | p -> p
  in
  convert "" e


(*
Testy:
- alpha_equal ex1 ex2 = true
- free_vars ex3 = ["y"]
- alpha_convert ~suffix:"_1" ex1 daje Fun("x_1", Add(Var "x_1", Var "y"))
*)