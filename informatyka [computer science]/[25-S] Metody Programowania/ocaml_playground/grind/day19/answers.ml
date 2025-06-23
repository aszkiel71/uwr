(*task1*)

(* a) *)
type 'a option = None | Some of 'a
let return x = Some x
let bind m f = match m with
            | Some v -> f v
            | None -> None

(* b) *)
type 'a list
let return x = [x]
let bind m f = List.concat (List.map f m)


(* c) *)
type ('a, 'e) result = Ok of 'a | Error of 'e
let return x = Ok x (* x : 'a *)
let bind m f = match m with | Ok m -> f m | Error e -> Error e


(* d) *)
type 'a writer = 'a * string
let return x = (x, "")
let bind m f = match m with | (a, s) -> (match f a with
                                        (a1, s1) -> (a1, s ^ s1))


(* e) *)
type ('s, 'a) state = 's -> ('a * 's)
let return x = fun s -> (x, s)
let bind m f = fun s -> let(v, s2) = m s in (f v) s2


(* f) *)
type ('e, 'a) reader = 'e -> 'a
let return x = fun _ -> x
let bind m f -> fun ee -> let val_a = m ee in let reader_b = f val_a in reader_b ee


(* g) *)
type 'a io = unit -> 'a
let return x = fun () -> x
let bind m f = fun () -> let a = m () in (f a) ()

(* h) *)
type ('a, 'r) cont = ('a -> 'r) -> 'r
let return x = fun g -> g x
let bind m f = fun g -> m (fun a -> let cont_b = f a in cont_b g)

(* i) *)
type 'a pair = 'a * 'a
let return x = (x, x)
let bind m f = match m with (a1, a2) -> (match (f a1, f a2) with ((b1, b2), (b3, b4)) -> (b1, b3))

(* j) *)
type 'a tree = Leaf of 'a | Node of 'a tree * 'a tree
let return x = Leaf x
let rec bind m f = match m with
            | Leaf a -> f a
            | Node(a1, a2) -> Node(bind a1 f, bind a2 f)

(* k) *)
type 'a lazy_m = unit -> 'a
let return x = fun _ -> x
let bind m f = fun () -> let a = m () in (f a) ()


(* l) *)
type 'a identity = 'a
let return x = x
let bind m f = f m
m : 'a
f : 'a -> 'b


(* m) *)
type 'a writer_int = 'a * int list
let return x = (x, [])
let bind m f = match m with (a1, lst) -> (match (f a1) with | (b, lst2) ) -> (b, lst1 @ lst2)
m : 'a * int list
f : 'a -> ('b * int list)


(* n) *)
type ('a, 'e) validation = Valid of 'a | Invalid of 'e list
let return x = Valid x
let bind m f = match m with | Valid a -> f a | Invalid e -> Invalid e


(* o) *)
type 'a parser = string -> ('a * string) option
let return x = fun str -> Some (x, str)
let bind m f = fun str -> match (m str) with | Some (a1, str2) -> (
                                            match (f a) str2 with
                                            | Some(b, str3) -> Some(b, str3)
                                            | None -> None
                                            )
                                             | None -> None
m : string -> ('a * string) option
f : 'a -> (string -> ('b * string) option)


(* p) *)
type 'a future = Pending | Resolved of 'a | Failed of string
let return x = Resolved x
let bind m f = match m with
            | Pending -> Pending
            | Resolved a -> f a
            | Failed str -> Failed str

m : 'a future
f : 'a -> ('b future)

(* q) *)
type 'a nelist = 'a * 'a list
let return x = (x, [])
let bind m f = match m with (a, lst1) -> (match f a with (b, lst2) -> (b, lst2)) (*lst1, lst2 rozne typy, wiec nie mozna ich polaczyc*)

m : 'a nelist
f : 'a -> ('b nelist)

(* r) *)
type 'a rose = Rose of 'a * 'a rose list
let return x = Rose(x, [])
let bind m f = match m with (a, lst1) -> f a  (*lst1 i lst2 powstala z (f a) maja rozne typy, nie ma jak ich placzyc*)
m : 'a rose
f : 'a -> ('b rose)

(* s) *)
type 'a zipper = 'a list * 'a * 'a list
let return x = ([], x, [])
let bind m f = match m with (l, a, r) -> f a (*znowu, taka sama historia, nie mozna polaczyc l, r z nowymi l', 'r bo rozne typy ('a list, 'b list)*)
m: 'a zipper
f : 'a -> 'b zipper

(* t) *)
type 'a dist = ('a * float) list
let return x = [(x, 1.0)]
let rec bind m f = match m with lst -> (match lst with [] -> [] | x :: xs -> (match x with (a, fl) -> f a) @ bind xs f)
m : 'a dist
f : 'a -> 'b dist


(*task2*)

type expr =
    | Int of int
    | Bool of bool
    | Var of string
    | Add of expr * expr
    | Sub of expr * expr
    | Mul of expr * expr
    | Eq of expr * expr
    | Lt of expr * expr
    | If of expr * expr * expr
    | Fun of string * expr
    | App of expr * expr
    | Let of string * expr * expr
    | LetRec of string * expr * expr

type value =
    | VInt of int
    | VBool of bool
    | VClosure of string * expr * env
    | VRecClosure of string * string * expr * env
and env = (string * value) list

let rec lookup_env env k =
    match env with
    | (ky, v) :: rest -> if ky = k then v else (lookup_env rest k)
    | [] -> failwith "not found"

