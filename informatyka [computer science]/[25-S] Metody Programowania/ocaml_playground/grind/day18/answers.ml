(*task1*)

let f = fun x -> x + y in (*y -> wolne, x -> zwiaane przez fun x*)
let g h = h (f z) (*z -> wolne, f -> zwiazane przez let f, h -> zwiazane przez let g h*)
in g f (*f -> zwiazane przez let f, g -> zwiazane przez let g h*)

fun x ->
    let y = fun z -> x + z in (*z -> zwiazane przez fun z, x -> zwiazane przez fun x*)
    let x = 5 in
    y x (*x -> zwiazany przez let x = 5, y -> zwiazane przez let y*)

(*task2*)
fun x y -> if x = y then x else y (*typ: 'a -> 'a -> 'a *)
fun f x -> let y = f x in (y, y) (*typ: ('a -> 'b) -> 'a -> ('b * 'b) *)
fun x -> (x 1, x true, x "hello") (*typ: type error*)
let rec fix f x = f (fix f) x in fix (*typ: (('a -> 'b) -> 'a -> 'b) -> 'a -> 'b *)
fun (x :: xs) -> x + List.length xs (* int list -> int *)

(*task3*)
fun x y -> y
fun f g x -> g (f x)
fun lst p -> match lst with | [] -> [] | x :: xs -> if (p x) then xs else [x]
fun p f g -> match p with | (p1, p2) -> (f p1, g p2)

(*task4*)
let find_index p lst = fst ((List.fold_left (
                                       fun (acc, (found, idx)) x -> if (p x) && (found = false) then
                                       match acc with
                                       | None -> (Some idx, (true, idx))
                                       | Some y -> (Some idx, (true, idx))
                                       else (acc , (found , (idx+1)))
                                       )
                                       )
                                       (None, (false, 0))
                                       lst
                                       )

let unzip lst = List.fold_right (fun x acc -> match x, acc with
                                (p1, p2), (lst1, lst2) -> (p1 :: lst1, p2 :: lst2))
                                lst
                                ([], [])

let count_if p lst = List.fold_left (fun acc x -> if p x then (acc+1) else acc)
                     0 lst


(*task5*)
type ('a, 'e) result = Ok of 'a | Error of 'e
let return x = Ok x
let bind m f = Ok (f m)

type ('r, 'a) reader = 'r -> 'a
let return x = fun a -> (x, a)
let bind m f = fun a -> (f m, a)

type ('a, 'r) cont = ('a -> 'r) -> 'r
let return x = fun f -> (x, f x)
let bind m f = fun z -> (f m, z (f m))


(*task6*)
type 'a nelist = Cons of 'a * 'a nelist | Single of 'a
(*zasada indukcji:
Jesli predykat p spełnia:
    | p(Single a) : dla dowolnego a
    | p(a) ^ p(nlst) => p(Const(a, nlst)) : dla dow. (a : 'a), (nlst : 'a nelist)
Wtedy predykat p spelnia wszystkie 'a nelisty.
*)

(*task7*)
type typ =
    | TInt
    | TBool
    | TFun of typ * typ

type expr =
    | EInt of int
    | EBool of bool
    | EVar of string
    | EAdd of expr * expr
    | EEqual of expr * expr
    | EIf of expr * expr * expr
    | EFun of string * typ * expr
    | EApp of expr * expr
    | ELet of string * expr * expr

type tenv = (string * typ) list

let rec lookup_env k env =
    match env with
    | (ky, v) :: rest -> if ky = k then v else (lookup_env k rest)
    | [] -> failwith "not found"

let rec type_check (env : tenv) (e : expr) : typ =
    match e with
    | EInt _ -> TInt
    | EBool _ -> TBool
    | EVar s -> lookup_env s env
    | EAdd(e1, e2) -> (
        match type_check env e1, type_check env e2 with
        | TInt, TInt -> TInt
        | _ -> failwith "EAdd should got same type (EInt)" )
    | EEqual(e1, e2) -> (
            match type_check env e1, type_check env e2 with
            | TInt, TInt -> TBool
            | TBool, TBool -> TBool
            | TFun(t1, t2), TFun(t3, t4) ->
                if ((t1 = t3) && (t2 = t4)) then TBool
                else failwith "EEqual got different types" )
    | EIf(cond, e1, e2) ->
           (match type_check env cond with
            | TBool -> (match type_check env e1, type_check env e2 with
                | TInt, TInt -> TBool
                | TBool, TBool -> TBool
                | TFun (t1, t2), TFun(t3, t4) ->
                    if ((t1 = t3) & (t2 = t4)) then TBool
                    else failwith "type error"
                )
            | _ -> failwith "condition must be bool!")
    | EFun(str, t, e) ->
            (match t with
            | (t1, t2) ->
            (if (type_check env str, type_check env e) = (t1, t2) then t2
            else failwith "types not matched with given one"
            )
            | _ -> failwith "type error"
            )
    | EApp(e1, e2) -> (
            match type_check env e1 with
            | (t1, t2) -> if type_check env e2 = t2 then (t1, t2) else failwith "types dont match"
            | _ -> failwith "type error (Fun expected pair type)"
            )
    | ELet(str, e1, e2) ->
            match type_check env e1, type_check env e2 with
            | t1, t2 -> if t1 = t2 then t2 else failwith "type dont match"


type expr =
    | Num of int
    | Var of string
    | Add of expr * expr
    | Assign of string * expr
    | Seq of expr * expr
    | While of expr * expr
    | Print of expr

type store = (string * int) list

let rec lookup_env k env =
    match env with
    | (ky, v) :: rest -> if ky = k then v else (lookup_env k rest)
    | [] -> failwith "not found"

let rec eval (s : store) (e : expr) : (int * store) =
    match e with
    | Num i -> (i, s)
    | Var str -> (lookup_env s str, s)
    | Add(e1, e2) -> ((eval s e1) + (eval s e2), s)
    | Assign(str, e1) -> let new_e = eval s e1 in
                        (new_e, ((str, new_e):: s))
    | Seq(e1, e2) -> let new_s = snd (eval s e1) in eval new_s e2
    | While(e1, e2) -> (0, s)
    (*printa nie pisalem, bo nie ma sensu*)

(*task9*)
type expr =
    | Const of int
    | Var of int
    | BinOp of op * expr * expr
    | If of expr * expr * expr
and op = Add | Sub | Mul | Lt

type instr =
    | IPush of int
    | IVar of int
    | IOp of op
    | IJump of int
    | IJumpIfFalse of int

let rec compile (e : expr) : instr list =
    match e with
    | Const i -> [IPush i]
    | Var i -> [IVar i]
    | BinOp(op, e1, e2) -> (
    match op with
    | Add -> (compile e1) @ (compile e2) @ [IOp Add]
    | Sub -> (compile e1) @ (compile e2) @ [IOp Sub]
    | Mul -> (compile e1) @ (compile e2) @ [IOp Mul]
    | Lt -> (compile e1) @ (compile e2) @ [IOp Lt]
    )
    | If(e1, e2, e3) -> (match compile e1 with
            | [IPush 0]  -> (match compile e3 with
                        | [IPush x] -> [IJumpIfFalse x]
                        | _ -> failwith "expected number")
            | [IPush x] -> (match compile e2 with
                        | [IPush x] -> [IJump x]
                        | _ -> failwith "expected number"
                        )
            | _ -> failwith "expected number"
                        )

type value = VInt of int | VBool of bool
type state = {
    code : instr list;
    pc : int;
    stack : value list;
    vars : value list
}

let rec step (s : state) : state =
    match s.code with
    | [] -> s
    | (IPush i) :: rest -> step ({code = rest; pc = s.pc + 1; stack = ((VInt i) :: s.stack), vars = s.vars})
    | (IVar i) :: rest -> step ({code = rest; pc = s.pc + 1; stack = (); ...})
    |