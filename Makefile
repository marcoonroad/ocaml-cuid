# .PHONY: build clean test doc

all: build

# boot should install the opam tool as well

.PHONY: pin
pin:
	@ opam pin add cuid . -n --yes --working-dir

.PHONY: unpin
unpin:
	@ opam pin remove cuid --yes --working-dir

.PHONY: vendor
vendor:
	@ opam install . --deps-only --yes

.PHONY: vendor-test
vendor-test:
	@ opam install . --deps-only --with-test --yes

.PHONY: utop
utop:
	@ opam exec dune utop lib/cuid

build:
	@ opam exec dune build

test: clean build
	@ opam exec dune build @runtest

quick-test: clean build
	@ ALCOTEST_QUICK_TESTS=1 opam exec dune build @runtest

doc: build
	@ opam exec dune build @doc

.PHONY: cleanup
cleanup:
	@ rm -fv *~
	@ rm -fv lib/*~
	@ rm -fv lib_test/*~
	@ rm -fv .*.un~
	@ rm -fv lib/.*.un~
	@ rm -fv lib_test/.*.un~
	@ rm -f `find . -name 'bisect*.out'`
	@ find . -name '*.coverage' | xargs rm -f

.PHONY: clean
clean: cleanup
	@ opam exec dune clean

install: build
	@ opam exec dune build @install
	@ opam exec dune install cuid

uninstall:
	@ opam exec dune uninstall cuid

.PHONY: coverage
coverage: clean vendor
	@ dune runtest --instrument-with bisect_ppx --force
	@ opam exec bisect-ppx-report summary --verbose
	

.PHONY: report
report: coverage
	@ opam exec bisect-ppx-report send-to Coveralls

# END
