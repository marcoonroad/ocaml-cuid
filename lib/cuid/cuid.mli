module type S = sig
  val __fields : unit -> string * string * string * string
  val generate : unit -> string
  val slug : unit -> string
end

val base36 : float -> string

val padding4 : string -> string

val padding8 : string -> string

module Make (Fingerprint : sig val value : string end) : S

