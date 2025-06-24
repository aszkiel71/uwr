type expr =
    | Int of int | Bool of bool | Var of string
    | Add of expr * expr | If of expr * expr * expr
    | Let of string * expr * expr | Fun of string * typ * expr
    | FunRec of string * string * typ * typ * expr
    | Ref of expr | Deref of expr | Assign of expr * expr
    | Pair of expr * expr | Fst of expr | Snd of expr
    | TryCatch of expr * expr | Fix of expr
    | App of expr * expr    | Match of expr * string * string * expr
and typ =
    | TInt | TBool | TRef of typ | TPair of typ * typ
    | TLambda of typ * typ | TUnit

type value =
    | VInt of int | VBool of bool | VRef of int
    | VClosure of string * expr * env   | VUnit
    | VRecClosure of string * string * expr * env
and env = (string * value) list

type tenv = (string * typ) list

let id = ref 0
let fresh_loc () = let l = !id in id := !id + 1; l

let rec lookup_env k env =
    match env with
    | (ky, v) :: rest -> if ky = k then v else lookup_env k rest
    | [] -> failwith "not found"

let rec eval e env stk =
    match e with
    | Int i -> (VInt i, stk)
    | Bool b -> (VBool b, stk)
    | Var s -> (lookup_env s env, stk)
    | Add(e1, e2) -> let (x, s1) = eval e1 env stk in
                     let (y, s2) = eval e2 env s1 in
                     (match x, y with
                     | VInt a, VInt b -> (VInt (a + b), s2)
                     | _ -> failwith "expected 2 ints."
                     )
    | If(cond, e1, e2) -> (match eval cond env stk with
                          | (VBool true, s) -> eval e1 env s
                          | (VBool false, s) -> eval e2 env s
                          | _ -> failwith "condition must be bool"
                          )
    | Let(str, e1, e2) -> let (v1, s) = eval e1 env stk in eval e2 ((str, v1) :: env) s
    | Fun(s, _, e) -> (VClosure(s, e, env) , stk)
    | FunRec(f, x, _, _, e) -> (VRecClosure(f, x, e, env) , stk)
    | Ref (e) -> let (v1, s1) = eval e env stk in let loc = fresh_loc () in (VRef loc , (loc, v1) :: env)
    | Deref(e) -> (match eval e env with
                   | VRef(a) -> (lookup_env a stk , stk)
                   | _ -> failwith "expected reference")
    | Assign(e1, e2) -> let (v1, s1) = eval e1 env stk in let (v2, s2) = eval e2 env stk in
                    (match v1 with
                    | VRef a -> (VUnit, (a, v2) :: (List.assoc_remove a stk))
                    | failwith "expected reference")
    | App(e1, e2) -> let (v1, s1) = eval e1 env stk in let (v2, s2) = eval e2 env s1 in
                    (
                    match v1 with
                    | VClosure(f, body, venv) -> eval body ( (f, v2) :: venv ) stk
                    | VRecClosure(f, x, body, venv) -> eval body ( (f, v1) :: (x, v2) :: venv ) stk
                    | _ -> failwith "expected function")