  module type KDICT = sig
    type key
    type 'a dict
    
    val empty : 'a dict
    val insert : key -> 'a -> 'a dict -> 'a dict
    val remove : key -> 'a dict -> 'a dict
    val find_opt : key -> 'a dict -> 'a option
    val find : key -> 'a dict -> 'a
    val to_list : 'a dict -> (key * 'a) list
  end
  

    module MakeListDict (Ord : Map.OrderedType) : KDICT with type key = Ord.t = struct
      type key = Ord.t
      type 'a dict = (key * 'a) list
      
      let empty = []
      
      let insert key value dict =
        let rec it key value dict acc =
          match dict with
          | [] -> (key, value) :: acc
          | (k,v)::tail -> if k = key then acc @ [(k,value)] @ tail
          else it key value tail ((k,v)::acc)
        in it key value dict []
      
      let insert2 k v d = (k,v)::d

      let remove2 k d = List.filter (fun (k',_) -> Key.compare k k' <> 0) d

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
    
    module CharListDict = MakeListDict (struct
      type t = char
      let compare = compare
    end)
    