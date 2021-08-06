usr_local ?= /usr/local

bindir = $(usr_local)/bin
libdir = $(usr_local)/lib

build:
	swift build -c release --disable-sandbox

install: build
	install ".build/release/cjc" "$(bindir)"
	install ".build/release/libSwiftSyntax.dylib" "$(libdir)"
	install_name_tool -change \
		".build/x86_64-apple-macosx/release/libSwiftSyntax.dylib" \
		"$(libdir)/libSwiftSyntax.dylib" \
		"$(bindir)/csc"

uninstall:
	rm -rf "$(bindir)/absolute-hsb"
	rm -rf "$(libdir)/libSwiftSyntax.dylib"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
