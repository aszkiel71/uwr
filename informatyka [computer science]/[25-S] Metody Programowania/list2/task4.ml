let rec mem x xs =
  match xs with
  | [] -> false
  | y :: ys -> if x = y then true else mem x ys;;