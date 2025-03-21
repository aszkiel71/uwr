module type PRIO_QUEUE = sig
  type ('a, 'b) pq
  val empty : ('a, 'b) pq
  val insert : 'a -> 'b -> ('a, 'b) pq -> ('a, 'b) pq
  val pop : ('a, 'b) pq -> ('a, 'b) pq
  val min : ('a, 'b) pq -> 'b
  val min_prio : ('a, 'b) pq -> 'a
end

module ListPrioQueue : PRIO_QUEUE = struct
  type ('a, 'b) pq = ('a * 'b) list
  let empty = []
  let pop q = List.tl q
  let rec insert a x q =
    match q with
    | [] -> [(a, x)]
    | (b, y) :: q' -> if a < b then (a, x) :: q else (b, y) :: insert a x q'
  let min q = List.hd q |> snd
  let min_prio q = List.hd q |> fst
end

type 'a code_tree = CTNode of 'a code_tree * 'a code_tree | CTLeaf of 'a

let make_code_tree xs =
  let rec it q = (
    let t1 = ListPrioQueue.min q
    and p1 = ListPrioQueue.min_prio q
    and q' = ListPrioQueue.pop q
    in if q' = ListPrioQueue.empty
    then t1
    else 
      let t2 = ListPrioQueue.min q'
      and p2 = ListPrioQueue.min_prio q'
      and q'' = ListPrioQueue.pop q'
      in it (ListPrioQueue.insert (p1 + p2) (CTNode (t1, t2)) q''))
  in let initial_pq =
    List.fold_left (fun q (p, v) -> ListPrioQueue.insert p (CTLeaf v) q) ListPrioQueue.empty xs
  in it initial_pq

  let decode bs t =
    let rec walk bs cur_t =
      match cur_t, bs with
      | CTLeaf v, _ -> v :: start bs
      | CTNode (l, r), 0 :: bs' -> walk bs' l
      | CTNode (l, r), 1 :: bs' -> walk bs' r
      | _, _ :: _ -> failwith "invalid bit"
      | _, [] -> failwith "incomplete code"
    and start bs =
      if bs = []
      then []
      else walk bs t
    in start bs

