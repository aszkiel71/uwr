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
%token OR
%token LEQ
%token LT
%token GEQ
%token GT
%token EQ
%token NEQ
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
%token ISPAIR
%token FUN
%token FUNREC

%start <Ast.expr> main

%left AND OR
%nonassoc EQ NEQ LEQ LT GT GEQ
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
    | FUN; x = IDENT; ARR; e = mexpr
        { Fun(x, e) }
    | FUNREC; f = IDENT; x = IDENT; ARR; e = mexpr
        { Funrec(f, x, e) }
    | e = expr
        { e }
    ;

expr:
    | e1 = expr; PLUS; e2 = expr { Binop(Add, e1, e2) }
    | e1 = expr; MINUS; e2 = expr { Binop(Sub, e1, e2) }
    | e1 = expr; DIV; e2 = expr { Binop(Div, e1, e2) }
    | e1 = expr; TIMES; e2 = expr { Binop(Mult, e1, e2) }
    | e1 = expr; AND; e2 = expr { Binop(And, e1, e2) }
    | e1 = expr; OR; e2 = expr { Binop(Or, e1, e2) }
    | e1 = expr; EQ; e2 = expr { Binop(Eq, e1, e2) }
    | e1 = expr; NEQ; e2 = expr { Binop(Neq, e1, e2) }
    | e1 = expr; LEQ; e2 = expr { Binop(Leq, e1, e2) }
    | e1 = expr; LT; e2 = expr { Binop(Lt, e1, e2) }
    | e1 = expr; GT; e2 = expr { Binop(Gt, e1, e2) }
    | e1 = expr; GEQ; e2 = expr { Binop(Geq, e1, e2) }
    | e = app_expr { e }

app_expr:
    | ISPAIR; e1 = base_expr { IsPair e1 }
    | FST; e = base_expr { Fst e }
    | SND; e = base_expr { Snd e }
    | e1 = app_expr; e2 = base_expr { App (e1, e2) }
    | e = base_expr { e }
    ;

base_expr:
    | x = IDENT { Var x }
    | i = INT { Int i }
    | b = BOOL { Bool b }
    | UNIT { Unit }
    | LPAREN; e1 = mexpr; COMMA; e2 = mexpr; RPAREN { Pair (e1,e2) }
    | LPAREN; e = mexpr; RPAREN { e }
    ;
