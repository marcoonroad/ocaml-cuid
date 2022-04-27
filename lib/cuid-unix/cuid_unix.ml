include Cuid_core.Make
  (struct
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
      |> Cuid_core.base36
      |> Cuid_core.padding4
  end)
  (struct
    let ( ) = Mirage_crypto_rng_unix.initialize ( )

    let generate n =
      let block = Mirage_crypto_rng.generate n in
      Array.init n (fun i -> Cstruct.get_char block i)
  end)
