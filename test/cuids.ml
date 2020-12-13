open Alcotest
open Test_utils

let __simple_case ( ) =
  let cuid = Cuid.generate ( ) in
  let slug = Cuid.slug ( ) in
  check bool "cuid differs from cuid slug" (cuid = slug) false

let __length_case ~stateless ( ) =
  let cuid   = Cuid.generate ~stateless ( ) in
  let length = String.length cuid in
  check int "cuid length must be 25" length 25;
  let (timestamp, counter, fingerprint, random) = Cuid.__fields ~stateless ( )
  in
  check int "timestamp block length must be 8"   (String.length timestamp)   8;
  check int "counter block length must be 4"     (String.length counter)     4;
  check int "fingerprint block length must be 4" (String.length fingerprint) 4;
  check int "random block length must be 8"      (String.length random)      8

let __slug_length ~stateless ( ) =
  let slug   = Cuid.slug ~stateless ( ) in
  let length = String.length slug in
  check int "cuid slug length must be 8" length 8

let __slug_base36_case ~stateless ( ) =
  let slug = Cuid.slug ~stateless ( ) in
  check bool "cuid must contain valid base36 chars" (is_base36 slug) true

let __base36_case ~stateless ( ) =
  let cuid   = Cuid.generate ~stateless ( ) in
  let prefix = String.get cuid 0 in
  check char "cuid must begin with c" prefix 'c';
  check bool "cuid must contain valid base36 chars" (is_base36 cuid) true

let __collision_case ~stateless ( ) =
  let first = Cuid.generate ~stateless ( ) in
  check bool "cuid must not collide" (does_collide ~stateless ( )) false;
  let last   = Cuid.generate ~stateless ( ) in
  check bool "cuid must be monotonically increasing" (first < last) true

let __collision_slug_case ~stateless ( ) =
  check bool "cuid must not collide" (does_slug_collide ~stateless ( )) true

let suite = [
  "simple case",                `Quick, __simple_case;
  "length",                     `Quick, __length_case         ~stateless:false;
  "length (stateless)",         `Quick, __length_case         ~stateless:true;
  "base36",                     `Quick, __base36_case         ~stateless:false;
  "base36 (stateless)",         `Quick, __base36_case         ~stateless:true;
  "slug length",                `Quick, __slug_length         ~stateless:false;
  "slug length (stateless)",    `Quick, __slug_length         ~stateless:true;
  "slug base36",                `Quick, __slug_base36_case    ~stateless:false;
  "slug base36 (stateless)",    `Quick, __slug_base36_case    ~stateless:true;
  "collision",                  `Slow,  __collision_case      ~stateless:false;
  "collision (stateless)",      `Slow,  __collision_case      ~stateless:true;
  "slug collision",             `Slow,  __collision_slug_case ~stateless:false;
  "slug collision (stateless)", `Slow,  __collision_slug_case ~stateless:true
]

let ( ) = run "CUID Tests" [
  "test suite", suite;
]
