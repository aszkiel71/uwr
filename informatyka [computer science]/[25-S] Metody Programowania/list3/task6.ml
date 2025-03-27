type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree;;

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


let rec fold_tree f a t =
  match t with
  | Leaf -> a
  | Node (l, v, r) -> f (fold_tree f a l) v (fold_tree f a r);;



let tree_product t = fold_tree (fun a b c-> a * b * c) 1 t;;
let tree_flip t = fold_tree (fun a b c->Node(c ,b ,a)) Leaf t;;
let tree_height t = fold_tree (fun a b c->1+ max a c) 0 t;;

let tree_span t = let l,r = fold_tree (fun l v r ->
  ((if (fst l)=[] then [v] else fst l),
  (if (snd r)=[] then [v] else snd r)))
  ([],[]) t in (List.hd(l),List.hd(r));;

let flatten t = fold_tree (fun l v r ->
  v::l@r)
  [] t;;


  (*l@r łączy listy*)