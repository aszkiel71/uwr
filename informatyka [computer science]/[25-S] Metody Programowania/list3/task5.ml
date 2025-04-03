type int_tree = LeafI | NodeI of int_tree * int * int_tree
type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree
type ('a, 'b) tree2 = Leaf2 | Node2 of ('a, 'b) tree2 * 'a * 'b * ('a, 'b) tree2
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
  )

let rec insert_bst x t =
  match t with
  | Leaf -> Node(Leaf,x,Leaf)
  | Node (l, v, r) -> 
      if x = v then t
      else if x < v then Node(insert_bst x l, v, r)
      else Node(l, v, insert_bst x r)