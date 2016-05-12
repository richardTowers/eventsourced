.PHONY : build test install

build:
	stack build --pedantic

test:
	stack test --pedantic

install: build
	stack install

clean:
	stack clean
