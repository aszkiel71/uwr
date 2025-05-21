
module I = Interp

(* Składnia RPN *)



type cmd =
  | PushInt  of int
  | PushBool of bool
  | PushPair
  | PushUnit
  | Fst
  | Snd
  | IsPair
  | Binop    of Ast.bop
  | CndJmp   of prog * prog
  | Store
  | Load     of int
  | CleanUp
  | PushVar of string

and prog = cmd list

(* Kompilacja do RPN *)

(* srodowisko w czasie kompilacji opisuje zmienne w syntaktycznym
 * kontekscie, tak ze find_index zwraca indeks de Bruijna zmiennej
 *)
type env = Ast.ident list
(*type env = (string * I.value) list*)
let rec find_index (x : Ast.ident) (env : env) : int =
  match env with
  | y :: _ when x = y -> 0
  | _ :: ys -> find_index x ys + 1
  | [] -> failwith ("unknown var " ^ x)

let rec of_ast (env : env) (expr : Ast.expr) : prog =
  match expr with
  | Ast.Int n ->
      [PushInt n]
  | Ast.Bool b ->
      [PushBool b]
  | Ast.Binop (op, e1, e2) ->
      of_ast env e1 @ of_ast env e2 @ [Binop op]
  | Ast.If (b, t, e) ->
      of_ast env b @ [CndJmp (of_ast env t, of_ast env e)]
  | Ast.Pair (e1, e2) ->
      of_ast env e1 @ of_ast env e2 @ [PushPair]
  | Ast.Fst e ->
      of_ast env e @ [Fst]
  | Ast.Snd e ->
      of_ast env e @ [Snd]
  | Ast.Unit ->
      [PushUnit]
  | Ast.IsPair e ->
      of_ast env e @ [IsPair]
  | Ast.Var x ->
      [Load (find_index x env)]
  | Ast.Let (x, e1, e2) ->
       of_ast env e1 @ [Store] @ of_ast (x :: env) e2 @ [CleanUp]
  | _ ->
      failwith "not implemented"

(* Ewaluator dla RPN *)

(* ewaluator nie jest elementem procesu kompilacji, ale
 * przydaje się do testowania i debugowania
 *)
