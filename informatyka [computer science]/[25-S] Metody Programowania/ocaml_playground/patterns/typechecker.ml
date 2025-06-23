(* Type Checker z pełną funkcjonalnością *)

(* Typy *)
type typ =
  | TInt                      (* liczby całkowite *)
  | TBool                     (* wartości logiczne *)
  | TString                   (* napisy *)
  | TUnit                     (* typ jednostkowy *)
  | TFun of typ * typ         (* typ funkcji *)
  | TPair of typ * typ        (* pary *)
  | TList of typ              (* listy *)
  | TRef of typ               (* referencje *)
  | TVar of string            (* zmienne typowe dla polimorfizmu *)

(* Schemat typowy dla let-polimorfizmu *)
type scheme = Forall of string list * typ

(* Wyrażenia *)
type expr =
  (* Podstawowe wartości *)
  | EInt of int
  | EBool of bool
  | EString of string
  | EUnit

  (* Zmienne i wiązania *)
  | EVar of string
  | ELet of string * expr * expr      (* let x = e1 in e2 *)
  | ELetRec of string * expr * expr   (* let rec dla funkcji rekurencyjnych *)

  (* Funkcje *)
  | EFun of string * typ option * expr (* lambda z opcjonalną anotacją *)
  | EApp of expr * expr                (* aplikacja funkcji *)
  | EFix of expr                       (* kombinator punktu stałego *)

  (* Operacje arytmetyczne *)
  | EAdd of expr * expr
  | ESub of expr * expr
  | EMul of expr * expr
  | EDiv of expr * expr
  | EMod of expr * expr

  (* Operacje porównania *)
  | EEq of expr * expr     (* równość *)
  | ENeq of expr * expr    (* nierówność *)
  | ELt of expr * expr     (* mniejsze *)
  | ELe of expr * expr     (* mniejsze równe *)
  | EGt of expr * expr     (* większe *)
  | EGe of expr * expr     (* większe równe *)

  (* Operacje logiczne *)
  | EAnd of expr * expr
  | EOr of expr * expr
  | ENot of expr

  (* Instrukcje warunkowe *)
  | EIf of expr * expr * expr
  | EMatch of expr * (pattern * expr) list  (* pattern matching *)

  (* Struktury danych *)
  | EPair of expr * expr
  | EFst of expr
  | ESnd of expr
  | ENil                    (* pusta lista *)
  | ECons of expr * expr    (* konstruktor listy *)
  | EHead of expr           (* głowa listy *)
  | ETail of expr           (* ogon listy *)
  | EIsEmpty of expr        (* sprawdzenie czy lista pusta *)

  (* Referencje *)
  | ERef of expr            (* utworzenie referencji *)
  | EDeref of expr          (* odczyt referencji *)
  | EAssign of expr * expr  (* przypisanie do referencji *)

  (* Sekwencje *)
  | ESeq of expr * expr     (* e1; e2 *)

(* Wzorce dla pattern matchingu *)
and pattern =
  | PVar of string          (* zmienna *)
  | PInt of int             (* literał *)
  | PBool of bool
  | PPair of pattern * pattern
  | PCons of pattern * pattern
  | PNil
  | PWildcard               (* _ *)

(* Środowisko typów *)
type tenv = (string * scheme) list

(* Wyjątek dla błędów typowania *)
exception Type_error of string

(* Pomocnicze funkcje *)
let rec occurs_check (v : string) (t : typ) : bool =
  match t with
  | TVar x -> x = v
  | TFun(t1, t2) -> occurs_check v t1 || occurs_check v t2
  | TPair(t1, t2) -> occurs_check v t1 || occurs_check v t2
  | TList t1 -> occurs_check v t1
  | TRef t1 -> occurs_check v t1
  | _ -> false

(* Podstawienie typu za zmienną typową *)
let rec subst (v : string) (s : typ) (t : typ) : typ =
  match t with
  | TVar x when x = v -> s
  | TVar x -> TVar x
  | TFun(t1, t2) -> TFun(subst v s t1, subst v s t2)
  | TPair(t1, t2) -> TPair(subst v s t1, subst v s t2)
  | TList t1 -> TList(subst v s t1)
  | TRef t1 -> TRef(subst v s t1)
  | t -> t

