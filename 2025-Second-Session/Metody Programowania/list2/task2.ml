let matrix_mult (a,b,c,d) (e, f, g, h) =
  (a*e + b*g, a*f + b*h, c*e + d*g, c*f + d*h);;

let matrix_id = (1, 0, 0, 1);;

let rec matrix_expt1 m k =
  if k = 0 then matrix_id
  else if k = 1 then m
  else matrix_mult m (matrix_expt1 m (k - 1));;
    
    

let fib_matrix k =
  let(fk1, fk, _, _) = matrix_expt (1, 1, 1, 0) k in fk;;
