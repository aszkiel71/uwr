(* Interpreter z pełną funkcjonalnością *)

(* Wyrażenia - te same co w type checkerze *)
type expr =
  (* Podstawowe wartości *)
  | Int of int
  | Bool of bool
  | String of string
  | Unit

  (* Zmienne i wiązania *)
  | Var of string
  | Let of string * expr * expr
  | LetRec of string * expr * expr

  (* Funkcje *)
  | Fun of string * expr           (* lambda *)
  | App of expr * expr            (* aplikacja *)
  | Fix of expr                   (* kombinator Y *)

  (* Operacje arytmetyczne *)
  | Add of expr * expr
  | Sub of expr * expr
  | Mul of expr * expr
  | Div of expr * expr
  | Mod of expr * expr

  (* Porównania *)
  | Eq of expr * expr
  | Neq of expr * expr
  | Lt of expr * expr
  | Le of expr * expr
  | Gt of expr * expr
  | Ge of expr * expr

  (* Operacje logiczne *)
  | And of expr * expr
  | Or of expr * expr
  | Not of expr

  (* Instrukcje warunkowe *)
  | If of expr * expr * expr
  | Match of expr * (pattern * expr) list

  (* Struktury danych *)
  | Pair of expr * expr
  | Fst of expr
  | Snd of expr
  | Nil
  | Cons of expr * expr
  | Head of expr
  | Tail of expr
  | IsEmpty of expr

  (* Referencje *)
  | Ref of expr
  | Deref of expr
  | Assign of expr * expr

  (* Sekwencje i efekty uboczne *)
  | Seq of expr * expr
  | Print of expr              (* wypisywanie *)
  | Read                       (* czytanie z stdin *)

  (* Wyjątki *)
  | Raise of expr
  | TryCatch of expr * string * expr

(* Wzorce *)
and pattern =
  | PVar of string
  | PInt of int
  | PBool of bool
  | PPair of pattern * pattern
  | PCons of pattern * pattern
  | PNil
  | PWildcard

(* Wartości *)
type value =
  | VInt of int
  | VBool of bool
  | VString of string
  | VUnit
  | VClosure of string * expr * env      (* domknięcie *)
  | VRecClosure of string * string * expr * env  (* rekurencyjne domknięcie *)
  | VPair of value * value
  | VNil
  | VCons of value * value
  | VRef of value ref                     (* referencja *)
  | VBuiltin of string * (value -> value) (* wbudowane funkcje *)

(* Środowisko *)
and env = (string * value) list

(* Wyjątki runtime *)
exception Runtime_error of string
exception User_exception of value

(* Store dla referencji *)
let store : (int * value ref) list ref = ref []
let next_loc = ref 0

(* Pomocnicze funkcje *)
let rec lookup env x =
  match env with
  | [] -> raise (Runtime_error ("Unbound variable: " ^ x))
  | (y, v) :: rest -> if x = y then v else lookup rest x

(* Dopasowanie wzorca *)
let rec match_pattern (pat : pattern) (v : value) : (string * value) list option =
  match (pat, v) with
  | (PVar x, v) -> Some [(x, v)]
  | (PInt n, VInt m) when n = m -> Some []
  | (PBool b, VBool c) when b = c -> Some []
  | (PPair(p1, p2), VPair(v1, v2)) ->
      (match (match_pattern p1 v1, match_pattern p2 v2) with
      | (Some binds1, Some binds2) -> Some (binds1 @ binds2)
      | _ -> None)
  | (PCons(p1, p2), VCons(v1, v2)) ->
      (match (match_pattern p1 v1, match_pattern p2 v2) with
      | (Some binds1, Some binds2) -> Some (binds1 @ binds2)
      | _ -> None)
  | (PNil, VNil) -> Some []
  | (PWildcard, _) -> Some []
  | _ -> None

(* Konwersja wartości na string *)
let rec value_to_string = function
  | VInt n -> string_of_int n
  | VBool b -> string_of_bool b
  | VString s -> "\"" ^ s ^ "\""
  | VUnit -> "()"
  | VClosure _ -> "<fun>"
  | VRecClosure _ -> "<fun>"
  | VPair(v1, v2) -> "(" ^ value_to_string v1 ^ ", " ^ value_to_string v2 ^ ")"
  | VNil -> "[]"
  | VCons(v1, v2) ->
      let rec list_to_string = function
        | VNil -> "]"
        | VCons(v, rest) -> ", " ^ value_to_string v ^ list_to_string rest
        | v -> " :: " ^ value_to_string v ^ "]"
      in
      "[" ^ value_to_string v1 ^
      (match v2 with VNil -> "]" | _ -> list_to_string v2)
  | VRef _ -> "<ref>"
  | VBuiltin(name, _) -> "<builtin: " ^ name ^ ">"