let rec eval (env : env) (e : expr) : value =
    match e with
    | Int i -> VInt i
    | Bool b -> VBool b
    | Var  s -> lookup_env env s
    | Add(e1, e2) -> (match eval env e1, eval env e2 with
                        | VInt x, VInt y -> VInt (x + y)
                        | _ -> failwith "expected 2 ints")
    | Sub(e1, e2) -> (match eval env e1, eval env e2 with
                        | VInt x, VInt y -> VInt (x - y)
                        | _ -> failwith "expected 2 ints")
    | Mul(e1, e2) -> (match eval env e1, eval env e2 with
                        | VInt x, VInt y -> VInt (x * y)
                        | _ -> failwith "expected 2 ints")
    | Eq(e1, e2) -> (match eval env e1, eval env e2 with
                        | VInt x, VInt y -> VBool (x = y)
                        | VBool x, VBool y -> VBool (x = y)
                        | _ -> failwith "expected 2 ints")
    | Lt(e1, e2) -> (match eval env e1, eval env e2 with
                        | VInt x, VInt y -> VBool (x < y)
                        | VBool x, VBool y -> VBool (x < y)
                        | _ -> failwith "expected 2 ints")
    | If(cond, e1, e2) -> (match eval env cond with
                        | VBool true -> (eval env e1)
                        | VBool false -> (eval env e2)
                        | _ -> failwith "exepcted bool")
    | App(e1, e2) ->
        let v1 = eval e1 env in
        let v2 = eval e2 env in
        (match v1 with
         | VClosure(x, _, body, closure_env) ->
             let new_env = extend_env x v2 closure_env in
             eval body new_env
         | _ -> raise (RuntimeError "App requires function"))
    | Fun(str, e) -> VClosure (str, e, env)
    | Let(str, e1, e2) -> let val1 = eval env e1 in (eval ((str, val1) :: env) e2)
    | LetRec(f, e1, e2) ->
        (match e1 with
         | Fun(x, body) ->
             let rec_val = VRecClosure(f, x, body, env) in
             eval ((f, rec_val) :: env) e2
         | _ -> failwith "LetRec requires function")

(*task3*)

type expr =
    | Const of int
    | Var of string
    | Add of expr * expr
    | Sub of expr * expr
    | Mul of expr * expr
    | Let of string * expr * expr
    | If of expr * expr * expr

type instr =
    | IPushConst of int
    | IPushVar of string
    | IAdd
    | ISub
    | IMul
    | IStore of string
    | IPop of string
    | IJumpIfFalse of int
    | IJump of int

let rec compile (e : expr) : instr list =
    | Const i -> [IPushConst i]
    | Var s -> [IPushVar s]
    | Add(e1, e2) -> (compile e1) @ (compile e2) @ [IAdd]
    | Sub(e1, e2) -> (compile e1) @ (compile e2) @ [ISub]
    | Mul(e1, e2) -> (compile e1) @ (compile e2) @ [IMul]
    | Let(str, e1, e2) -> (compile e1) @ [IStore str] @ (compile e2) @ [IPop str]
    | If(cond, e1, e2) -> (match (compile cond) with
                          | [IPushConst 0] -> (match (compile e2) with
                                    | [IPushConst x] -> [IJumpIfFalse x]
                                    | _ -> failwith "expected int"
                                    )
                          | [IPushConst x] -> (match (compile e1) with
                                    | [IPushConst x] -> [IJump x]
                                    | _ -> failwith "expected int"
                                    )
                          | _ -> compile e1 )


(*task4*)

type typ =
    | TInt | TBool
    | TFun of typ * typ
    | TPair of typ * typ

type expr =
    | EInt of int
    | EBool of bool
    | EVar of string
    | EAdd of expr * expr
    | EMul of expr * expr
    | EEq of expr * expr
    | EIf of expr * expr * expr
    | EFun of string * typ * expr
    | EApp of expr * expr
    | ELet of string * expr * expr
    | EPair of expr * expr
    | EFst of expr
    | ESnd of expr

type tenv = (string * typ) list
let rec type_check (env : tenv) (e : expr) : typ =
    match e with
    | EInt _ -> TInt
    | EBool _ -> TBool
    | EVar s -> lookup_env env s
    | EAdd(e1, e2) -> (match type_check env e1, type_check env e2 with
                        (t1, t2) -> if (t1 = t2) then if t1 = TInt then TInt else failwith "must be Int" else failwith "must have got same type"
                       )
    | EMul(e1, e2) -> (match type_check env e1, type_check env e2 with
                        (t1, t2) -> if (t1 = t2) then if t1 = TInt then TInt else failwith "must be Int" else failwith "must have got same type"
                       )
    | EEq(e1, e2) -> (match type_check env e1, type_check env e2 with
                        (t1, t2) -> if (t1 = t2) then TBool else failwith "must have got same type"
                       )
    | EIf(e, e1, e2) -> (match type_check env e with
                        | TBool -> (match type_check env e1, type_check env e2 with
                                    (t1, t2) -> if t1 = t2 then t1 else failwith "type error")
                        | _ -> failwith "if condition must be bool")
    | EFun(str, typ, e2) -> (let t2 = type_check ((str, typ) :: env) e2 in TFun(typ, t2))
    | EApp(e1, e2) -> (match type_check env e1 with TFun(t1, t2) ->
                       if (type_check env e2) = t1 then t2 else failwith "type does not match")
    | ELet(str, e1, e2) -> let t1 = (type_check env e1) in type_check ((str, t1) :: env) e2
    | EPair(e1, e2) -> TPair (type_check env e1, type_check env e2)
    | EFst(e) -> ( match type_check env e with
        TPair(t1, _) -> t1 | _ -> failwith "expected pair" )
    | ESnd(e) -> ( match type_check env e with
        TPair(_, t2) -> t2 | _ -> failwith "expected pair" )