let rec eval (env : I.value list) (s : I.value list) (p : prog) : I.value =
  match p, s with
  | [], [n] -> n
  | [], _   -> failwith "error!"
  | (PushInt n :: p'), _ ->
      eval env (I.VInt n :: s) p'
  | (PushBool b :: p'), _ ->
      eval env (I.VBool b :: s) p'
  | (Binop op :: p'), (v2 :: v1 :: s') ->
      eval env (I.eval_op op v1 v2 :: s') p'
  | (CndJmp (t,_) :: p'), (I.VBool true :: s') ->
      eval env s' (t @ p')
  | (CndJmp (_,e) :: p'), (I.VBool false :: s') ->
      eval env s' (e @ p')
  | (PushPair :: p'), (v2 :: v1 :: s') ->
      eval env (I.VPair (v1, v2) :: s') p'
  | (Fst :: p'), (I.VPair (v1,_) :: s') ->
      eval env (v1 :: s') p'
  | (Snd :: p'), (I.VPair (_,v2) :: s') ->
      eval env (v2 :: s') p'
  | (PushUnit :: p'), s' ->
      eval env (I.VUnit :: s') p'
  | (IsPair :: p'), (VPair _ :: s') ->
      eval env (VBool true :: s') p'
  | (IsPair :: p'), (_ :: s') ->
      eval env (VBool false :: s') p'
  | (Store :: p'), (v :: s') ->
      eval (v :: env) s' p'
  | (Load n :: p'), _ ->
      eval env (List.nth env n :: s) p'
  | (CleanUp :: p'), _ ->
      eval (List.tl env) s p'
  | (PushVar x :: p'), _ ->
      let value = List.assoc x env in
      eval env (value :: s) p'

(* Kompilacja RPN do podzbioru C *)

let lbl_cntr = ref 0 (* bleee!! *)

let fresh_lbl () =
  incr lbl_cntr;
  "lbl" ^ string_of_int !lbl_cntr

let emit_bop (op : Ast.bop) : string =
  Ast.(match op with
  | Add  -> "+"
  | Sub  -> "-"
  | Mult -> "*"
  | Div  -> "/"
  | And  -> "&&"
  | Or   -> "||"
  | Eq   -> "=="
  | Neq  -> "!="
  | Gt   -> ">"
  | Lt   -> "<"
  | Geq  -> ">="
  | Leq  -> "<=")

let emit_bop_res_tag (op : Ast.bop) : string =
  Ast.(match op with
  | Add | Sub | Mult | Div -> "INT"
  | _ -> "BOOL")

let emit_line (s : string) : string =
  "  " ^ s ^ ";\n"

let emit_lbl (s : string) : string =
  " " ^ s ^ ":\n"

(** allocate list of values, pop n elems from the stack*)
let alloc_pop (ss : string list) (to_pop : int) : string =
  (ss
   |> List.mapi (fun i s ->
        emit_line ("heap[heap_ptr+" ^ string_of_int i ^ "] = " ^ s))
   |> String.concat "") ^
  emit_line ("heap_ptr += " ^ string_of_int (List.length ss)) ^
  emit_line ("stack_ptr += " ^ string_of_int (1 - to_pop)) ^
  emit_line ("stack[stack_ptr] = heap_ptr - " ^ string_of_int (List.length ss - 1))

let show_cmd (c : cmd) : string =
  match c with
  | PushInt n -> emit_line ("// PushInt " ^ string_of_int n)
  | PushBool b -> emit_line ("// PushBool " ^ (if b then "true" else "false"))
  | Binop _op -> emit_line "// Binop"
  | PushPair -> emit_line "// PushPair"
  | CndJmp _ -> emit_line "// CndJmp"
  | Fst -> emit_line "// Fst"
  | Snd -> emit_line "// Snd"
  | PushUnit -> emit_line "// PushUnit"
  | IsPair -> emit_line "// IsPair"
  | Load n -> emit_line ("// Load " ^ string_of_int n)
  | Store -> emit_line "// Store"
  | CleanUp -> emit_line "// CleanUp"

let rec emit_cmd (c : cmd) : string =
  show_cmd c ^
  match c with
  | PushInt n ->
      alloc_pop ["INT"; string_of_int n] 0
  | PushBool n ->
      alloc_pop ["BOOL"; if n then "1" else "0"] 0
  | PushPair ->
      alloc_pop ["PAIR"; "stack[stack_ptr-1]"; "stack[stack_ptr]"] 2
  | PushUnit ->
      alloc_pop ["UNIT"] 0
  | Fst ->
      emit_line "stack[stack_ptr] = heap[stack[stack_ptr]]"
  | Snd ->
      emit_line "stack[stack_ptr] = heap[stack[stack_ptr]+1]"
  | IsPair ->
      alloc_pop ["BOOL"; "heap[stack[stack_ptr] - 1] == PAIR"] 1
  | Binop op ->
      alloc_pop
        [emit_bop_res_tag op;
         ("heap[stack[stack_ptr-1]] " ^ emit_bop op ^ " heap[stack[stack_ptr]]")]
        2
  | CndJmp (t, e) ->
      let lbl_t = fresh_lbl () in
      let lbl_end = fresh_lbl () in
      emit_line ("if (heap[stack[stack_ptr]]) goto " ^ lbl_t) ^
      emit_line "stack_ptr--" ^
      emit e ^
      emit_line ("goto " ^ lbl_end) ^
      emit_lbl lbl_t ^
      emit_line "stack_ptr--" ^
      emit t ^
      emit_lbl lbl_end
  | Load n ->
      emit_line "stack_ptr++" ^
      emit_line ("stack[stack_ptr] = env[env_ptr-" ^ string_of_int n ^ "]")
  | Store ->
      emit_line "env_ptr++" ^
      emit_line "env[env_ptr] = stack[stack_ptr]" ^
      emit_line "stack_ptr--"
  | CleanUp ->
      emit_line "env_ptr--"
  | PushVar x ->
    emit_line ("stack[stack_ptr++] = env[" ^ x ^ "]")


and emit (p : prog) : string =
  List.fold_left (fun res cmd -> res ^ emit_cmd cmd) "" p

let compile (s : string) : string =
  s
  |> Interp.parse
  |> of_ast []
  |> emit
  |> Runtime.with_runtime
