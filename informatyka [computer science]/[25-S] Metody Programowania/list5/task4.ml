let rec parens_ok str =
  let arr_str = String.to_seq str |> List.of_seq in
    let rec it arr_str b1 b2 b3 =
      match arr_str with
      | [] -> if b1 <> 0 || b2 <> 0 || b3 <> 0 then false else true
      | x :: xs -> if b1 < 0 || b2 < 0 || b3 < 0 || (x <> '(' && x <> ')' && x <> '{' && x <> '}' && x <> '[' && x <> ']') then false else
                              if x = '(' then it xs (b1+1) b2 b3
                              else if x = ')' then it xs (b1-1) b2 b3
                              else if x = '[' then it xs b1 (b2+1) b3
                              else if x = ']' then it xs b1 (b2-1) b3
                              else if x = '{' then it xs b1 b2 (b3+1)
                              else it xs b1 b2 (b3-1)
        in it arr_str 0 0 0;; 



        (*nie obchodzi mnie ta wskazowka*)
      
        