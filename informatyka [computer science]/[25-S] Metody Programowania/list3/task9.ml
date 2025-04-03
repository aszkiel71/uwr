type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree
let example_tree = Node (Node (Leaf, 1, Leaf), 2, Node(Leaf, 3, Leaf))
let t =
  Node (
    Node (Leaf ,2, Leaf),
    5,
    (Node (
      Node (Leaf ,6, Leaf),
      8,
      (Node (Leaf ,9, Leaf))
      )
    )
  );;

  let rec delete x t =
    let rec delete_min = function
      | Leaf -> failwith "some error (probably u tried on a leaf)"
      | Node (Leaf, v, r) -> (v, r)
      | Node (l, v, r) ->
          let (min_val, new_l) = delete_min l in
          (min_val, Node (new_l, v, r))
    in
    match t with
    | Leaf -> Leaf
    | Node (l, v, r) ->
        if x < v then
          Node (delete x l, v, r)
        else if x > v then
          Node (l, v, delete x r)
        else
          match (l, r) with
          | (Leaf, Leaf) -> Leaf
          | (Leaf, r) -> r
          | (l, Leaf) -> l
          | (l, r) ->
              let (min_val, new_r) = delete_min r in
              Node (l, min_val, new_r);;