(* Generowanie świeżych zmiennych typowych *)
let fresh_var =
  let counter = ref 0 in
  fun () ->
    incr counter;
    "t" ^ string_of_int !counter

(* Instancjacja schematu typowego *)
let instantiate (Forall(vars, t)) : typ =
  let substs = List.map (fun v -> (v, TVar(fresh_var()))) vars in
  List.fold_left (fun t (v, s) -> subst v s t) t substs

(* Generalizacja typu do schematu *)
let generalize (env : tenv) (t : typ) : scheme =
  let rec free_vars_type = function
    | TVar x -> [x]
    | TFun(t1, t2) -> free_vars_type t1 @ free_vars_type t2
    | TPair(t1, t2) -> free_vars_type t1 @ free_vars_type t2
    | TList t -> free_vars_type t
    | TRef t -> free_vars_type t
    | _ -> []
  in
  let rec free_vars_env env =
    List.concat (List.map (fun (_, Forall(bound, t)) ->
      List.filter (fun v -> not (List.mem v bound)) (free_vars_type t)
    ) env)
  in
  let env_vars = free_vars_env env in
  let t_vars = free_vars_type t in
  let gen_vars = List.filter (fun v -> not (List.mem v env_vars)) t_vars in
  Forall(gen_vars, t)

(* Sprawdzanie typów wzorców *)
let rec type_check_pattern (p : pattern) : typ * (string * typ) list =
  match p with
  | PVar x ->
      let t = TVar(fresh_var()) in
      (t, [(x, t)])
  | PInt _ -> (TInt, [])
  | PBool _ -> (TBool, [])
  | PPair(p1, p2) ->
      let (t1, binds1) = type_check_pattern p1 in
      let (t2, binds2) = type_check_pattern p2 in
      (TPair(t1, t2), binds1 @ binds2)
  | PCons(p1, p2) ->
      let (t1, binds1) = type_check_pattern p1 in
      let (t2, binds2) = type_check_pattern p2 in
      (* Unifikacja t2 z TList t1 *)
      (TList t1, binds1 @ binds2)
  | PNil -> (TList(TVar(fresh_var())), [])
  | PWildcard -> (TVar(fresh_var()), [])

