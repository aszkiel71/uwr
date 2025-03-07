let rec loop () = loop ();;

let rec loop_n n = loop_n (n + 1);;

let rec fact n =
  if n = 0
  then 1
  else n * fact (n - 1);;

let fact_iter n =
  let rec it i acc =
    if n = 0
    then acc
    else it (n - 1) (acc * n)
  in it n 1;;

let list_hd xs = match xs with
  | [] -> failwith "list_hd"
  | x :: _ -> x;;

let rec nth xs n =
  if n = 0
  then List.hd xs
  else nth (List.tl xs) (n - 1);;

let rec append xs ys =
  match xs with
  | [] -> ys
  | x :: xs' -> x :: append xs' ys;;

let rec reverse_first_try xs =
  match xs with
  | [] -> []
  | x :: xs -> append (reverse_first_try xs) [x];;

let reverse xs =
  let rec it xs ys =
    match xs with
    | [] -> ys
    | x :: xs -> it xs (x :: ys)
  in it xs [];;

let rec insert y xs =
  match xs with
  | [] -> [y]
  | x :: xs' -> if y < x
    then y :: xs
    else x :: insert y xs';;

let insertion_sort xs =
  let rec it xs ys =
    match xs with
    | [] -> ys
    | x :: xs' -> it xs' (insert x ys)
  in it xs [];;

let rec from_to n m =
  if n < m then n :: from_to (n + 1) m else [];;