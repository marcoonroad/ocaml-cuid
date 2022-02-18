include Cuid.Make (struct
  let digest text   = Digest.to_hex (Digest.string text)

  let string_to_char_list string =
    let rec loop acc i = if i < 0 then acc else loop (string.[i] :: acc) (i - 1) in
    loop [] (String.length string - 1)

  let sum text =
    let number = text
    |> string_to_char_list
    |> List.map int_of_char
    |> List.fold_left (+) 0
    in number / (String.length text + 1)

  let value =
    let number = ( )
    |> Unix.gethostname
    |> digest
    |> sum
    in (number + Unix.getpid ( ))
    |> float_of_int
    |> Cuid.base36
    |> Cuid.padding4
end)
