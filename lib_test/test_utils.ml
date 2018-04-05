module Str = Re.Str

let __regexp = Str.regexp "^[a-f0-9]+$"

let is_hexadecimal text =
  Str.string_match __regexp text 0

let does_collide ( ) =
  let collision  = ref false in
  let iterations = 20000000 in
  let cuids      = Hashtbl.create iterations in
  let rec loop index =
    if index > iterations then ( ) else (
      let cuid = Cuid.generate ( ) in
      if Hashtbl.mem cuids cuid then
        collision := true
      else
        (Hashtbl.add cuids cuid true;
        loop (index + 1))
    )
  in
  loop 1;
  !collision
