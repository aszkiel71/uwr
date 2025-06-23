(* Kompilator do maszyny stosowej *)

(* Wyrażenia źródłowe *)
type expr =
  | Const of int
  | Bool of bool
  | Var of string
  | Add of expr * expr
  | Sub of expr * expr
  | Mul of expr * expr
  | Div of expr * expr
  | Eq of expr * expr
  | Lt of expr * expr
  | And of expr * expr
  | Or of expr * expr
  | Not of expr
  | If of expr * expr * expr
  | Let of string * expr * expr
  | LetRec of string * expr * expr
  | Fun of string * expr
  | App of expr * expr
  | Pair of expr * expr
  | Fst of expr
  | Snd of expr
  | Nil
  | Cons of expr * expr
  | IsEmpty of expr
  | Match of expr * (pattern * expr) list
  | Seq of expr * expr
  | Print of expr

(* Wzorce *)
and pattern =
  | PVar of string
  | PInt of int
  | PBool of bool
  | PPair of pattern * pattern
  | PCons of pattern * pattern
  | PNil
  | PWildcard

(* Instrukcje maszyny stosowej *)
type instr =
  (* Ładowanie wartości *)
  | IPushInt of int              (* wstaw int na stos *)
  | IPushBool of bool            (* wstaw bool na stos *)
  | IPushNil                     (* wstaw pustą listę *)
  | ILoad of string              (* załaduj zmienną *)
  | ILoadLocal of int            (* załaduj zmienną lokalną po indeksie *)

  (* Operacje arytmetyczne i logiczne *)
  | IAdd | ISub | IMul | IDiv   (* operacje arytmetyczne *)
  | IEq | ILt                    (* porównania *)
  | IAnd | IOr | INot            (* operacje logiczne *)

  (* Struktury danych *)
  | IPair                        (* utwórz parę z 2 elementów na stosie *)
  | IFst | ISnd                  (* wyciągnij element pary *)
  | ICons                        (* konstruktor listy *)
  | IIsEmpty                     (* sprawdź czy lista pusta *)

  (* Zarządzanie zmiennymi *)
  | IStore of string             (* zapisz w zmiennej globalnej *)
  | IStoreLocal of int           (* zapisz w zmiennej lokalnej *)
  | IPop                         (* usuń wartość ze stosu *)
  | IDup                         (* duplikuj wartość na stosie *)
  | ISwap                        (* zamień 2 wartości na stosie *)

  (* Skoki i kontrola *)
  | IJump of int                 (* skok bezwarunkowy *)
  | IJumpIfFalse of int          (* skok jeśli false na stosie *)
  | IJumpIfTrue of int           (* skok jeśli true na stosie *)
  | ICall of int                 (* wywołanie funkcji *)
  | IReturn                      (* powrót z funkcji *)
  | ITailCall of int             (* optymalizacja tail call *)

  (* Funkcje *)
  | IMakeClosure of int * string list  (* utwórz domknięcie *)
  | IApply                       (* aplikuj funkcję *)

  (* Pattern matching *)
  | IMatchInt of int * int       (* porównaj z int, skok jeśli nie pasuje *)
  | IMatchBool of bool * int     (* porównaj z bool *)
  | IMatchNil of int             (* sprawdź czy nil *)
  | IMatchCons of int            (* sprawdź czy cons *)
  | IDestructPair                (* rozłóż parę na 2 elementy *)
  | IDestructCons                (* rozłóż cons na head i tail *)

  (* Inne *)
  | IPrint                       (* wypisz wartość *)
  | IHalt                        (* zatrzymaj program *)
  | ILabel of string             (* etykieta (do debugowania) *)

(* Środowisko kompilacji - mapuje zmienne na lokalizacje *)
type compile_env = (string * location) list
and location =
  | Global of string             (* zmienna globalna *)
  | Local of int                 (* zmienna lokalna - offset na stosie *)
  | Closure of int               (* zmienna z domknięcia *)

(* Pomocnicze funkcje *)
let rec lookup_var env x =
  match env with
  | [] -> Global x  (* zakładamy że to globalna *)
  | (y, loc) :: rest -> if x = y then loc else lookup_var rest x

(* Obliczanie offsetów dla zmiennych lokalnych *)
let add_local env x =
  let max_offset = List.fold_left (fun acc (_, loc) ->
    match loc with
    | Local n -> max acc n
    | _ -> acc
  ) 0 env in
  (x, Local (max_offset + 1)) :: env

(* Kompilacja wzorców *)
let rec compile_pattern env pat fail_label =
  match pat with
  | PInt n -> [IMatchInt(n, fail_label)]
  | PBool b -> [IMatchBool(b, fail_label)]
  | PNil -> [IMatchNil fail_label]
  | PCons(p1, p2) ->
      [IMatchCons fail_label; IDestructCons] @
      compile_pattern env p2 fail_label @
      [ISwap] @
      compile_pattern env p1 fail_label
  | PPair(p1, p2) ->
      [IDestructPair] @
      compile_pattern env p2 fail_label @
      [ISwap] @
      compile_pattern env p1 fail_label
  | PVar x ->
      (* Zmienna zawsze pasuje, tylko zapisz *)
      [IStoreLocal (match lookup_var env x with Local n -> n | _ -> 0)]
  | PWildcard -> [IPop]  (* Ignoruj wartość *)

