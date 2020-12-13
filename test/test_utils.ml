module Str = Re.Str

let __regexp = Str.regexp "^[a-z0-9]+$"

let is_base36 text =
  Str.string_match __regexp text 0

let does_collide_with iterations generator ( ) =
  let rec loop previous index =
    if index > iterations then false else
      let cuid = generator ( ) in
      if cuid > previous then
        loop cuid (index + 1)
      else
        true
  in
  loop (generator ( )) 1

let loops = 1700000

let does_collide ~stateless = does_collide_with loops @@ Cuid.generate ~stateless

let does_slug_collide ~stateless = does_collide_with loops @@ Cuid.slug ~stateless
