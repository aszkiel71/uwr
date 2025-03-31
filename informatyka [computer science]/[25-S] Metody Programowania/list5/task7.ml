type 'a symbol =
| T of string
| N of 'a 
type 'a grammar = ('a * ('a symbol list ) list ) list
let expr : unit grammar = [() , [[ N () ; T "+"; N () ]; [ N () ; T "*"; N () ]; [ T "("; N () ; T ")"]; [ T "n"]]] 

let pol : string grammar = [
 "zdanie", [[ N "grupa-podmiotu"; N "grupa-orzeczenia"]];

 "grupa-podmiotu", [[ N "przydawka"; N "podmiot"]];
 "grupa-orzeczenia", [[ N "orzeczenie"; N "dopelnienie"]];

 "przydawka", [[ T "Piekny"]; [ T "Bogaty"]; [ T "Wesoly"]];
 "podmiot", [[ T "policjant"]; [ T "student"]; [ T "piekarz"]];
 "orzeczenie", [[ T "zjadl"]; [ T "pokochal"]; [ T "zobaczyl"]];
 "dopelnienie", [[ T "zupe."]; [ T "sam siebie."]; [ T "instytut informatyki."]]
];;



let generate grammar start_symbol=
  let rec expand symbol =
    match symbol with
    |T s-> s
    |N s ->(let productions=List.assoc s grammar in
      let this_production= List.nth productions (Random.int(List.length productions)) in
        let rec expand_list symbols=
          match symbols with
            |[]->""
            |[s]-> expand s
            |hd::tl -> (expand hd) ^ " " ^ (expand_list tl)
          in expand_list this_production)
      in expand (N start_symbol);;