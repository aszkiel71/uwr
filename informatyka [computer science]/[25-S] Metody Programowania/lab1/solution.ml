let alpha_num = 3
let alpha_denom = 4

type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree
type 'a sgtree = { tree : 'a tree; size : int; max_size: int }

let logus (a : float) (b : float) : float = log b /. log a

let alpha_height (n : int) : int =
  if n <= 0 then 0
  else
    let base = float_of_int alpha_denom /. float_of_int alpha_num in
    let log_base = logus base (float_of_int n) in
    int_of_float (Float.floor log_base)

let tree_to_list (tree : 'a tree) : 'a list =
    let rec tmp_acc (t : 'a tree) (acc : 'a list) : 'a list = 
        match t with
        | Leaf -> acc
        | Node(l, v, r) -> tmp_acc l (v :: tmp_acc r acc)
    in List.rev (tmp_acc tree [])
      

let split_list (mid : int) (lst : 'a list) : 'a list * 'a list =
  let rec tmp (n : int) (acc : 'a list) (rem : 'a list) : 'a list * 'a list =
    match rem with
    | [] -> (List.rev acc, [])
    | x::xs -> 
        if n <= 0 then (List.rev acc, rem)  
        else tmp (n-1) (x::acc) xs
  in
  tmp mid [] lst

let rec arr_to_bbst (arr : 'a list) : 'a tree =
    match arr with
    | [] -> Leaf
    | [x] -> Node(Leaf, x, Leaf)
    | _ ->
        let mid = List.length arr / 2 in
        let left, right = split_list mid arr in
        match right with
        | [] -> failwith "no elem. on the right"
        | mid_val :: right_list -> 
            Node(arr_to_bbst left, mid_val, arr_to_bbst right_list)
  

let rebuild_balanced (t : 'a tree) : 'a tree =
    let lst = tree_to_list t |> List.rev in
    arr_to_bbst lst
              

let rec bst_insert (x : 'a) (t : 'a tree) : 'a tree =
  match t with
  | Leaf -> Node(Leaf, x, Leaf)
  | Node(l, v, r) ->
      if x < v then Node(bst_insert x l, v, r)
      else if x > v then Node(l, v, bst_insert x r)
      else t

let rec min_value_node (t : 'a tree) : 'a =
  match t with
  | Node(Leaf, v, _) -> v
  | Node(l, _, _) -> min_value_node l
  | Leaf -> failwith "empty tree (unlucky)"

let rec bst_remove (x : 'a) (t : 'a tree) : 'a tree =
  match t with
  | Leaf -> Leaf
  | Node(l, v, r) ->
      if x < v then Node(bst_remove x l, v, r)
      else if x > v then Node(l, v, bst_remove x r)
      else match (l, r) with
        | (Leaf, _) -> r
        | (_, Leaf) -> l
        | _ ->
            let min_val = min_value_node r in
            Node(l, min_val, bst_remove min_val r)

let find_insert_path (x : 'a) (t : 'a tree) : 'a tree list =
  let rec path_collector (acc : 'a tree list) (current : 'a tree) : 'a tree list =
    match current with
    | Leaf -> acc
    | Node(l, v, r) as node ->
        if x < v then path_collector (node::acc) l
        else path_collector (node::acc) r
  in List.rev (path_collector [] t)

let is_balanced (tree : 'a tree) : bool =
  let rec size (t : 'a tree) : int =
    match t with
    | Leaf -> 0
    | Node(l, _, r) -> 1 + size l + size r
  in
  match tree with
  | Leaf -> true
  | Node(l, v, r) ->
      let s = size tree in
      let alpha = float_of_int alpha_num /. float_of_int alpha_denom in
      float_of_int (size l) <= alpha *. float_of_int s &&
      float_of_int (size r) <= alpha *. float_of_int s

let repair (path : 'a tree list) : 'a tree =
  let rec find_scapegoat = function
    | [] -> failwith "scapegoat was not found"
    | t::rest -> if is_balanced t then find_scapegoat rest else t
  in
  let scapegoat = find_scapegoat path in
  let rebuilt = rebuild_balanced scapegoat in
  let rec replace_node (old : 'a tree) (new_t : 'a tree) (target : 'a tree) : 'a tree =
    match target with
    | Node(l, v, r) when target == old -> new_t
    | Node(l, v, r) -> 
        Node(replace_node old new_t l, v, replace_node old new_t r)
    | Leaf -> Leaf
  in
  replace_node scapegoat rebuilt (List.hd path)

let empty : 'a sgtree = { tree = Leaf; size = 0; max_size = 0 }

let rec find (x : 'a) (sgt : 'a sgtree) : bool =
  let rec search (t : 'a tree) : bool =
    match t with
    | Leaf -> false
    | Node(l, v, r) -> x = v || search (if x < v then l else r)
  in search sgt.tree

let insert (x : 'a) (sgt : 'a sgtree) : 'a sgtree =
    if find x sgt then failwith "already exists"
    else
        let new_tree = bst_insert x sgt.tree in
        let path = find_insert_path x new_tree in
        let depth = (List.length path) - 1 in 
        let max_h = alpha_height (sgt.size + 1) in
        let final_tree = 
        if depth > max_h then 
            repair path
        else new_tree
        in
        { tree = final_tree;
        size = sgt.size + 1;
        max_size = max sgt.max_size (sgt.size + 1) }


let remove (x : 'a) (sgt : 'a sgtree) : 'a sgtree =
  if not (find x sgt) then failwith "it would seem so to be not found"
  else
    let new_tree = bst_remove x sgt.tree in
    let new_size = sgt.size - 1 in
    
    if float_of_int new_size < (float_of_int alpha_num /. float_of_int alpha_denom) *. float_of_int sgt.max_size then
      { tree = rebuild_balanced new_tree; 
        size = new_size; 
        max_size = new_size }
    else
      { sgt with tree = new_tree; size = new_size }
