module Str = Re.Str

let __regexp = Str.regexp "^[a-z0-9]+$"

let is_base36 text =
  Str.string_match __regexp text 0

let does_collide_with iterations generator ( ) =
  let collision  = ref false in
  let cuids      = Hashtbl.create iterations in
  let rec loop index =
    if index > iterations then ( ) else (
      let cuid = generator ( ) in
      if Hashtbl.mem cuids cuid then
        collision := true
      else
        (Hashtbl.add cuids cuid true;
        loop (index + 1))
    )
  in
  loop 1;
  !collision

(* FIXME: attempt to test on Windows, stateless seems to break in this OS *)
let loops =
  if Sys.os_type = "Unix" then 1700000 else 170000

let does_collide ~stateless = does_collide_with loops @@ Cuid.generate ~stateless

let does_slug_collide ~stateless = does_collide_with loops @@ Cuid.slug ~stateless
