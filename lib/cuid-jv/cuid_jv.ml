include Cuid.Make (struct
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