(* Główna funkcja kompilacji *)
let rec compile (env : compile_env) (e : expr) : instr list =
  match e with
  (* Stałe *)
  | Const n -> [IPushInt n]
  | Bool b -> [IPushBool b]
  | Nil -> [IPushNil]

  (* Zmienne *)
  | Var x ->
      (match lookup_var env x with
      | Global x -> [ILoad x]
      | Local n -> [ILoadLocal n]
      | Closure n -> [ILoadLocal (-n)])  (* ujemne dla domknięcia *)

  (* Operacje arytmetyczne *)
  | Add(e1, e2) -> compile env e1 @ compile env e2 @ [IAdd]
  | Sub(e1, e2) -> compile env e1 @ compile env e2 @ [ISub]
  | Mul(e1, e2) -> compile env e1 @ compile env e2 @ [IMul]
  | Div(e1, e2) -> compile env e1 @ compile env e2 @ [IDiv]

  (* Porównania *)
  | Eq(e1, e2) -> compile env e1 @ compile env e2 @ [IEq]
  | Lt(e1, e2) -> compile env e1 @ compile env e2 @ [ILt]

  (* Operacje logiczne *)
  | And(e1, e2) ->
      (* Short-circuit evaluation *)
      let false_label = List.length (compile env e2) + 2 in
      compile env e1 @
      [IDup; IJumpIfFalse false_label; IPop] @
      compile env e2

  | Or(e1, e2) ->
      (* Short-circuit evaluation *)
      let true_label = List.length (compile env e2) + 2 in
      compile env e1 @
      [IDup; IJumpIfTrue true_label; IPop] @
      compile env e2

  | Not e -> compile env e @ [INot]

  (* If-then-else *)
  | If(cond, e_then, e_else) ->
      let then_code = compile env e_then in
      let else_code = compile env e_else in
      let then_length = List.length then_code in
      let else_length = List.length else_code in
      compile env cond @
      [IJumpIfFalse (then_length + 1)] @  (* +1 dla IJump *)
      then_code @
      [IJump else_length] @
      else_code

  (* Let binding *)
  | Let(x, e1, e2) ->
      let env' = add_local env x in
      compile env e1 @
      [IStoreLocal (match lookup_var env' x with Local n -> n | _ -> 0)] @
      compile env' e2 @
      [ISwap; IPop]  (* Usuń zmienną lokalną *)

  (* Let rec - tylko dla funkcji *)
  | LetRec(f, Fun(x, body), e2) ->
      let env' = add_local env f in
      let env'' = add_local env' x in
      let body_code = compile env'' body @ [IReturn] in
      let closure_addr = List.length body_code + 2 in
      [IJump closure_addr] @
      [ILabel (f ^ "_body")] @
      body_code @
      [IMakeClosure(-(List.length body_code + 1), [f])] @
      [IStoreLocal (match lookup_var env' f with Local n -> n | _ -> 0)] @
      compile env' e2 @
      [ISwap; IPop]
  | LetRec _ -> failwith "let rec requires function"

  (* Funkcje *)
  | Fun(x, body) ->
      let env' = add_local env x in
      let body_code = compile env' body @ [IReturn] in
      let closure_addr = List.length body_code + 1 in
      [IJump closure_addr] @
      body_code @
      [IMakeClosure(-(List.length body_code), [])]

  (* Aplikacja *)
  | App(e1, e2) ->
      compile env e1 @ compile env e2 @ [IApply]

  (* Pary *)
  | Pair(e1, e2) ->
      compile env e1 @ compile env e2 @ [IPair]

  | Fst e -> compile env e @ [IFst]
  | Snd e -> compile env e @ [ISnd]

  (* Listy *)
  | Cons(e1, e2) ->
      compile env e1 @ compile env e2 @ [ICons]

  | IsEmpty e -> compile env e @ [IIsEmpty]

  (* Pattern matching *)
  | Match(e, cases) ->
      let compile_case (pat, expr) next_label =
        let fail_label = next_label in
        compile_pattern env pat fail_label @
        compile env expr @
        [IJump 0]  (* Placeholder - będzie poprawiony *)
      in
      compile env e @
      [IDup] @  (* Zachowaj wartość do matchowania *)
      (let rec compile_cases = function
        | [] -> failwith "Match exhaustiveness not checked"
        | [pat, expr] ->
            compile_pattern env pat 0 @ compile env expr
        | (pat, expr) :: rest ->
            let rest_code = compile_cases rest in
            let case_code = compile_pattern env pat (List.length rest_code) @
                           compile env expr in
            case_code @ rest_code
      in compile_cases cases)

  (* Sekwencje *)
  | Seq(e1, e2) ->
      compile env e1 @ [IPop] @ compile env e2

  (* Wypisywanie *)
  | Print e ->
      compile env e @ [IPrint]

(* Optymalizacje *)
let rec optimize (instrs : instr list) : instr list =
  match instrs with
  | [] -> []
  | IPushInt n1 :: IPushInt n2 :: IAdd :: rest ->
      optimize (IPushInt (n1 + n2) :: rest)
  | IPushInt n1 :: IPushInt n2 :: ISub :: rest ->
      optimize (IPushInt (n1 - n2) :: rest)
  | IPushInt n1 :: IPushInt n2 :: IMul :: rest ->
      optimize (IPushInt (n1 * n2) :: rest)
  | IJump 0 :: rest -> optimize rest
  | IPop :: IPushInt n :: rest -> optimize (IPushInt n :: rest)
  | instr :: rest -> instr :: optimize rest

(* Funkcja główna kompilatora *)
let compile_program e =
  let code = compile [] e @ [IHalt] in
  optimize code

(* Przykład *)
let example =
  Let("x", Const 10,
    Let("y", Const 20,
      If(Lt(Var "x", Var "y"),
         Add(Var "x", Var "y"),
         Sub(Var "y", Var "x"))))

(* let compiled = compile_program example *)
(* Wynik: lista instrukcji dla maszyny stosowej *)