let fold_left f a xs =
  let rec it xs acc =
    match xs with
    | [] -> acc
    | x :: xs -> it xs (f acc x)
  in it xs a;;

let product xs = fold_left ( * ) 1 xs;;


let rec product2 xs =
  match xs with
  | [] -> 1
  | y :: ys -> y * product2 ys;;