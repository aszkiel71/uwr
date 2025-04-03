module LeftistHeap = struct
  type ('a,'b) heap =
    | HLeaf
    | HNode of int * ('a,'b) heap * 'a * 'b * ('a,'b) heap

  let rank = function 
    | HLeaf -> 0 
    | HNode(n,_,_,_,_) -> n

  let heap_ordered p = function
    | HLeaf -> true
    | HNode(_,_,p',_,_) -> p <= p'

  let rec is_valid = function
    | HLeaf -> true
    | HNode(n,l,p,v,r) ->
        rank r <= rank l
        && rank r + 1 = n
        && heap_ordered p l
        && heap_ordered p r
        && is_valid l
        && is_valid r

  let make_node p v l r =
    if rank l >= rank r
    then HNode(rank r + 1, l, p, v, r)
    else HNode(rank l + 1, r, p, v, l)

  let rec heap_merge h1 h2 =
    match h1, h2 with
    | HLeaf, h -> h
    | h, HLeaf -> h
    | HNode(_,l1,p1,v1,r1), HNode(_,l2,p2,v2,r2) ->
        if p1 <= p2
        then make_node p1 v1 l1 (heap_merge r1 h2)
        else make_node p2 v2 l2 (heap_merge r2 h1)
end

