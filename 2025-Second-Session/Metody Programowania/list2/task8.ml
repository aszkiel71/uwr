let rec minimum xs =
  match xs with
  | [] -> min_int
  | [x] -> x
  | x :: y :: ys ->
    if x < y then minimum(x :: ys)
    else minimum(y :: ys);;

let rec remove_min xs min_element =
  match xs with
  | [] -> []
  | x :: xs' ->
    if x = min_element then remove_min xs' min_element
    else x :: remove_min xs' min_element;;

let select xs =
  match xs with
  | [] -> min_int, []
  | _ ->
    let min_element = minimum xs in
    let new_list = remove_min xs min_element in
    (min_element, new_list);;


let rec select_sort xs =
  match xs with
  | [] -> []
  | [x] -> [x]
  | _ ->
    let (min_elem, rest) = select xs in
    min_elem :: select_sort rest;;
