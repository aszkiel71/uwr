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
    | ">" { GT }
    | ">=" { GEQ }
    | "(" { LPAREN }
    | ")" { RPAREN }
    | "->" { ARR }
    | "if" { IF }
    | "then" { THEN }
    | "let" { LET }
    | "in" { IN }
    | "else" { ELSE }
    | "true" { BOOL true }
    | "false" { BOOL false }
    | "," { COMMA }
    | "()" { UNIT }
    | "fst" { FST }
    | "snd" { SND }
    | "match" { MATCH }
    | "with" { WITH }
    | "pair?" { ISPAIR }
    | "fun" { FUN }
    | "funrec" { FUNREC  }
    | number { INT ( int_of_string (Lexing.lexeme lexbuf)) }
    | ident { IDENT (Lexing.lexeme lexbuf) }
    | eof { EOF }
