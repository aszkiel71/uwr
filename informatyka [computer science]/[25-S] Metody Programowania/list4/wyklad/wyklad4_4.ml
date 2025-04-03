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

let bfs t =
  let rec f q xs =
    if q = Queue.empty
    then List.rev xs
    else match Queue.peek q with
    | Leaf -> f (Queue.pop q) xs
    | Node (l, v, r) -> f (q |> Queue.pop |> Queue.push l |> Queue.push r) (v :: xs)
  in f (Queue.push t Queue.empty) []

let dfs t =
  let rec f q xs =
    if q = Stack.empty
    then List.rev xs
    else match Stack.peek q with
    | Leaf -> f (Stack.pop q) xs
    | Node (l, v, r) -> f (q |> Stack.pop |> Stack.push l |> Stack.push r) (v :: xs)
  in f (Stack.push t Stack.empty) []
  