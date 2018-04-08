cuid
====

CUID generator for OCaml.

[![Build Status](https://travis-ci.org/marcoonroad/ocaml-cuid.svg?branch=master)](https://travis-ci.org/marcoonroad/ocaml-cuid)
[![Coverage Status](https://coveralls.io/repos/github/marcoonroad/ocaml-cuid/badge.svg?branch=master)](https://coveralls.io/github/marcoonroad/ocaml-cuid?branch=master)

For further information, please refer to http://usecuid.org

### Installation

If available on OPAM, it's easily installed with:

```shell
$ opam install cuid
```

Otherwise, this library is also installable using
JBuilder within this root directory:

```shell
$ jbuilder install
```

### Usage

As library:

```ocaml
let cuid = Cuid.generate ( )
(* cuid is "c00p6veue0000072slgr067a3", for example *)
```

### Conclusion

PRs & issues are welcome. Have fun and imagine Sisyphus happy.
