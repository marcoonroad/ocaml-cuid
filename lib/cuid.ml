let maximum = int_of_float (36.0 ** 4.0)
let prefix  = "c"
let state   = ref 0

let alphabet = [
  "0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9";
  "a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"; "k"; "l"; "m";
  "n"; "o"; "p"; "q"; "r"; "s"; "t"; "u"; "v"; "w"; "x"; "y"; "z"
]

let floor_to_int number =
  number
  |> Base.Float.round_down
  |> int_of_float

let rec loop result number =
  if number <= 0. then result else
    let index   = Base.Float.mod_float number 36. in
    let number' = Base.Float.(number / 36.) in
    let digit   = List.nth alphabet (floor_to_int index) in
    let result' = digit ^ result in
    loop result' number'

let base36 number =
  let number' = Base.Float.abs number in
  if Base.Float.(number' < 36.) then
    List.nth alphabet (floor_to_int number')
  else
    loop "" number'

let adjust fill text =
  let length = String.length text in
  let size   = max 0 (fill - length) in
  let buffer = String.make size '0' in
  buffer ^ text

let padding fill count text =
  let adjusted = adjust fill text in
  let length   = Base.String.length adjusted in
  let offset   = length - count in
  Base.String.sub adjusted ~pos:offset ~len:count

let padding4 = padding 8 4
let padding8 = padding 8 8

let call   lambda = lambda ( )
let digest text   = Digest.to_hex (Digest.string text)

let sum text =
  let number = text
  |> Base.String.to_list
  |> (Base.List.map ~f:int_of_char)
  |> (Base.List.fold_left ~init:0 ~f:(+))
  in number / (String.length text + 1)

let timestamp ( ) =
  ( )
  |> Unix.time
  |> base36
  |> padding8

let counter ( ) =
  state := (if !state < maximum then !state else 0);
  incr state;
  !state
  |> pred
  |> float_of_int
  |> base36
  |> padding4

let fingerprint =
  let number = ( )
  |> Unix.gethostname
  |> digest
  |> sum
  in (number + Unix.getpid ( ))
  |> float_of_int
  |> base36
  |> padding4

let __sum_then_mod ~basis blob =
  let length = Cstruct.len blob in
  let rec loop index sum =
    if index = length then sum else
    loop (index + 1) (sum + Cstruct.get_uint8 blob index)
  in
  loop 0 0 mod basis

(* generates a number lower than 36^4, never zero for entropy reasons *)
let __generate_random () =
  (* 2304 is the common multiple for both 256 (byte) & 36 (base), ensures fair randomness *)
  let blob = Mirage_crypto_rng.generate 36 in
  let fst = Cstruct.sub blob  0 9 |> __sum_then_mod ~basis:36 in
  let snd = Cstruct.sub blob  9 9 |> __sum_then_mod ~basis:36 in
  let trd = Cstruct.sub blob 18 9 |> __sum_then_mod ~basis:36 in
  let fth = Cstruct.sub blob 27 9 |> __sum_then_mod ~basis:36 in
  let res = ((fst + 1) * (snd + 1) * (trd + 1) * (fth + 1)) - 1 in
  max 1 res

let random ( ) =
  __generate_random ()
  |> float_of_int
  |> base36
  |> padding4

let __fields ( ) =
  (call timestamp),
  (call counter),
  fingerprint,
  (call random ^ call random)

let generate ( ) =
  prefix ^
  (call timestamp) ^ (call counter) ^
  fingerprint ^
  (call random) ^ (call random)

let fingerprint_slug =
  let length = Base.String.length fingerprint in
  Base.String.sub ~pos:0 ~len:1 fingerprint ^
  Base.String.sub ~pos:(length - 1) ~len:1 fingerprint

let slug ( ) =
  let timestamp' = call timestamp in
  let counter' = call counter in
  let random' = call random in
  let timestamp'_length = Base.String.length timestamp' in
  let counter'_length = Base.String.length counter' in
  let random'_length = Base.String.length random' in
  Base.String.sub ~pos:(timestamp'_length - 2) ~len:2 timestamp' ^
  Base.String.sub ~pos:(counter'_length - 2) ~len:2 counter' ^
  fingerprint_slug ^
  Base.String.sub ~pos:(random'_length - 2) ~len:2 counter'

let _ =
  Mirage_crypto_rng_unix.initialize ( )
