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
  else let (min_elemt, rest) = select xs in min_elem :: select_sort rest;;
