let rec gcd a b =
  if b = 0 then a
  else gcd b (a mod b);;


let rec find x xs =
  match xs with
  | [] -> false
  | y :: ys ->
    if y = x then true
    else find x ys;;


let rec binary_search x xs l r =
  if l > r then -1
  else
  let mid = (l + r) / 2 in
  if xs.(mid) = x then mid
  else if l > r then -1 
  else if x > xs.(mid) then binary_search x xs (mid+1) r
  else binary_search x xs l (mid-1);;

let array = [|1;2;3;4;5;6;10|];;


let rec count_el x xs =
  match xs with
  | [] -> 0
  | y :: ys ->
    if x = y then 1 + count_el x ys 
    else count_el x ys;;


let rec select xs =
  match xs with
  | [] -> failwith "select"
  | [x] -> (x, [])
  | x :: ys -> let(min_el, rest) = select ys in if x < min_el then (x, min_el :: rest) else (min_el, x :: rest);;



let rec select_sort xs =
  if xs = []
    then xs
  else let (min_el, rest) = select xs in min_el :: select_sort rest;;
