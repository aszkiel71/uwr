let rec map f xs =
  match xs with
  | [] -> []
  | x :: xs -> f x :: map f xs;;

let add_5 x = x + 5;;

map add_5 [231;312;132;123;123;11];;

let rec only_positive xs =
  match xs with
  | [] -> []
  | x :: xs -> if x > 0 then x :: only_positive xs else only_positive xs;;


let rec filter f xs =
  match xs with
  | [] -> []
  | x :: xs -> if f x then x :: filter f xs else filter f xs;;

let parity x =
  if x mod 2 = 0 then true else false;;

let rec only_negative xs =
  match xs with
  | [] -> []
  | x :: xs -> if x < 0 then x :: only_negative xs else only_negative xs;;

let rec sum xs =
  match xs with
  | [] -> 0
  | x :: xs -> x + sum xs;;

let rec product xs =
  match xs with
  | [] -> 1
  | x :: xs -> x * product xs;;

let rec find x xs =
  match xs with
  | [] -> false
  | y :: ys -> if x = y then true else find x ys;;

let rec isPrime x =
  let rec it x acc =
    if x = 1 || x = 4 then false else if x = 2 || x = 3 then true
    else if x mod 2 = 0 then false
    else if acc = x / 2 then true 
    else if x mod acc = 0 then false
    else (it x (acc+1))
  in it x 2;;

let rec fact n =
  if n = 0 then 1
  else n * fact(n-1);;

let rec binomial n k =
  if k = n || k = 0 then 1
  else if k > n || k < 0 then 0
  else binomial (n-1) (k-1) + binomial (n-1) k;;  

let binomial2 n k = 
  if k = n || k = 0 then 1
  else if k > n || k < 0 then 0
  else fact (n) / (fact (k) * fact (n-k));;