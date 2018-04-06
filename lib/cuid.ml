let maximum = int_of_float (36.0 ** 4.0)
let prefix  = "c"
let state   = ref 0

let alphabet = [
  "0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9";
  "a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"; "k"; "l"; "m";
  "n"; "o"; "p"; "q"; "r"; "s"; "t"; "u"; "v"; "w"; "x"; "y"; "z"
]

let rec loop result number =
  if number <= 0 then result else
    let index   = number mod 36 in
    let number' = number / 36 in
    let digit   = List.nth alphabet index in
    let result' = digit ^ result in
    loop result' number'

let base36 number =
  let number' = abs number in
  if number' < 36 then
    List.nth alphabet number'
  else
    loop "" number'

let adjust8 text =
    let length = String.length text in
    try
      let buffer = String.make (8 - length) '0' in
      buffer ^ text
    with _ -> Core.String.sub text ~pos:(length - 8) ~len:8

let call     lambda = lambda ( )
let padding4 text   = Core.String.sub text ~pos:4 ~len:4
let digest   text   = Digest.to_hex (Digest.string text)

let sum text =
  let number = text
  |> Core.String.to_list
  |> (Core.List.map ~f:int_of_char)
  |> (Core.List.fold_left ~init:0 ~f:(+))
  in number / (String.length text + 1)

let timestamp ( ) =
  ( )
  |> Unix.gettimeofday
  |> int_of_float
  |> base36
  |> adjust8

let counter ( ) =
  state := (if !state < maximum then !state else 0);
  incr state;
  !state
  |> pred
  |> base36
  |> adjust8
  |> padding4

let fingerprint =
  let number = ( )
  |> Unix.gethostname
  |> digest
  |> sum
  in (number + Unix.getpid ( ))
  |> base36
  |> adjust8
  |> padding4

let random ( ) =
  maximum
  |> Core.Random.int
  |> base36
  |> adjust8
  |> padding4

let generate ( ) =
  prefix ^
  (call timestamp) ^ (call counter) ^
  fingerprint ^
  (call random) ^ (call random)

let _ =
  Core.Random.self_init ( )
