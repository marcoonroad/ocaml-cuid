let alphabet = [
  "0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9";
  "a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"; "k"; "l"; "m";
  "n"; "o"; "p"; "q"; "r"; "s"; "t"; "u"; "v"; "w"; "x"; "y"; "z"
]

let base36 number =
  let rec loop result number =
    if number <= 0 then result else
      let index   = number mod 36 in
      let number' = number / 36 in
      let digit   = List.nth alphabet index in
      let result' = digit ^ result in
      loop result' number' in
    loop "" (Int.abs number)

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

module type S = sig
  val __fields : unit -> string * string * string * string
  val generate : unit -> string
  val slug : unit -> string
end

module Make (Fingerprint : sig
  val value : string
end) = struct
  let maximum = int_of_float (36.0 ** 4.0)
  let prefix  = "c"
  let state   = ref 0

  let call   lambda = lambda ( )

  let timestamp ( ) =
    ( )
    |> Unix.gettimeofday
    |> ( *. ) 1000.
    |> int_of_float
    |> base36
    |> padding8

  let counter ( ) =
    state := (if !state < maximum then !state else 0);
    incr state;
    !state
    |> pred
    |> base36
    |> padding4

  let random ( ) =
    maximum
    |> Random.int
    |> base36
    |> padding4

  let __fields ( ) =
    (call timestamp),
    (call counter),
    Fingerprint.value,
    (call random ^ call random)

  let generate ( ) =
    prefix ^
    (call timestamp) ^ (call counter) ^
    Fingerprint.value ^
    (call random) ^ (call random)

  let fingerprint_slug =
    let length = String.length Fingerprint.value in
    String.sub Fingerprint.value 0 1 ^
    String.sub Fingerprint.value (length - 1) 1

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
end
