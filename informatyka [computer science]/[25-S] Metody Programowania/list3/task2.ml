let square x = x * x;;

let inc x = x + 1;;

let compose f g x = f ( g x );;

(* compose square inc x = square (inc x) = square ( x + 1 )*)
(* compose inc square x = inc (square x) = inc ( x * x ) = x * x + 1 *)