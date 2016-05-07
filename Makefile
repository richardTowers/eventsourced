build:
	stack build --pedantic

install: build
	stack install
