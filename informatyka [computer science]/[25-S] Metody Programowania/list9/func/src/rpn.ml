(* Składnia RPN *)

type cmd =
  | PushInt of int
  | Binop   of Ast.bop

type prog = cmd list

(* Kompilacja do RPN *)

let rec of_ast (expr : Ast.expr) : prog =
  match expr with
  | Ast.Int n -> [PushInt n]
  | Ast.Binop (op, e1, e2) -> of_ast e1 @ of_ast e2 @ [Binop op]
  | _ -> failwith "not implemented"

(* Ewaluator dla RPN *)

let eval_op (op : Ast.bop) (val1 : int) (val2 : int) : int =
  match op, val1, val2 with
  | Add,  v1, v2 -> v1 + v2
  | Sub,  v1, v2 -> v1 - v2
  | Mult, v1, v2 -> v1 * v2
  | Div,  v1, v2 -> v1 / v2
  | _, _, _ -> failwith ""

(* ewaluator nie jest elementem procesu kompilacji, ale
 * przydaje się do testowania i debugowania
 *)
let rec eval (s : int list) (p : prog) : int =
  match p, s with
  | [], [n] -> n
  | [], _   -> failwith "error!"
  | (PushInt n :: p'), _ -> eval (n :: s) p'
  | (Binop op :: p'), (v2 :: v1 :: s') ->
      eval (eval_op op v1 v2 :: s') p'
  | _ -> failwith "error!!"

(* Kompilacja RPN do podzbioru C *)

(* Runtime:
 * - Stos to tablica int-ów.
 * - Wskaźnik stosu pokazuje na pierwszy element (inaczej
 *   niż na wykładzie).
 *)

let with_runtime p =
  Printf.sprintf
  {|
#include <stdio.h>

int stack[10000];
int stack_ptr = -1;

int main()
{
%s
  printf("%%d\n", stack[0]);
  return 0;
}
  |}
  p

(* Przdałaby się jeszcze jedna warstwa abstrakcji,
 * żeby ograniczyć takie majtanie stringami, które
 * na dłuższą metę jest nie do utrzymania.
 *)

let emit_bop (op : Ast.bop) : string =
  Ast.(match op with
  | Add  -> "+"
  | Sub  -> "-"
  | Mult -> "*"
  | Div  -> "/"
  | _ -> failwith "not implemented")

let emit_line (s : string) : string =
  "  " ^ s ^ ";\n"

let emit_cmd (c : cmd) : string =
  match c with
  | PushInt n ->
      emit_line "stack_ptr++" ^
      emit_line ("stack[stack_ptr] = " ^ string_of_int n)
  | Binop op ->
      emit_line "stack_ptr--" ^
      emit_line ("stack[stack_ptr] = stack[stack_ptr] " ^ emit_bop op ^ " stack[stack_ptr+1]")

let emit (p : prog) : string =
  List.fold_left (fun res cmd -> res ^ emit_cmd cmd) "" p

let compile (s : string) : string =
  s
  |> Interp.parse
  |> of_ast
  |> emit
  |> with_runtime
