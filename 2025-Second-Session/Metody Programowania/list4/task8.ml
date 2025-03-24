module type PRIO_QUEUE = sig
  type ('a,'b) t 
  val empty : ('a,'b) t
  val insert : 'a->'b->('a,'b) t-> ('a,'b) t
  val pop : ('a,'b) t ->('a,'b) t
  val min_with_prio:('a,'b) t -> ('a*'b)
end
  
module PQSort (PQ : PRIO_QUEUE) = struct
  let pqsort xs =
    let q = List.fold_left(fun acc x -> PQ.insert x x acc ) PQ.empty xs in
  let rec aux q acc=
  if q = PQ.empty then List.rev acc
  else 
    let (p,v)=PQ.min_with_prio q in 
    aux (PQ.pop q) (v::acc)
  in 
  aux q []
end