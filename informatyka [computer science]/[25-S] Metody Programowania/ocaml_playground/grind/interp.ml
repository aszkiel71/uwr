type expr =
    | Int of int | Bool of bool | Var of string
    | Add of expr * expr | If of expr * expr * expr
    | Let of string * expr * expr | Fun of string * typ * expr
    | FunRec of string * string * typ * typ * expr
    | Ref of expr | Deref of expr | Assign of expr * expr
    | Pair of expr * expr | Fst of expr | Snd of expr
    | TryCatch of expr * expr | Fix of expr
    | App of expr * expr
and typ =
    | TInt | TBool | TRef of typ | TPair of typ * typ
    | TLambda of typ * typ | TUnit

type value =
    | VInt of int | VBool of bool | VRef of value
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
    | Ref (e) -> let (v, s) = eval e env stk in let loc = fresh_loc () in (VRef loc, (loc, v) :: stk)
    | Deref (e) -> let (v, s) = eval e env stk in (match v with
                                                | VRef a -> (lookup_env a s, s)
                                                | _ -> failwith "expected reference"
                                                )
    | Assign(e1, e2) -> let (v1, s1) = eval e1 env stk in
                        let (v2, s2) = eval e2 env s1 in
                        (
                        match v1 with
                            | VRef a -> (VUnit, (a, v2) :: (List.remove_assoc a s2))
                            | _ -> failwith "expected reference"
                        )
    | App(e1, e2) -> let (v1, s1) = eval e1 env stk in
                     let (v2, s2) = eval e2 env s1 in
                     (
                     match v1 with
                     | VClosure(s, body, _, venv) -> eval body ( (s, v2) :: venv) s2
                     | VRecClosure(f, x, body, _, _, venv) -> eval body ( (f, v1) :: (x, v2) :: venv) s2
                     | _ -> failwith "expected function"
                     )
    | TryCatch(e1, e2) -> (try eval e1 env stk with _ -> eval e2 env stk)
    | Fix(e) ->
        let (v, s1) = eval e env stk in
        (match v with
        | VClosure(x, body, venv) ->
            let rec fix = VClosure(x, body, (x, fix) :: venv) in
            eval body ((x, fix) :: venv) s1
        | _ -> failwith "expected function in fix")
    | Pair(e1, e2) -> let (v1, s1) = eval e1 env stk in let (v2, s2) = eval e2 env s1 in (VPair(v1, v2), s2)
    | Fst(e) -> let (v1, s1) = eval e env stk in (match e with
                                                  | VPair(a, _) -> (a, s1)
                                                  | _ -> failwith "expected pair")
    | Snd(e) -> let (v1, s1) = eval e env stk in (match e with
                                                  | VPair(_, b) -> (b, s1)
                                                  | _ -> failwith "expected pair")


let rec type_checker e tenv stk =
    let check exp t = if (type_checker exp tenv stk) = t then () else failwith "type error" in
    match e with
    | Int _ -> TInt | Bool _ -> TBool
    | Var s -> lookup_env s tenv
    | Add(e1, e2) -> let t = type_checker e1 tenv stk in check e2 t; TInt
    | If(cond, e1, e2) -> check cond TBool; let t = type_checker e1 tenv stk in check e2 t; t
    | Let(s, e1, e2) -> let t = type_checker e1 tenv stk in type_checker e2 ((s , t) :: tenv) stk
    | Fun(s, t, e) -> let t1 = type_checker e ((s, t) :: tenv) stk in TLambda(t, t1)
    | FunRec(f, x, t1, t2, e) -> TLambda(t1, t2)
    | Ref (e) -> let t = type_checker e tenv stk in (TRef t)
    | Deref (e) -> let t = type_checker e tenv stk in (
                    match t with
                    | TRef t1 -> t1
                    | _ -> failwith "expected reference"
                    )
    | Assign(e1, e2) -> let t1 = type_checker e1 tenv stk in (match t1 with | TRef t -> check e2 t; TUnit | _ -> failwith "expected ref")
    | Pair(e1, e2) -> TPair(type_checker e1 tenv stk, type_checker e2 tenv stk)
    | Fst(e) -> (match type_checker e tenv stk with
                | TPair(t1, _) -> t1
                | _ -> failwith "expected pair")
    | Snd(e) -> (match type_checker e tenv stk with
                | TPair(_, t2) -> t2
                | _ -> failwith "expected pair")
    | App(e1, e2) -> (match type_checker e1 tenv stk in
                      | TLambda(t1, t2) -> check e2 t2; t2
                      | _ -> failwith "expected function")
    | TryCatch(e1, e2) -> let t = type_checker e1 tenv stk in check e2 t; t
    | Fix(e) -> (match type_checker e tenv stk in
                 | TLambda(t1, t2) -> if t1 = t2 then t1 else failwith "type error"
                 | _ -> failwith "type error")