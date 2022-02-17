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

.PHONY: vendor-test
vendor-test:
	@ opam install . --deps-only --with-test --yes

.PHONY: utop
utop:
	@ opam exec dune utop lib

build:
	@ opam exec dune build

test: clean build
	@ opam exec dune runtest

quick-test: clean build
	@ ALCOTEST_QUICK_TESTS=1 opam exec dune runtest

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

.PHONY: clean
clean: cleanup
	@ opam exec dune clean

install: build
	@ opam exec dune install

uninstall:
	@ opam exec dune uninstall

.PHONY: coverage
coverage: clean vendor
	@ BISECT_ENABLE=YES opam exec dune runtest
	@ opam exec bisect-ppx-report -I _build/default/ -text - `find . -name 'bisect*.out'`

.PHONY: report
report: coverage
	@ opam exec bisect-ppx-report send-to Coveralls

# END
