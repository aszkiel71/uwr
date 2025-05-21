open RawAst

exception Type_error of
  (Lexing.position * Lexing.position) * string

module Env = struct
  module StrMap = Map.Make(String)
  type t = typ StrMap.t

  let initial = StrMap.empty

  let add_var env x tp =
    StrMap.add x tp env

  let lookup_var env x =
    StrMap.find_opt x env
end

let rec string_of_typ = function
  | TInt -> "int"
  | TBool -> "bool"
  | TUnit -> "unit"
  | TPair(t1, t2) -> Printf.sprintf "(%s * %s)" (string_of_typ t1) (string_of_typ t2)
  | TArrow(t1, t2) -> Printf.sprintf "(%s -> %s)" (string_of_typ t1) (string_of_typ t2)

let rec infer_type env (e : expr) (errors : ((Lexing.position * Lexing.position) * string) list ref) : typ = (*---*)
  match e.data with
  | Unit   -> TUnit
  | Int  _ -> TInt
  | Bool _ -> TBool
  | Var  x ->
    begin match Env.lookup_var env x with
    | Some tp -> tp
    | None    ->
      errors := (e.pos, Printf.sprintf "Unbound variable %s" x) :: !errors;
      TUnit 
    end
  | Binop((Add | Sub | Mult | Div), e1, e2) ->
    check_type env e1 TInt errors; 
    check_type env e2 TInt errors; 
    TInt
  | Binop((And | Or), e1, e2) ->
    check_type env e1 TBool errors; 
    check_type env e2 TBool errors; 
    TBool
  | Binop((Leq | Lt | Geq | Gt), e1, e2) ->
    check_type env e1 TInt errors;
    check_type env e2 TInt errors; 
    TBool
  | Binop((Eq | Neq), e1, e2) ->
    let tp = infer_type env e1 errors in 
    check_type env e2 tp errors; 
    TBool
  | If(b, e1, e2) ->
    check_type env b TBool errors; 
    let tp = infer_type env e1 errors in 
    check_type env e2 tp errors; 
    tp
  | Let(x, e1, e2) ->
    let tp1 = infer_type env e1 errors in 
    let tp2 = infer_type (Env.add_var env x tp1) e2 errors in 
    tp2
  | Pair(e1, e2) ->
    TPair(infer_type env e1 errors, infer_type env e2 errors) 
  | App(e1, e2) ->
    begin match infer_type env e1 errors with 
    | TArrow(tp2, tp1) ->
      check_type env e2 tp2 errors;
      tp1
    | other ->
      errors := (e.pos,
        Printf.sprintf "Application: expected function type, got %s"
          (string_of_typ other)) :: !errors; 
      TUnit
    end
  | Fst e ->
    begin match infer_type env e errors with 
    | TPair(tp1, _) -> tp1
    | other ->
      errors := (e.pos,
        Printf.sprintf "Fst: expected pair, got %s"
          (string_of_typ other)) :: !errors; 
      TUnit 
    end
  | Snd e ->
    begin match infer_type env e errors with 
    | TPair(_, tp2) -> tp2
    | other ->
      errors := (e.pos,
        Printf.sprintf "Snd: expected pair, got %s"
          (string_of_typ other)) :: !errors;
      TUnit 
    end
  | Fun(x, tp1, e) ->
    let tp2 = infer_type (Env.add_var env x tp1) e errors in
    TArrow(tp1, tp2)
  | Funrec(f, x, tp1, tp2, e) ->
    let env = Env.add_var env x tp1 in
    let env = Env.add_var env f (TArrow(tp1, tp2)) in
    check_type env e tp2 errors; 
    TArrow(tp1, tp2)

and check_type env e tp errors =
  let tp' = infer_type env e errors in
  if tp = tp' then ()
  else
    errors := (e.pos,
      Printf.sprintf "Type mismatch: expected %s, got %s"
        (string_of_typ tp) (string_of_typ tp')) :: !errors

let check_program e =
  let errors = ref [] in
  let _ = infer_type Env.initial e errors in 
  if !errors <> [] then (
  List.iter (fun (_, msg) -> Printf.printf "Type error: %s\n" msg) !errors; 
  failwith "Type errors found" 
  ) else
    e
