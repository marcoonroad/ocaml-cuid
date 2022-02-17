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
  |> Float.floor
  |> int_of_float

let string_to_char_list string =
  let rec loop acc i = if i < 0 then acc else loop (string.[i] :: acc) (i - 1) in
  loop [] (String.length string - 1)

let rec loop result number =
  if number <= 0. then result else
    let index   = Float.rem number 36. in
    let number' = number /. 36. in
    let digit   = List.nth alphabet (floor_to_int index) in
    let result' = digit ^ result in
    loop result' number'

let base36 number =
  let number' = Float.abs number in
  if number' < 36. then
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
  let length   = String.length adjusted in
  let offset   = length - count in
  String.sub adjusted offset count

let padding4 = padding 8 4
let padding8 = padding 8 8

let call   lambda = lambda ( )
let digest text   = Digest.to_hex (Digest.string text)

let sum text =
  let number = text
  |> string_to_char_list
  |> List.map int_of_char
  |> List.fold_left (+) 0
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

let random ( ) =
  maximum
  |> Random.int
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
  let length = String.length fingerprint in
  String.sub fingerprint 0 1 ^
  String.sub fingerprint (length - 1) 1

let slug ( ) =
  let timestamp' = call timestamp in
  let counter' = call counter in
  let random' = call random in
  let timestamp'_length = String.length timestamp' in
  let counter'_length = String.length counter' in
  let random'_length = String.length random' in
  String.sub timestamp' (timestamp'_length - 2) 2 ^
  String.sub counter' (counter'_length - 2) 2 ^
  fingerprint_slug ^
  String.sub counter' (random'_length - 2) 2

let _ =
  Random.self_init ( )
