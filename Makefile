.PHONY: build clean test doc

all: build

# boot should install the opam tool as well

update-vendor:
		opam update            --yes
		opam upgrade jbuilder  --yes
		opam upgrade core      --yes
		opam upgrade cryptokit --yes
		opam upgrade alcotest  --yes
		opam upgrade odoc      --yes
		opam upgrade odig      --yes
		opam upgrade re        --yes

vendor:
		opam install jbuilder  --yes
		opam install core      --yes
		opam install cryptokit --yes
		opam install alcotest  --yes
		opam install odoc      --yes
		opam install odig      --yes
		opam install re        --yes

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

clean: cleanup
		jbuilder clean

install: build
		jbuilder install

uninstall:
		jbuilder uninstall

# END
