{
open Parser
}

let white = [' ' '\t']+
let digit = ['0'-'9']
let number = '-'? digit+

rule read =
    parse
    | white { read lexbuf }
    | "*" { TIMES }
    | "+" { PLUS }
    | "-" { MINUS }
    | "/" { DIV }
    | "(" { LPAREN }
    | ")" { RPAREN }
    | number { INT ( int_of_string (Lexing.lexeme lexbuf)) }
    | eof { EOF }
