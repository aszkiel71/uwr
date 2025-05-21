let rec fold_left f acc lst =
    match lst with
        | [] -> acc
        | x :: xs -> fold_left f (f acc x) xs

let rec fold_right f acc lst =
    match lst with
        | [] -> acc
        | x :: xs -> fold_right f (f x (fold_right f acc xs)) xs


let rec length lst acc =
    match lst with
        | [] -> acc
        | x :: xs -> length xs (acc+1)

let rec length_fl lst = fold_left (fun acc _ -> acc + 1) 0 lst

let rec map f acc lst =
    match lst with
        | [] -> acc
        | x :: xs -> map f (f x :: acc) xs

let map_fl f lst = List.rev(fold_left (fun acc x -> (f x) :: acc) [] lst)
let map_fr f lst = fold_right (fun x acc -> (f x) :: acc) lst []

let rec filter f acc lst =
    match lst with
    | [] -> acc
    | x :: xs -> if (f x) then filter (f) (x :: acc) xs else filter (f) acc xs

let filter_fl f lst = fold_left (fun acc x -> if (f x) then x :: acc else acc) [] lst
let filter_fr f lst = fold_right (fun x acc -> if (f x) then x :: acc else acc) lst []

let rev_fl lst = fold_left (fun acc x -> x :: acc) [] lst
let rev_fr lst = List.rev(fold_right (fun x acc -> x :: acc) lst [])

let flatten_fl lst = fold_left (fun acc x -> acc @ x) [] lst
let flatten_fr lst = fold_right (fun x acc -> x @ acc) lst []

let exist_fl lst x = fold_left (fun acc x' -> if (x' = x) then true else acc) false lst
let exist_fr lst x = fold_right (fun x' acc -> if (x' = x) then true else acc) lst false

let forall_fl f lst = fold_left (fun acc x -> if (f x) then acc else false) true lst
let forall_fr f lst = fold_right (fun x acc -> if (f x) then acc else false) lst true