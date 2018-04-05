let ( ) =
  let cuid = Cuid.generate ( ) in
  Lwt_main.run (Lwt_io.printl cuid)
