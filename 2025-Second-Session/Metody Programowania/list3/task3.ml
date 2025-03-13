let build_list n f =
  let rec it x xs =
    if x = n then xs
    else it (x+1) (f x :: xs)
  in it 1 [];;

let add1 x = x + 1;; (*for tests*)

let negative n =
  if n < 0 then n
  else (n * -1);;

let negatives n =
  build_list n negative;;

let rev n = 1.0 /. float_of_int n;;

let reciprocals n = 
  build_list (n+1) rev;;

let db n = 2*n;;

let evens n =
  0 :: build_list n db;;

let row i n =
  build_list n (fun j -> if i = j then 1 else 0);;

let identityM n =
  build_list (n+1) (fun i -> row i (n+1));;