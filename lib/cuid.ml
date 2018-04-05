let maximum = int_of_float (36.0 ** 4.0)
let prefix  = "c"
let state   = ref 0

let call        lambda = lambda ( )
let hexadecimal number = Printf.sprintf "%.08x" number
let padding4    text   = String.sub text 4 4
let digest      text   = Digest.to_hex (Digest.string text)

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
  |> hexadecimal

let counter ( ) =
  state := (if !state < maximum then !state else 0);
  incr state;
  !state
  |> pred
  |> hexadecimal
  |> padding4

let fingerprint ( ) =
  let number = ( )
  |> Unix.gethostname
  |> digest
  |> sum
  in (number + Unix.getpid ( ))
  |> hexadecimal
  |> padding4

let random ( ) =
  maximum
  |> Core.Random.int
  |> hexadecimal
  |> padding4

let generate ( ) =
  prefix ^
  (call timestamp) ^ (call counter) ^
  (call fingerprint) ^
  (call random) ^ (call random)

let _ =
  Core.Random.self_init ( )
