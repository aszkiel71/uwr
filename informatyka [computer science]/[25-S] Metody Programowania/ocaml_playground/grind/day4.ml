(*list2*)

let rec fib n = if n = 0 then 0 else if n = 1 then 1 else (fib (n-1)) + (fib (n-2))
let fib_iter n =
    let rec it a b counter =
    if counter = n then a
    else it b (a+b) (counter+1)
    in it 0 1 0

let rec mem x xs =
    match xs with
    | [] -> false
    | y :: ys -> if x = y then true else mem x ys

let maximum xs =
    match xs with
    | [] -> neg_infinity
    | x :: ys ->
        let rec aux res lst =
            match lst with
            | [] -> res
            | y :: ys' -> aux (max y res) ys'
    in aux x ys;;


let rec suffixes xs =
    match xs with
    | [] -> [[]]
    | x :: xs' -> [(x :: xs')] @ suffixes xs'

let rec issorted xs =
    match xs with
    | [] -> true
    | [x] -> true
    | x :: y :: xs -> if x > y then false else issorted (y :: xs)


let rec select xs =
  match xs with
    | [] -> failwith "select"
    | [x] -> (x, [])
    | x :: xs' -> let (min_tail, rest) =
      select xs' in if x < min_tail
        then (x, min_tail :: rest)
        else (min_tail, x :: rest);;

let rec select_sort xs =
  if xs = []
    then []
  else let (min_elemt, rest) = select xs in min_elemt :: select_sort rest;;
