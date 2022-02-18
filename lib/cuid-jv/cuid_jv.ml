module Jv = Cuid.Make (struct
  open Brr

  let mime_types_length = match Jv.find (Jv.Id.to_jv G.navigator) "mimeTypes" with
    | Some n -> Jv.to_int n
    | None -> 0

  let user_agent_length = match Jv.find (Jv.Id.to_jv G.navigator) "userAgent" with
    | Some ua -> ua |> Jv.to_jstr |> Jstr.length
    | None -> 0 

  let variables_in_global_scope =
    let o = Jv.get Jv.global "Object" in
    let k = Jv.call o "keys" Jv.[| (Id.to_jv G.window) |] in
    Jv.Jarray.length k

  let value =
    let id1 =
      (mime_types_length + user_agent_length)
      |> float_of_int
      |> Cuid.base36 in
    let id2 =
      variables_in_global_scope
      |> float_of_int
      |> Cuid.base36 in
    Cuid.padding4 id1 ^ id2
end)
