let empty_set = false;;

let singleton a = fun x -> x==a;;

let in_set a s = s a;;

let union a b = fun x -> a x || b x;;

let intersect a b = fun x -> a x && b x