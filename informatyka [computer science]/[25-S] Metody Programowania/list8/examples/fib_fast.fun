let fib =
  (funrec go p -> fun n ->
    if n <= 0
      then (snd p)
      else go (fst p + snd p, fst p) (n - 1))
  (1, 0)
in
  fib 35
