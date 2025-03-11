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

