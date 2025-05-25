type 'a tree =
    | Leaf
    | Node of 'a tree * 'a * 'a tree


let rec size t =
    match t with
    | Leaf -> 0
    | Node(l, _, r) -> size l + size r + 1

let rec insert x t =
    match t with
    | Leaf -> Node(Leaf, x, Leaf)
    | Node(l, v, r) ->
        if x < v then Node(insert x l, v, r)
        else Node(l, v, insert x r)

let rec fold_tree f acc t =
    match t with
    | Leaf -> acc
    | Node(l, v, r) -> f (fold_tree f acc l) v (fold_tree f acc r)

let sum t = fold_tree (fun v l r -> v + l + r) 0 t

let rec tree_height t = match t with | Leaf -> 0 | _ -> fold_tree (fun l v r -> max l r) 0 t

let rec tree_height2 t =
    match t with
    | Leaf -> 0
    | Node(l, _, r) -> max (tree_height2 l + 1) (tree_height2 r + 1)

let rec exist t k = fold_tree (fun v l r -> v = k || l || r) false t

let rec exist2 t k =
    match t with
    | Leaf -> false
    | Node(l, v, r) ->
            if k = v then true
            else if k > v then exist r k
            else exist l k


let rec leaf_count t =
    match t with
    | Leaf -> 1
    | Node(l, v, r) -> leaf_count l + leaf_count r

let leaf_count2 t = fold_tree (fun l _ r -> l + r) 1 t

let rec to_list t =
        match t with
        | Leaf -> []
        | Node(l, v, r) -> to_list l @ [v] @ to_list r

let to_list2 t = fold_tree (fun l v r -> l @ [v] @ r) [] t

let rec maxontree t =
    match t with
    | Leaf -> 0
    | Node(l, v, r) -> max (max (maxontree l) v) (maxontree r)

let maxontree2 t = fold_tree (fun l v r -> max (max l v) r) 0 t

let rec dfs_map f t =
    match t with
    | Leaf -> Leaf
    | Node(l, v, r) -> Node(dfs_map f l, f v, dfs_map f r)

let dfs t =
    let rec aux stack acc =
        match stack with
        | [] -> List.rev acc
        | Leaf :: rest -> aux rest acc
        | Node(l, v, r) :: rest -> aux (l :: r :: rest) (v :: acc)
    in
    aux [t] []
