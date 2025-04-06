let rec maximum xs =
  match xs with
  | [] -> neg_infinity
  | [x] -> x
  | x :: ys -> max x (maximum ys);;

  let rec maximum2 xs =
    match xs with
    | [] -> neg_infinity
    | [x] -> x
    | x :: y :: ys ->
      if x > y then maximum(x :: ys)
      else maximum(y :: ys);;