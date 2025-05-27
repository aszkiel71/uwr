(*StringMap -> niemutowalna, za kazdym razem tworzymy nowy obiekt*)
(*Hashtbl   -> mutowalny stan*)

module StringMap = Map.Make(String)
let m = StringMap.empty
let m = StringMap.add "ala" 1 m
let m = StringMap.add "ma" 2 m
let m = StringMap.add "kojota" 3 m
StringMap.mem "ala" m
StringMap.find "ma" m
let m = StringMap.remove "ala" m
let pairs = StringMap.fold (fun k v acc -> (k, v) :: acc) m []
let m = StringMap.map (fun v -> v + 42) m
let m3 = StringMap.add "ala" 42 StringMap.empty
let m3 = StringMap.add "ma" 41 m3
let m3 = StringMap.add "kojota" 69 m3
let m_union = StringMap.union
let m_union = StringMap.union (fun _ v1 v2 -> Some (v1 + v2)) m m3
let list3 = StringMap.fold (fun k v acc -> (k, v) :: acc) m_union []

(*hashtbl*)

let h = Hashtbl.create 16
Hashtbl.add h "ala" 1
Hashtbl.replace h "ala" 42
Hashtbl.find h "ala"
Hashtbl.mem h "ala"
Hashtbl.remove h "ala"

(*own type*)

type klucz = int * string

module KluczMap = Map.Make(struct
    type t = klucz
    let compare = compare
end)

let m = KluczMap.empty
let m = KluczMap.add (1, "ala") 10 m
let m = KluczMap.add (2, "kojot") 42 m



module type STACK = sig
  type 'a t (*typ stosu*)
  val empty : 'a t (*pusty stos, dowolnego typu*)
  val push : 'a -> 'a t -> 'a t (*przyjmuje 'a i stos i zwraca stos z tym elementem*)
  val pop : 'a t -> 'a t (*przyjmuje stos i zwraca stos*)
  val top : 'a t -> 'a option (*przyjmuje stos typu 'a i zwraca None albo cos*)
  val is_empty : 'a t -> bool (*przyjmuje stos, zwraca boola*)
end


module StackList : STACK = struct
    type 'a t = 'a list (*stos jako lista*)
    let empty = []
    let push x s = x :: s
    let pop s =
        match s with
        | [] -> []
        | _ :: s' -> s'
    let top s =
        match s with
        | [] -> None
        | x :: _ -> Some x
    let is_empty s =
        match s with
        | [] -> true
        | _ -> false
end


module type QUEUE = sig
  type 'a t (*typ kolejki*)
  val empty : 'a t (*pusta kolejka, dowolnego typu*)
  val enqueue : 'a -> 'a t -> 'a t (*przyjmuje 'a i kolejka i zwraca kolejke z tym elementem*)
  val dequeue : 'a t -> 'a t (*przyjmuje kolejke i zwraca kolejke*)
  val first: 'a t -> 'a option (*przyjmuje kolejke typu 'a i zwraca None albo cos*)
  val is_empty : 'a t -> bool (*przyjmuje kolejke, zwraca boola*)
end

(*fifo -> first in, first out*)

module QueueList : QUEUE = struct
    type 'a t = 'a list
    let empty = []
    let enqueue x q = q @ [x]
    let dequeue q =
        match q with
        | [] -> []
        | _ :: xs -> xs
    let first q =
        match q with
        | [] -> None
        | x :: _ -> Some x
    let is_empty q = (q = [])
end


(*dfs / bfs*)

let graph = [|
  [1; 2; 3];   (* 0 ma krawedzie do 1, 2, 3 *)
  [];          (* 1 nie ma dzieci *)
  [4];         (* 2 ma krawedz do 4 *)
  [5];         (* 3 ma krawedz do 5 *)
  [6];         (* 4 ma krawedz do 6 *)
  [];          (* 5 nie ma dzieci *)
  []           (* 6 nie ma dzieci *)
|]

(*
        0
      / | \
     1  2  3
        |   \
        4    5
       /
      6
*)

let visited = Array.make (Array.length graph) false
let stack = Stack.create ()

let dfs graph start =
  let rec dfst visited stack =
    match stack with
    | [] -> List.rev visited
    | v :: rest ->
        if List.mem v visited then
          dfst visited rest
        else
          let neighbors = graph.(v) in
          dfst (v :: visited) (neighbors @ rest)
  in
  dfst [] [start]

let bfs graph start =
  let rec bfst visited queue =
    match queue with
    | [] -> List.rev visited
    | v :: rest ->
        if List.mem v visited then
          bfst visited rest
        else
          let neighbors = graph.(v) in
          bfst (v :: visited) (rest @ neighbors)
  in
  bfst [] [start]

let toposort graph = List.rev (dfs graph 0)
