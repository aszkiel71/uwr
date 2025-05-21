{
open Parser
}

let white = [' ' '\t' '\n']+
let digit = ['0'-'9']
let number = '-'? digit+
let char = ['a'-'z' 'A'-'Z' '_']
let ident = char(char|digit)*

rule read =
    parse
    | '\n'  { Lexing.new_line lexbuf; read lexbuf }
    | white { read lexbuf }
    | "*" { TIMES }
    | "+" { PLUS }
    | "-" { MINUS }
    | "/" { DIV }
    | "&&" { AND }
    | "||" { OR }
    | "=" { EQ }
    | "<>" { NEQ }
    | "<=" { LEQ }
    | "<" { LT }
    | ">" { EQ }
    | ">=" { GEQ }
    | "(" { LPAREN }
    | ")" { RPAREN }
    | "->" { ARR }
    | ":" { COLON }
    | "if" { IF }
    | "then" { THEN }
    | "let" { LET }
    | "in" { IN }
    | "else" { ELSE }
    | "true" { BOOL true }
    | "false" { BOOL false }
    | "int" { KW_INT }
    | "bool" { KW_BOOL }
    | "unit" { KW_UNIT }
    | "," { COMMA }
    | "()" { UNIT }
    | "fst" { FST }
    | "snd" { SND }
    | "fun" { FUN }
    | "funrec" { FUNREC  }
    | number { INT ( int_of_string (Lexing.lexeme lexbuf)) }
    | ident { IDENT (Lexing.lexeme lexbuf) }
    | eof { EOF }
