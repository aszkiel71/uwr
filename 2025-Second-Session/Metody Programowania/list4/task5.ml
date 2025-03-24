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

module MakeMapDict (Ord : Map.OrderedType) : KDICT with type key = Ord.t = struct
  module M = Map.Make(Ord)

  type key = Ord.t
  type 'a dict = 'a M.t

  let empty = M.empty

  let insert key value dict = M.add key value dict

  let remove key dict = M.remove key dict

  let find_opt key dict = M.find_opt key dict

  let find key dict = M.find key dict

  let to_list dict = M.bindings dict
end

module CharMapDict = MakeMapDict (struct
  type t = char
  let compare = compare
end)


module Freq (D : KDICT) = struct
  let freq xs  =
    let rec count_elements lst dict =
      match lst with
      | [] -> dict
      | x :: xs' ->
          let current_count = match D.find_opt x dict with
            | Some c -> c + 1
            | None -> 1
          in
          count_elements xs' (D.insert x current_count dict)
    in
    D.to_list (count_elements xs D.empty)
end


let list_of_string s = String.to_seq s |> List.of_seq

module CharFreq = Freq(CharMapDict)

let char_freq (s : string) : (char * int) list =
  CharFreq.freq (list_of_string s)