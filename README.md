# cuid

CUID generator for OCaml.

<p>
<a target="_blank" class="badge-link" href="https://github.com/marcoonroad/ocaml-cuid/blob/stable/cuid.opam">
<img src="https://img.shields.io/static/v1?label=OCaml&message=%2Bv4.07.0&color=orange&style=flat-square&logo=ocaml" />
</a><span class="badge-separator"></span>
<a target="_blank" class="badge-link" href="https://github.com/marcoonroad/ocaml-cuid/actions?query=workflow%3A%22Ubuntu+CI+Workflow%22+branch%3Astable">
<img alt="Ubuntu Workflow Status" src="https://img.shields.io/github/workflow/status/marcoonroad/ocaml-cuid/Ubuntu%20CI%20Workflow/stable?label=Ubuntu&logo=github&style=flat-square" />
</a><span class="badge-separator"></span>
<a target="_blank" class="badge-link" href="https://github.com/marcoonroad/ocaml-cuid/actions?query=workflow%3A%22Windows+CI+Workflow%22+branch%3Astable">
<img alt="Windows Workflow Status" src="https://img.shields.io/github/workflow/status/marcoonroad/ocaml-cuid/Windows%20CI%20Workflow/stable?label=Windows&logo=github&style=flat-square" />
</a><span class="badge-separator"></span>
<a target="_blank" class="badge-link" href="https://github.com/marcoonroad/ocaml-cuid/actions?query=workflow%3A%22MacOS+CI+Workflow%22+branch%3Astable">
<img alt="MacOS Workflow Status" src="https://img.shields.io/github/workflow/status/marcoonroad/ocaml-cuid/MacOS%20CI%20Workflow/stable?label=MacOS&logo=github&style=flat-square" />
</a><span class="badge-separator"></span>
<a target="_blank" class="badge-link" href="https://github.com/marcoonroad/ocaml-cuid/blob/stable/LICENSE">
<img alt="Project License" src="https://img.shields.io/github/license/marcoonroad/ocaml-cuid?label=License&logo=github&style=flat-square" />
</a>
</p>

For further information, please refer to http://usecuid.org

### Installation

If available on OPAM, it's easily installed with:

```shell
$ opam install cuid
```

Otherwise, this library is also installable using
Dune within this root directory:

```shell
$ dune install
```

### Usage

As library:

```ocaml
let cuid = Cuid.generate ( )
(* cuid is "c00p6veue0000072slgr067a3", for example *)
```

There's also an implementation of CUID slugs. They fit in cases
where _collision-resistance is not important_ and when they are not
generated too frequently. For instance, we can use them as URL
suffixes for blog posts. To generate a CUID slug, just use:

```ocaml
let slug = Cuid.slug ( )
(* slug is "u90m0y0m", for example *)
```

A command-line tool is provided as well:

```shell
$ ocuidml
c00qla2yy5k6x07o8cmzz581r
$ ocuidml -slug
z1dw0ydw
$ ocuidml --slug # same as -slug
0enj0mnj
```

**Important:** Please note that the CLI utility uses a non-standard /
custom CUID stateless algorithm, which replaces the counter with the
remaining decimal part of the timestamp. This is just to make the CLI tool
portable on most platforms (i.e, Linux, Windows and MacOS). Also, the
fingerprint part of CUID will be different for every executable call
cause it depends on both hashed hostname and process ID. To comply
with this non-standard algorithm, both `Cuid.generate` and `Cuid.slug`
functions support a `~stateless:boolean` parameter/flag, which defaults
to `?(stateless=false)`.

### Conclusion

PRs & issues are welcome. Have fun and imagine Sisyphus happy.
