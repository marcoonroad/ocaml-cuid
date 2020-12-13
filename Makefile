# .PHONY: build clean test doc

all: build

# boot should install the opam tool as well

.PHONY: pin
pin:
	@ opam pin add cuid . -n --yes

.PHONY: unpin
unpin:
	@ opam pin remove cuid --yes

.PHONY: vendor
vendor:
	@ opam install . --deps-only --yes

.PHONY: utop
utop:
	@ dune utop lib

build:
	@ dune build

test: clean build
	@ dune runtest

quick-test: clean build
	@ ALCOTEST_QUICK_TESTS=1 dune runtest

doc: build
	@ dune build @doc

.PHONY: cleanup
cleanup:
	@ rm -fv *~
	@ rm -fv lib/*~
	@ rm -fv lib_test/*~
	@ rm -fv .*.un~
	@ rm -fv lib/.*.un~
	@ rm -fv lib_test/.*.un~
	@ rm -f `find . -name 'bisect*.out'`

.PHONY: clean
clean: cleanup
	@ dune clean

install: build
	@ dune install

uninstall:
	@ dune uninstall

.PHONY: coverage
coverage: clean vendor
	@ BISECT_ENABLE=YES dune runtest --force
	@ bisect-ppx-report -title ocaml-cuid -I _build/default/ -tab-size 2 \
		-html coverage/ `find . -name 'bisect*.out'`
	@ bisect-ppx-report -I _build/default/ -text - `find . -name 'bisect*.out'`

.PHONY: report
report: coverage
	@ bisect-ppx-report send-to Coveralls

# END
