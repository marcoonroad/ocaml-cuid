open Alcotest
open Test_utils

let __length_case ( ) =
  let cuid   = Cuid_unix.generate ( ) in
  let length = String.length cuid in
  check int "cuid length must be 25" length 25;
  let (timestamp, counter, fingerprint, random) = Cuid_unix.__fields ( ) in
  check int "timestamp block length must be 8"    (String.length timestamp)  8;
  check int "counter block length must be 4"     (String.length counter)     4;
  check int "fingerprint block length must be 4" (String.length fingerprint) 4;
  check int "random block length must be 8"      (String.length random)      8

let __slug_length ( ) =
  let slug   = Cuid_unix.slug ( ) in
  let length = String.length slug in
  check int "cuid slug length must be 8" length 8

let __slug_base36_case ( ) =
  let slug = Cuid_unix.slug ( ) in
  check bool "cuid must contain valid base36 chars" (is_base36 slug) true

let __base36_case ( ) =
  let cuid   = Cuid_unix.generate ( ) in
  let prefix = String.get cuid 0 in
  check char "cuid must begin with c" prefix 'c';
  check bool "cuid must contain valid base36 chars" (is_base36 cuid) true

let __collision_case ( ) =
  let first = Cuid_unix.generate ( ) in
  check bool "cuid must not collide" (does_collide ( )) false;
  let last   = Cuid_unix.generate ( ) in
  check bool "cuid must be monotonically increasing" (first < last) true

let __collision_slug_case ( ) =
  check bool "cuid must not collide" (does_slug_collide ( )) true

let suite = [
  "length",         `Quick, __length_case;
  "base36",         `Quick, __base36_case;
  "slug length",    `Quick, __slug_length;
  "slug base36",    `Quick, __slug_base36_case;
  "collision",      `Slow,  __collision_case;
  "slug collision", `Slow,  __collision_slug_case
]

let ( ) = 
 (* Printf.printf "% %s %s" (Cuid_unix.generate ()) (Cuid_unix.generate ()) *)
 run "CUID Tests" [
  "test suite", suite;
]
