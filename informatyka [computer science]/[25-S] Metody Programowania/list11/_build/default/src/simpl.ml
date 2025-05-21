let binop_name (bop : RawAst.bop) =
  match bop with
  | Add  -> "add"
  | Sub  -> "sub"
  | Mult -> "mult"
  | Div  -> "div"
  | And  -> "and"
  | Or   -> "or"
  | Eq   -> "eq"
  | Neq  -> "neq"
  | Leq  -> "leq"
  | Lt   -> "lt"
  | Geq  -> "geq"
  | Gt   -> "gt"

let rec simplify (e : RawAst.expr) : Ast.expr =
  match e.data with
  | Unit   -> Unit
  | Int  n -> Int n
  | Bool b -> Bool b
  | Var  x -> Var x
  | Binop(bop, e1, e2) ->
      App(App(Builtin(binop_name bop), simplify e1),
        simplify e2)
  | If(b, e1, e2)  ->
      If(simplify b, simplify e1, simplify e2)
  | Let(x, e1, e2) ->
      Let(x, simplify e1, simplify e2)
  | Pair(e1, e2) ->
      Pair(simplify e1, simplify e2)
  | App(e1, e2) ->
      App(simplify e1, simplify e2)
  | Fst e ->
      App(Builtin "fst", simplify e)
  | Snd e ->
      App(Builtin "snd", simplify e)
  | Fun(x, _, e) ->
      Fun(x, simplify e)
  | Funrec(f, x, _, _, e) ->
      Funrec(f, x, simplify e)
