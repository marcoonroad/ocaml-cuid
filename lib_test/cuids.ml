open Alcotest
open Test_utils

let __length_case ( ) =
  let cuid   = Cuid.generate ( ) in
  let length = String.length cuid in
  check int "cuid length must be 25" length 25

let __hexadecimal_case ( ) =
  let cuid   = Cuid.generate ( ) in
  let prefix = String.get cuid 0 in
  check char "cuid must begin with c" prefix 'c';
  check bool "cuid must contain valid hex chars" (is_hexadecimal cuid) true

let __collision_case ( ) =
  check bool "cuid must not collide" (does_collide ( )) false

let suite = [
  "length",      `Quick, __length_case;
  "hexadecimal", `Quick, __hexadecimal_case;
  "collision",   `Slow,  __collision_case
]

let ( ) = run "CUID Tests" [
  "test suite", suite;
]