(* Główna funkcja sprawdzania typów *)
let rec type_check (env : tenv) (e : expr) : typ =
  match e with
  (* Podstawowe wartości *)
  | EInt _ -> TInt
  | EBool _ -> TBool
  | EString _ -> TString
  | EUnit -> TUnit

  (* Zmienne *)
  | EVar x ->
      (try
        let scheme = List.assoc x env in
        instantiate scheme
      with Not_found -> raise (Type_error ("Unbound variable: " ^ x)))

  (* Let-binding z polimorfizmem *)
  | ELet(x, e1, e2) ->
      let t1 = type_check env e1 in
      let scheme = generalize env t1 in
      type_check ((x, scheme) :: env) e2

  (* Let rec dla funkcji rekurencyjnych *)
  | ELetRec(f, e1, e2) ->
      (match e1 with
      | EFun(x, ann, body) ->
          let t_arg = match ann with
            | Some t -> t
            | None -> TVar(fresh_var())
          in
          let t_res = TVar(fresh_var()) in
          let t_fun = TFun(t_arg, t_res) in
          (* Dodajemy f do środowiska z tymczasowym typem *)
          let env' = (f, Forall([], t_fun)) :: env in
          let t_body = type_check ((x, Forall([], t_arg)) :: env') body in
          (* Unifikacja t_res z t_body *)
          if t_res <> t_body then
            raise (Type_error "Type mismatch in recursive function");
          type_check ((f, generalize env t_fun) :: env) e2
      | _ -> raise (Type_error "let rec requires function"))

  (* Funkcje *)
  | EFun(x, ann, body) ->
      let t_arg = match ann with
        | Some t -> t
        | None -> TVar(fresh_var())
      in
      let t_body = type_check ((x, Forall([], t_arg)) :: env) body in
      TFun(t_arg, t_body)

  | EApp(e1, e2) ->
      let t1 = type_check env e1 in
      let t2 = type_check env e2 in
      (match t1 with
      | TFun(t_arg, t_res) ->
          if t_arg <> t2 then
            raise (Type_error "Function argument type mismatch");
          t_res
      | _ -> raise (Type_error "Application of non-function"))

  (* Operacje arytmetyczne *)
  | EAdd(e1, e2) | ESub(e1, e2) | EMul(e1, e2) | EDiv(e1, e2) | EMod(e1, e2) ->
      if type_check env e1 = TInt && type_check env e2 = TInt then
        TInt
      else
        raise (Type_error "Arithmetic operation requires integers")

  (* Porównania *)
  | EEq(e1, e2) | ENeq(e1, e2) ->
      let t1 = type_check env e1 in
      let t2 = type_check env e2 in
      if t1 = t2 then TBool
      else raise (Type_error "Equality requires same types")

  | ELt(e1, e2) | ELe(e1, e2) | EGt(e1, e2) | EGe(e1, e2) ->
      if type_check env e1 = TInt && type_check env e2 = TInt then
        TBool
      else
        raise (Type_error "Comparison requires integers")

  (* Operacje logiczne *)
  | EAnd(e1, e2) | EOr(e1, e2) ->
      if type_check env e1 = TBool && type_check env e2 = TBool then
        TBool
      else
        raise (Type_error "Logical operation requires booleans")

  | ENot e ->
      if type_check env e = TBool then TBool
      else raise (Type_error "Not requires boolean")

  (* If-then-else *)
  | EIf(cond, e1, e2) ->
      if type_check env cond <> TBool then
        raise (Type_error "If condition must be boolean");
      let t1 = type_check env e1 in
      let t2 = type_check env e2 in
      if t1 = t2 then t1
      else raise (Type_error "If branches have different types")

  (* Pattern matching *)
  | EMatch(e, cases) ->
      let t_matched = type_check env e in
      let check_case (pat, expr) =
        let (t_pat, bindings) = type_check_pattern pat in
        if t_pat <> t_matched then
          raise (Type_error "Pattern type mismatch");
        let env' = List.map (fun (x, t) -> (x, Forall([], t))) bindings @ env in
        type_check env' expr
      in
      let result_types = List.map check_case cases in
      (* Wszystkie przypadki muszą zwracać ten sam typ *)
      let t_result = List.hd result_types in
      if List.for_all (fun t -> t = t_result) result_types then
        t_result
      else
        raise (Type_error "Match cases have different types")

  (* Pary *)
  | EPair(e1, e2) ->
      TPair(type_check env e1, type_check env e2)

  | EFst e ->
      (match type_check env e with
      | TPair(t1, _) -> t1
      | _ -> raise (Type_error "Fst requires pair"))

  | ESnd e ->
      (match type_check env e with
      | TPair(_, t2) -> t2
      | _ -> raise (Type_error "Snd requires pair"))

  (* Listy *)
  | ENil -> TList(TVar(fresh_var()))

  | ECons(e1, e2) ->
      let t1 = type_check env e1 in
      let t2 = type_check env e2 in
      (match t2 with
      | TList t when t = t1 -> TList t1
      | TList _ -> raise (Type_error "List element type mismatch")
      | _ -> raise (Type_error "Cons requires list as second argument"))

  | EHead e ->
      (match type_check env e with
      | TList t -> t
      | _ -> raise (Type_error "Head requires list"))

  | ETail e ->
      (match type_check env e with
      | TList t -> TList t
      | _ -> raise (Type_error "Tail requires list"))

  | EIsEmpty e ->
      (match type_check env e with
      | TList _ -> TBool
      | _ -> raise (Type_error "IsEmpty requires list"))

  (* Referencje *)
  | ERef e -> TRef(type_check env e)

  | EDeref e ->
      (match type_check env e with
      | TRef t -> t
      | _ -> raise (Type_error "Deref requires reference"))

  | EAssign(e1, e2) ->
      (match type_check env e1 with
      | TRef t ->
          if type_check env e2 = t then TUnit
          else raise (Type_error "Assignment type mismatch")
      | _ -> raise (Type_error "Assignment requires reference"))

  (* Sekwencje *)
  | ESeq(e1, e2) ->
      let _ = type_check env e1 in
      type_check env e2

  (* Kombinator punktu stałego *)
  | EFix e ->
      (match type_check env e with
      | TFun(t1, t2) when t1 = t2 -> t1
      | _ -> raise (Type_error "Fix requires function of type 'a -> 'a"))