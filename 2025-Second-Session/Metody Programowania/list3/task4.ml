
type 'a set = 'a -> bool

let empty_set : 'a set = fun _ -> false

let singleton (a : 'a) : 'a set = fun x -> x = a


let in_set (a : 'a) (s : 'a set) : bool = s a


let union (s : 'a set) (t : 'a set) : 'a set = fun x -> s x || t x

let intersect (s : 'a set) (t : 'a set) : 'a set = fun x -> s x && t x