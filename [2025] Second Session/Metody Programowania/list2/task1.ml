let rec fib n =
  if n = 0 
    then 0
  else if n = 1
    then 1
  else
    fib (n-1) + fib (n - 2);;

let fib_it n =
  let rec it i a b =
    if i = n
      then a
    else it (i+1) b (a+b)
  in it 0 0 1;;