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


%token COLON
%token FST
%token SND


%token MATCH
%token WITH
%token ARROW


%token SUM
%token TO

%token UNIT

%token DIV
%token AND
%token OR
%token EQ
%token LEQ
%token LPAREN
%token RPAREN
%token EOF

%start <Ast.expr> main

%left AND OR
%nonassoc EQ LEQ
%left PLUS MINUS
%left TIMES DIV

%%

main:
    | e = mexpr; EOF { e }
    ;

mexpr:
    | IF; e1 = mexpr; THEN; e2 = mexpr; ELSE; e3 = mexpr { If(e1,e2,e3) }
    | LET; x = IDENT; EQ; e1 = mexpr; IN; e2 = mexpr { Let(x,e1,e2) }
    | e1 = mexpr; COLON; e2 = mexpr;  {Pair(e1,e2)}
    | MATCH; e1 = mexpr; WITH; LPAREN; x1 = IDENT; COLON; x2=IDENT; RPAREN; ARROW; e2 = mexpr {Match(e1,x1,x2,e2)}
    | SUM; x = IDENT; EQ ; e1 = mexpr; TO;e2 = mexpr; IN; e3 = mexpr {Sum(x,e1,e2,e3)} 
    | e = expr { e }
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
    | UNIT {Unit ()}
    | FST; e1 = expr {Uop(Fst, e1)}
    | SND; e1 = expr {Uop(Snd, e1)}
    | LPAREN; e = mexpr; RPAREN { e }
    ;


