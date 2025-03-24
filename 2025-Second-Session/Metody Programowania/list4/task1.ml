module type DICT = sig
  type ('a , 'b ) dict
  val empty : ('a , 'b ) dict
  val insert : 'a -> 'b -> ('a , 'b ) dict -> ('a , 'b ) dict
  val remove : 'a -> ('a , 'b ) dict -> ('a , 'b ) dict
  val find_opt : 'a -> ('a , 'b ) dict -> 'b option
  val find : 'a -> ('a , 'b ) dict -> 'b
  val to_list : ('a , 'b ) dict -> ('a * 'b ) list
  end

  module ListDict : DICT = struct
    type ('a, 'b) dict = ('a * 'b) list
    
    let empty = []
    
    let insert key value dict =
      let rec it key value dict acc =
        match dict with
        | [] -> (key, value) :: acc
        | (k,v)::tail -> if k = key then acc @ [(k,v)] @ tail
        else it key value tail ((k,v)::acc)
      in it key value dict []

    
    let remove key dict =
      let rec it key dict acc = 
        match dict with
        | [] -> acc
        | (k,v)::tail -> if k <> key then it key tail ((k,v)::acc) 
        else acc @ tail
      in it key dict []
    
    let rec find_opt key = function
      | [] -> None
      | (a,b)::tail -> if a = key then Some(b)
        else find_opt key tail 
    
    let rec find key = function
    | [] -> failwith "Key not found"
    | (a,b)::tail -> if a = key then b
      else find key tail 
    let to_list dict = dict

  end
  