module type QUEUE = sig
  type 'a queue
  val empty : 'a queue
  val push : 'a -> 'a queue -> 'a queue
  val peek : 'a queue -> 'a
  val pop : 'a queue -> 'a queue
end

module Queue : QUEUE = struct
  type 'a queue = Queue of 'a list * 'a list

  let empty = Queue ([], [])

  let mk_queue xs ys =
    match xs with
    | [] -> Queue (List.rev ys, [])
    | _ -> Queue (xs, ys)

  let push x (Queue (xs, ys)) = mk_queue xs (x :: ys)

  let peek (Queue (xs, ys)) =
    match xs with
    | [] -> failwith "peek on empty queue"
    | x :: _ -> x

  let pop (Queue (xs, ys)) =
    match xs with
    | [] -> failwith "pop on empty queue"
    | _ :: xs' -> mk_queue xs' ys
end

module Stack : QUEUE = struct
  type 'a queue = 'a list
  let empty = []
  let push x st = x :: st
  let peek st =
    match st with
    | [] -> failwith "peek on empty stack"
    | x :: _ -> x
  let pop st =
    match st with
    | [] -> failwith "peek on empty stack"
    | _ :: st' -> st'
  end

type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree

let ex_tree = Node (Node (Node (Leaf, 4, Leaf), 2, Leaf), 
  1, 
  Node (Node (Leaf, 5, Leaf), 3, Node (Node (Leaf, 7, Leaf), 6, Leaf)))

module Search (M : QUEUE) = struct
  let search t =
  let rec f q xs =
    if q = M.empty
    then List.rev xs
    else match M.peek q with
    | Leaf -> f (M.pop q) xs
    | Node (l, v, r) -> f (q |> M.pop |> M.push l |> M.push r) (v :: xs)
  in f (M.push t M.empty) []
end

module Bfs = Search (Queue)
module Dfs = Search (Stack)

let search (module M : QUEUE) t =
  let rec f q xs =
    if q = M.empty
    then List.rev xs
    else match M.peek q with
    | Leaf -> f (M.pop q) xs
    | Node (l, v, r) -> f (q |> M.pop |> M.push l |> M.push r) (v :: xs)
  in f (M.push t M.empty) []

let bfs t = search (module Queue) t
let dfs t = search (module Stack) t
