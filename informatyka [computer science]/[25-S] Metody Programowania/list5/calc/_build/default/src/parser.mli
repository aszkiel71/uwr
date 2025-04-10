
(* The type of tokens. *)

type token = 
  | TIMES
  | RPAREN
  | POW
  | PLUS
  | MINUS
  | LPAREN
  | LOG
  | INT of (int)
  | FLOAT of (float)
  | EOF
  | E
  | DIV

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.expr)