(* Główna funkcja ewaluacji *)
let rec eval (env : env) (e : expr) : value =
  match e with
  (* Podstawowe wartości *)
  | Int n -> VInt n
  | Bool b -> VBool b
  | String s -> VString s
  | Unit -> VUnit

  (* Zmienne *)
  | Var x -> lookup env x

  (* Let-binding *)
  | Let(x, e1, e2) ->
      let v1 = eval env e1 in
      eval ((x, v1) :: env) e2

  (* Let rec - tylko dla funkcji *)
  | LetRec(f, e1, e2) ->
      (match e1 with
      | Fun(x, body) ->
          let rec_val = VRecClosure(f, x, body, env) in
          eval ((f, rec_val) :: env) e2
      | _ -> raise (Runtime_error "let rec requires function"))

  (* Funkcje *)
  | Fun(x, body) -> VClosure(x, body, env)

  | App(e1, e2) ->
      let v1 = eval env e1 in
      let v2 = eval env e2 in
      (match v1 with
      | VClosure(x, body, closure_env) ->
          eval ((x, v2) :: closure_env) body
      | VRecClosure(f, x, body, closure_env) ->
          (* Dodajemy funkcję do środowiska dla rekurencji *)
          let rec_env = (f, v1) :: closure_env in
          eval ((x, v2) :: rec_env) body
      | VBuiltin(_, f) -> f v2
      | _ -> raise (Runtime_error "Application of non-function"))

  (* Operacje arytmetyczne *)
  | Add(e1, e2) ->
      (match (eval env e1, eval env e2) with
      | (VInt n1, VInt n2) -> VInt (n1 + n2)
      | _ -> raise (Runtime_error "Addition requires integers"))

  | Sub(e1, e2) ->
      (match (eval env e1, eval env e2) with
      | (VInt n1, VInt n2) -> VInt (n1 - n2)
      | _ -> raise (Runtime_error "Subtraction requires integers"))

  | Mul(e1, e2) ->
      (match (eval env e1, eval env e2) with
      | (VInt n1, VInt n2) -> VInt (n1 * n2)
      | _ -> raise (Runtime_error "Multiplication requires integers"))

  | Div(e1, e2) ->
      (match (eval env e1, eval env e2) with
      | (VInt n1, VInt n2) ->
          if n2 = 0 then raise (Runtime_error "Division by zero")
          else VInt (n1 / n2)
      | _ -> raise (Runtime_error "Division requires integers"))

  | Mod(e1, e2) ->
      (match (eval env e1, eval env e2) with
      | (VInt n1, VInt n2) ->
          if n2 = 0 then raise (Runtime_error "Modulo by zero")
          else VInt (n1 mod n2)
      | _ -> raise (Runtime_error "Modulo requires integers"))

  (* Porównania *)
  | Eq(e1, e2) ->
      let v1 = eval env e1 in
      let v2 = eval env e2 in
      VBool (v1 = v2)

  | Neq(e1, e2) ->
      let v1 = eval env e1 in
      let v2 = eval env e2 in
      VBool (v1 <> v2)

  | Lt(e1, e2) ->
      (match (eval env e1, eval env e2) with
      | (VInt n1, VInt n2) -> VBool (n1 < n2)
      | _ -> raise (Runtime_error "Comparison requires integers"))

  | Le(e1, e2) ->
      (match (eval env e1, eval env e2) with
      | (VInt n1, VInt n2) -> VBool (n1 <= n2)
      | _ -> raise (Runtime_error "Comparison requires integers"))

  | Gt(e1, e2) ->
      (match (eval env e1, eval env e2) with
      | (VInt n1, VInt n2) -> VBool (n1 > n2)
      | _ -> raise (Runtime_error "Comparison requires integers"))

  | Ge(e1, e2) ->
      (match (eval env e1, eval env e2) with
      | (VInt n1, VInt n2) -> VBool (n1 >= n2)
      | _ -> raise (Runtime_error "Comparison requires integers"))

  (* Operacje logiczne *)
  | And(e1, e2) ->
      (match eval env e1 with
      | VBool false -> VBool false  (* short-circuit *)
      | VBool true ->
          (match eval env e2 with
          | VBool b -> VBool b
          | _ -> raise (Runtime_error "And requires booleans"))
      | _ -> raise (Runtime_error "And requires booleans"))

  | Or(e1, e2) ->
      (match eval env e1 with
      | VBool true -> VBool true  (* short-circuit *)
      | VBool false ->
          (match eval env e2 with
          | VBool b -> VBool b
          | _ -> raise (Runtime_error "Or requires booleans"))
      | _ -> raise (Runtime_error "Or requires booleans"))

  | Not e ->
      (match eval env e with
      | VBool b -> VBool (not b)
      | _ -> raise (Runtime_error "Not requires boolean"))

  (* If-then-else *)
  | If(cond, e1, e2) ->
      (match eval env cond with
      | VBool true -> eval env e1
      | VBool false -> eval env e2
      | _ -> raise (Runtime_error "If condition must be boolean"))

  (* Pattern matching *)
  | Match(e, cases) ->
      let v = eval env e in
      let rec try_cases = function
        | [] -> raise (Runtime_error "No matching pattern")
        | (pat, expr) :: rest ->
            (match match_pattern pat v with
            | Some bindings -> eval (bindings @ env) expr
            | None -> try_cases rest)
      in
      try_cases cases

  (* Pary *)
  | Pair(e1, e2) ->
      VPair(eval env e1, eval env e2)

  | Fst e ->
      (match eval env e with
      | VPair(v1, _) -> v1
      | _ -> raise (Runtime_error "Fst requires pair"))

  | Snd e ->
      (match eval env e with
      | VPair(_, v2) -> v2
      | _ -> raise (Runtime_error "Snd requires pair"))

  (* Listy *)
  | Nil -> VNil

  | Cons(e1, e2) ->
      VCons(eval env e1, eval env e2)

  | Head e ->
      (match eval env e with
      | VCons(v, _) -> v
      | _ -> raise (Runtime_error "Head of empty list"))

  | Tail e ->
      (match eval env e with
      | VCons(_, rest) -> rest
      | _ -> raise (Runtime_error "Tail of empty list"))

  | IsEmpty e ->
      (match eval env e with
      | VNil -> VBool true
      | VCons _ -> VBool false
      | _ -> raise (Runtime_error "IsEmpty requires list"))

  (* Referencje *)
  | Ref e ->
      let v = eval env e in
      let r = ref v in
      let loc = !next_loc in
      incr next_loc;
      store := (loc, r) :: !store;
      VRef r

  | Deref e ->
      (match eval env e with
      | VRef r -> !r
      | _ -> raise (Runtime_error "Deref requires reference"))

  | Assign(e1, e2) ->
      (match eval env e1 with
      | VRef r ->
          let v = eval env e2 in
          r := v;
          VUnit
      | _ -> raise (Runtime_error "Assignment requires reference"))

  (* Sekwencje *)
  | Seq(e1, e2) ->
      let _ = eval env e1 in
      eval env e2

  (* Wypisywanie *)
  | Print e ->
      let v = eval env e in
      print_endline (value_to_string v);
      VUnit

  (* Czytanie *)
  | Read ->
      let line = read_line () in
      (try VInt (int_of_string line)
       with _ -> VString line)

  (* Wyjątki *)
  | Raise e ->
      let v = eval env e in
      raise (User_exception v)

  | TryCatch(e1, x, e2) ->
      (try eval env e1
       with User_exception v -> eval ((x, v) :: env) e2)

  (* Kombinator punktu stałego *)
  | Fix e ->
      (match eval env e with
      | VClosure(x, body, closure_env) as f ->
          (* fix f = f (fix f) *)
          let rec fix_val = VRecClosure("fix", x,
            App(Var x, App(Var "fix", Var x)),
            ("fix", f) :: closure_env) in
          eval ((x, fix_val) :: closure_env) body
      | _ -> raise (Runtime_error "Fix requires function"))

