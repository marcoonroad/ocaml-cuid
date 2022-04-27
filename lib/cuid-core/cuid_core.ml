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
    loop "" (abs number)

let padding size text =
  let pad = String.make size '0' in
  let padded_text = pad ^ text in
  let padded_text_length = String.length padded_text in
  String.sub padded_text (padded_text_length - size) size

let padding4 = padding 4

module type S = sig
  val __fields : unit -> string * string * string * string
  val generate : unit -> string
  val slug : unit -> string
end

module Make
  (Fingerprint : sig val value : string end)
  (Rng : sig val generate : int -> char array end) = struct
  let maximum = int_of_float (36.0 ** 4.0)
  let prefix  = "c"
  let state   = ref 0

  let call lambda = lambda ( )

  let timestamp ( ) =
    let timeofday =
      ( )
      |> Unix.gettimeofday
      |> ( *. ) 1000.
      |> Int64.of_float in
    let low = Int64.(rem timeofday (of_int maximum)) in
    let high = Int64.(div timeofday (of_int maximum)) in
    let low_base36 =
      low
      |> Int64.to_int
      |> base36
      |> padding4 in
    let high_base36 =
      high
      |> Int64.to_int
      |> base36
      |> padding4 in
    high_base36 ^ low_base36

  let counter ( ) =
    state := (if !state < maximum then !state else 0);
    incr state;
    !state
    |> pred
    |> base36
    |> padding4

  let rec greatest_common_divisor = function
    | (m, 0) -> m
    | (m, n) -> greatest_common_divisor (n, m mod n)

  let least_common_multiple (m, n) =
    (m * n) / greatest_common_divisor (m,  n)

  let pow b n =
    Int.(of_float ((to_float b) ** (to_float n)))

  let reduce_values base values_per_number values =
    let rec aux i acc =
      if i < 0 then acc else
        Array.sub values (i * values_per_number) values_per_number
        |> Array.fold_left ( fun acc value -> ( Char.code value ) + acc ) 0
        |> Fun.( flip ( mod ) ) base
        |> Int.( mul ( pow 36 i ) )
        |> Int.( add acc )
        |> aux ( i - 1 )
    in
    aux ((Array.length values) / values_per_number - 1) 0

  let random ( ) =
    let lcm = least_common_multiple (256, 36) in
    let values_per_number = lcm / 256 in
    4 * values_per_number
    |> Rng.generate
    |> reduce_values 36 values_per_number
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
end
