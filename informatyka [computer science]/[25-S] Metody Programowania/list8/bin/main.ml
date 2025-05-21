let read_file_to_string filename =
  let ic = open_in filename in
  let len = in_channel_length ic in
  let content = really_input_string ic len in
  close_in ic;
  content

let () =
  if Array.length Sys.argv < 2 then
    Printf.eprintf "Usage: %s <filename>\n" Sys.argv.(0)
  else
    try
      Sys.argv.(1)
        |> read_file_to_string
        |> Fun.Interp.interp
        |> Fun.Interp.show_value
        |> print_string;
      print_newline ();
    with Sys_error msg ->
      Printf.eprintf "Error: %s\n" msg
