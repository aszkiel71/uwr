type stack_elem =
  | value of int
  | op string * int list (*np +, [3, 4]*)

let apply_op op a b =
  match op with
  | "+" -> a + b
  | "-" -> a - b
  | "*" -> a * b
  | "/" -> if b = 0 then failwith "division by zero" else a / b
  | _ -> failwith ("unknown operator: " ^ op)

let eval tokens = 
  let rec process tokens stack =
    match tokens with
    | [] -> (
      match stack with
      | [value v] -> v
      | _ -> failwith "invalid expr"
    )
    | token :: rest ->
      if List.mem token ["+"; "-"; "*"; "/"] then
        process rest (op (token, []) :: stack)
      else 
        let num = int_of_string token in
        let rec reduce stack =
          match stack with
          | op (opname, [a]) :: rest ->
            let res = apply_op opname a num in
            reduce (value res :: rest)
          | op (opname, []) :: rest ->
            op(opname, [num]) :: rest
          | _ -> value num :: stack
          in 
          process rest (reduce stack)
        in 
        process tokens []