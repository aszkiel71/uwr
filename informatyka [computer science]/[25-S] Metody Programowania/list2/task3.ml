let rec ebs n k =
  let rec it w n k =
    if k = 0 then 
      w
    else if k mod 2 = 1 then 
      it (w*n) (n*n) (k/2)
  else
      it w (n*n) (k/2)
  in it 1 n k;; 