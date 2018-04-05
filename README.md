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
(* cuid is "c5ac5a1090000297bd8e9678a", for example *)
```

As command-line tool:

```shell
$ ocuidml
c5ac5a0a100001b8597527a68
```

### Conclusion

PRs & issues are welcome. Have fun and imagine Sisyphus happy.
