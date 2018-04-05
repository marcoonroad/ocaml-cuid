# .PHONY: build clean test doc

all: build

# boot should install the opam tool as well

update-vendor:
		opam update             --yes
		opam upgrade jbuilder   --yes
		opam upgrade core       --yes
		opam upgrade alcotest   --yes
		opam upgrade odoc       --yes
		opam upgrade odig       --yes
		opam upgrade re         --yes
		opam upgrade bisect_ppx --yes
		opam upgrade ocveralls  --yes

vendor:
		opam install jbuilder   --yes
		opam install core       --yes
		opam install alcotest   --yes
		opam install odoc       --yes
		opam install odig       --yes
		opam install re         --yes
		opam install bisect_ppx --yes
		opam install ocveralls  --yes

build:
		jbuilder build --dev

test: build
		jbuilder runtest --dev

doc: build
		jbuilder build @doc

cleanup:
		rm -fv *~
		rm -fv lib/*~
		rm -fv lib_test/*~
		rm -fv .*.un~
		rm -fv lib/.*.un~
		rm -fv lib_test/.*.un~
		rm -f `find . -name 'bisect*.out'`

.PHONY: clean
clean: cleanup
		jbuilder clean

install: build
		jbuilder install

uninstall:
		jbuilder uninstall

.PHONY: coverage
coverage: clean
	BISECT_ENABLE=YES jbuilder runtest --dev
	bisect-ppx-report -I _build/default/ -text - `find . -name 'bisect*.out'`

.PHONY: report
report: coverage
	ocveralls --prefix '_build/default' `find . -name 'bisect*.out'` --send

# END
