{
open Parser
}

let white = [' ' '\t']+
let digit = ['0'-'9']
let number = '-'? digit+ 

let float = '-'? digit+ '.' digit+  (* - - - *)

rule read =
    parse
    | white { read lexbuf }
    | "log" { LOG }  (*task6*)
    | "**" { POW } (*task6*)
    | "*" { TIMES }
    | "+" { PLUS }
    | "-" { MINUS }
    | "/" { DIV }
    | "(" { LPAREN }
    | ")" { RPAREN }
    | "e" { E } (*task6*)
    | number { INT (int_of_string (Lexing.lexeme lexbuf)) }
    | float { FLOAT (float_of_string (Lexing.lexeme lexbuf)) }  (* - - - *)
    | eof { EOF }
