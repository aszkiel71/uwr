let empty_set x = false;;

let empty_set2 = [];;

let singleton a x =
  if x = a then true
  else false;;

let singleton2 a = [a];;

let rec in_set a s =
  match s with
  | [] -> false
  | y :: ys -> if a = y then true
  else in_set a ys;;

let in_set2 a s = s a;;
 (*to do later*)