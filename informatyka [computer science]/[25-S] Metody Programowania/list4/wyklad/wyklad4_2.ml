module Queue = struct
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
