let f =
  let x = ref 0 in
  (fun n -> let z = (x := !x + 1) in n + !x)

in
(f 42, let x = f 42 in f 42)
