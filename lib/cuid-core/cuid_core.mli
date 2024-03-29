module type S = sig
  val __fields : unit -> string * string * string * string
  val generate : unit -> string
  val slug : unit -> string
end

val base36 : int -> string

val padding4 : string -> string

module Make
  (Fingerprint : sig val value : string end)
  (Rng: sig val generate : int -> char array end) : S
