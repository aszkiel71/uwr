let empty_set = fun _ -> false;;
let singleton a = fun x -> x = a;;
let in_set a s = s a;;
let union a b = fun x -> a x || b x;;
let intersect a b = fun x -> a x && b x;;

(*naturalne [1, 10]*)
let numbers_1_to_10 = fun x -> x >= 1 && x <= 10;;

let test1 = in_set 5 numbers_1_to_10;; 
let test2 = in_set 0 numbers_1_to_10;;  
let test3 = in_set 11 numbers_1_to_10;; 

let singleton_13 = singleton 13;;

let numbers_1_to_10_and_13 = union numbers_1_to_10 singleton_13;;

let even_numbers = fun x -> x mod 2 = 0;;

let even_from_our_set = intersect numbers_1_to_10_and_13 even_numbers;;


let test1 = in_set 2 even_from_our_set;; 
let test2 = in_set 3 even_from_our_set;; 
let test3 = in_set 13 even_from_our_set;; 
let test4 = in_set 10 even_from_our_set;;
let test5 = in_set 12 even_from_our_set;;
