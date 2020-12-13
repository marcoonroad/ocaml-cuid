let write channel text =
  flush channel;
  output_string channel (text ^ "\n");
  flush channel

let print = write stdout
let error = write stderr

let ( ) =
  if Array.length Sys.argv > 1 then begin
    if Sys.argv.(1) = "-slug" || Sys.argv.(1) = "--slug"
    then print @@ Cuid.slug ~stateless:true ( )
    else error "Invalid command-line arguments, only the optional -slug or --slug flag is accepted."
  end
  else print @@ Cuid.generate ~stateless:true ( )