(* Środowisko początkowe z funkcjami wbudowanymi *)
let initial_env = [
  (* Funkcje matematyczne *)
  ("sqrt", VBuiltin("sqrt", function
    | VInt n -> VInt (int_of_float (sqrt (float_of_int n)))
    | _ -> raise (Runtime_error "sqrt requires integer")));

  ("abs", VBuiltin("abs", function
    | VInt n -> VInt (abs n)
    | _ -> raise (Runtime_error "abs requires integer")));

  (* Konwersje *)
  ("int_of_string", VBuiltin("int_of_string", function
    | VString s ->
        (try VInt (int_of_string s)
         with _ -> raise (Runtime_error "Invalid integer string"))
    | _ -> raise (Runtime_error "int_of_string requires string")));

  ("string_of_int", VBuiltin("string_of_int", function
    | VInt n -> VString (string_of_int n)
    | _ -> raise (Runtime_error "string_of_int requires integer")));
]

(* Przykład użycia *)
let example_program =
  Let("factorial",
    LetRec("fact",
      Fun("n",
        If(Le(Var "n", Int 1),
           Int 1,
           Mul(Var "n", App(Var "fact", Sub(Var "n", Int 1))))),
      Var "fact"),
    App(Var "factorial", Int 5))

(* let result = eval initial_env example_program *)
(* Wynik: VInt 120 *)