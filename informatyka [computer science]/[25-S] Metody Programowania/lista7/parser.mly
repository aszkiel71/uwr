%{
open Ast
%}

%token <bool> BOOL
%token <int> INT
%token <string> IDENT
%token IF
%token THEN
%token ELSE
%token LET
%token IN
%token PLUS
%token MINUS
%token TIMES
%token DIV
%token AND
%token FOLD
%token OR
%token EQ
%token LEQ
%token LPAREN
%token RPAREN
%token EOF
%token COMMA
%token UNIT
%token FST
%token SND
%token MATCH
%token WITH
%token ARR
%token LBRACK RBRACK SEMICOLON
%token ISNUMBERQM ISBOOLEANQM ISPAIRQM ISUNITQM
%start <Ast.expr> main
%left AND OR
%nonassoc EQ LEQ
%nonassoc LBRACK RBRACK
%left SEMICOLON
%left PLUS MINUS
%left TIMES DIV

%%

main:
    | e = mexpr; EOF { e }
    ;

mexpr:
    | IF; e1 = mexpr; THEN; e2 = mexpr; ELSE; e3 = mexpr
        { If(e1, e2, e3) }
    | LET; x = IDENT; EQ; e1 = mexpr; IN; e2 = mexpr
        { Let(x, e1, e2) }
    | MATCH; e1 = mexpr; WITH; LPAREN; x = IDENT; COMMA; y = IDENT; RPAREN; ARR; e2 = mexpr
        { Match(e1, x, y, e2) }
    | e = expr
        { e }
    ;

expr:
    | i = INT { Int i }
    | b = BOOL { Bool b }
    | x = IDENT { Var x }
    | e1 = expr; PLUS; e2 = expr { Binop(Add, e1, e2) }
    | e1 = expr; MINUS; e2 = expr { Binop(Sub, e1, e2) }
    | e1 = expr; DIV; e2 = expr { Binop(Div, e1, e2) }
    | e1 = expr; TIMES; e2 = expr { Binop(Mult, e1, e2) }
    | e1 = expr; AND; e2 = expr { Binop(And, e1, e2) }
    | e1 = expr; OR; e2 = expr { Binop(Or, e1, e2) }
    | e1 = expr; EQ; e2 = expr { Binop(Eq, e1, e2) }
    | e1 = expr; LEQ; e2 = expr { Binop(Leq, e1, e2) }
    | ISNUMBERQM; e = expr { IsNumber e }
    | ISBOOLEANQM; e = expr { IsBool e }
    | ISPAIRQM; e = expr { IsPair e }
    | ISUNITQM; e = expr { IsUnit e }
    | LPAREN; e1 = mexpr; COMMA; e2 = mexpr; RPAREN { Pair (e1,e2) }
    | UNIT { Unit }
    | FST; e = expr { Fst e }
    | SND; e = expr { Snd e }
    | LPAREN; e = mexpr; RPAREN { e }
    | LBRACK; RBRACK; { Unit }
    | LBRACK; elements = listexpr; RBRACK { elements }
    | FOLD; e1 = expr; WITH; LPAREN; x = IDENT; COMMA; acc = IDENT; RPAREN; ARR;
    e2 = expr; AND; e3 = expr { Fold(e1, x, acc, e2, e3) }
    ;

listexpr:
    | e = expr; SEMICOLON; rest = listexpr { Pair(e, rest) }
    | e = expr { Pair(e, Unit) }
    | { Unit }
