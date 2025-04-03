let rec parsen_ok str =
  let arr_str = String.to_seq str |> List.of_seq in
  let rec it arr_str balance =
  match arr_str with
  | [] -> if balance <> 0 then false else true
  | x :: xs -> if balance < 0 || (x <> '('
    && x <> ')') then false else if x = '(' then it xs (balance + 1) else it xs (balance - 1)
  in it arr_str 0;;