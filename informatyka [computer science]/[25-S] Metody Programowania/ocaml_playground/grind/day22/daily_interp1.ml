type expr =
    | Int of int | Bool of bool | Var of string | Let of string * expr * expr
    | Fun of string * typ * expr | FunRec of string * string * typ * typ * expr
    | Add of expr * expr | If of expr * expr * expr
    | Ref of expr | Deref of expr | Assign of expr * expr
    | Pair of expr * expr | Fst of expr | Snd of expr
    | App of expr * expr

type value =
    | VInt of int | VBool of bool | VUnit
    | VPair of value * value
    | VRef of int
    | VClosure of string * expr * env
    | VRecClosure of string * string * expr * env
and env = (string * value) list

let counter = ref 0
let fresh_loc () = let l = !counter in counter := !counter + 1; l

let rec lookup_env k env =
    match env with
    | (ky, v) :: rest -> if ky = k then v else lookup_env k rest
    | [] -> failwith "not found"

let rec eval e env stk =
    match e with
    | Int i -> (VInt i, stk)
    | Bool b -> (VBool b, stk)
    | Var s -> (lookup_env s env, stk)
    | Let(s, e1, e2) -> let (v1, stk) = eval e1 env stk in (eval e2 ((s, v1) :: rest) stk)
    | Fun(s, _,  e) -> (VClosure(s, e, env) , stk)
    | FunRec(f, x, _, _,  e) -> (VRecClosure (f, x, e, env), stk)
    | Add(e1, e2) -> (match eval e1 env stk, eval e2 env stk with
        | (VInt x, s1), (VInt y, s2) -> (VInt (x+y), s2)
        | _ -> failwith "expected 2 ints")
    | If(cond, e1, e2) -> (match eval cond env stk with
        | (VBool c, s1) -> (if c = true then eval e1 env stk else eval e2 env stk)
        | _ -> failwith "condition must be bool"
    )
    | Ref e -> let (v1, s1) = eval e env stk in
             let loc = fresh_loc () in
             (VRef loc, (loc, v1) :: s1)
    | Deref e -> let (v1, s1) = eval e env stk in
            (match v1 with
            | VRef i -> (lookup_env i s1, s1)
            | _ -> failwith "expected reference"
            )
    | Assign(e1, e2) -> let (v1, s1) = eval e1 env stk in
                        let (v2, s2) = eval e2 env stk in
                        (match v1 with
                        | VRef r -> let new_loc = (r, v2) :: (List.remove_assoc r s2) in
                        (VUnit, new_loc)
                        )
    | Pair(e1, e2) -> (VPair(eval e1 env stk, eval e2 env stk), stk)
    | Fst e -> (match eval e env stk with
                | (VPair(x, _), stk) -> (x, stk)
                | _ -> failwith "expected pair"
               )
    | Snd e -> (match eval e env stk with
                | (VPair(_, y), stk) -> (y, stk)
                | _ -> failwith "expected pair"
               )
    | App(e1, e2) -> let (v1, s1) = eval e1 env stk in
                     let (v2, s2) = eval e2 env stk in
                     (match v1 with
                     | VClosure(s, body, venv) -> eval body ((s, v2) :: venv) s2
                     | VRecClosure(f, x, body, venv) -> eval body ( (f, v1 ) :: (x, v2) :: venv) stk
                     )

type typ =
    | TInt | TBool | TFun of typ * typ | TUnit | TRef of typ

let rec type_checker e tenv stk =
    let check e t = if (type_checker e tenv stk) = t then () else failwith "type error" in
    match e with
    | Int _ -> TInt | Bool _ -> TBool
    | Var s -> lookup_env s tenv
    | Add(e1, e2) -> check e1 TInt; check e2 TInt; TInt
    | Let(s, e1, e2) -> let t = type_checker e1 tenv stk in type_checker e2 ((s, t) :: tenv) stk
    | Fun(s, t, e) -> TFun(t, type_checker e ((s, t) :: tenv) stk)
    | FunRec(s1, s2, t1, t2, e) -> TFun(t1, t2)
    | If(e1, e2, e3) -> check e1 TBool; let t = type_checker e2 tenv stk in check e3 t; t
    | Ref e -> TRef (type_checker e tenv stk)
    | Deref e -> (match type_checker e tenv stk with
                  | TRef a -> a
                  | _ -> failwith "expected reference")
    | Assign (e1, e2) ->
        (match type_checker e1 tenv stk with
        | TRef t -> check e2 t; VUnit
        | _ -> failwith "assign: left side must be reference")
