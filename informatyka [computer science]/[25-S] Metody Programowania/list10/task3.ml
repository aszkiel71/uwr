let maxstacksize prog =
  let rec aux curr res arr =
    match prog with
    | [] -> res
    | cmd :: rest ->
      match cmd with
      | PushInt _ | PushBool _ | PushUnit -> if curr + 1 > res then aux (curr+1) (curr+1) rest else aux (curr + 1) res rest
      | Binop _ -> aux (curr-1) res rest
      | _ -> aux curr res rest
    in aux 0 0 prog

    