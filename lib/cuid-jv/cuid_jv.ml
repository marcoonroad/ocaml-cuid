include Cuid.Make
  (struct
    open Brr

    let mime_types_length = match Jv.find (Jv.Id.to_jv G.navigator) "mimeTypes" with
      | Some a -> Jv.Jarray.length a
      | None -> 0

    let user_agent_length = match Jv.find (Jv.Id.to_jv G.navigator) "userAgent" with
      | Some ua -> ua |> Jv.to_jstr |> Jstr.length
      | None -> 0 

    let variables_in_global_scope =
      let o = Jv.get Jv.global "Object" in
      let a = Jv.call o "keys" Jv.[| (Id.to_jv G.window) |] in
      Jv.Jarray.length a

    let value =
      let id1 = Cuid.base36 (mime_types_length + user_agent_length) in
      let id2 = Cuid.base36 variables_in_global_scope in
      Cuid.padding4 id1 ^ id2
  end)
  (struct
    open Brr

    let crypto = Jv.find Jv.global "crypto"
    let random = Jv.get (Jv.get Jv.global "Math") "random"

    let generate n =
      match crypto with 
        | Some crypto -> Array.init n (fun _i ->
              Jv.call crypto "getRandomValues" Tarray.[| to_jv (create Uint8 1) |]
              |> Jv.to_int
              |> Char.chr)
        | None -> Array.init n (fun _i ->
              (Jv.to_float (Jv.apply random [| |])) *. 256.0
              |> Int.of_float
              |> Char.chr)
  end)

