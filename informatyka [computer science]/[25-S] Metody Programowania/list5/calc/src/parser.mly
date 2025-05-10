%token <int> INT
%token <float> FLOAT
%token LOG (*task6*)
%token PLUS
%token MINUS
%token TIMES
%token DIV
%token POW (*task6*)
%token LPAREN
%token RPAREN
%token EOF
%token E (*task6*)

%start <Ast.expr> main

%left PLUS MINUS
%left TIMES DIV
%right POW (*task6*)
%right LOG (*task6*)

%%

main:
    | e = expr; EOF { e }

expr:
    | i = INT { Float (float_of_int i) }  (* - - - *)
    | f = FLOAT { Float f }  (* - - - *)
    | e1 = expr; PLUS; e2 = expr { Binop(Add, e1, e2) }
    | e1 = expr; MINUS; e2 = expr { Binop(Sub, e1, e2) }
    | e1 = expr; DIV; e2 = expr { Binop(Div, e1, e2) }
    | e1 = expr; TIMES; e2 = expr { Binop(Mult, e1, e2) }
    | e1 = expr; POW; e2 = expr { Binop(Pow, e1, e2) } (*task6*)
    | E { Float (exp 1.0) } (*task6*)
    | LOG; e = expr { Log e } (*task6*)
    | LPAREN; e = expr; RPAREN { e }
