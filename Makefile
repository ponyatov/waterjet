# var
MODULE = $(notdir $(CURDIR))
REL    = $(shell git rev-parse --short=4    HEAD)
BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
NOW    = $(shell date +%d%m%y)

# cross
TARGET = i686-pc-windows-gnu

# dir
CWD = $(CURDIR)
CAR = $(HOME)/.cargo/bin

# tool
CURL   = curl -L -o
RUSTUP = $(CAR)/rustup
CARGO  = $(CAR)/cargo
GITREF = git clone --depth 1

# src
R += $(wildcard src/*.rs)

# all
.PHONY: run all
all: bin/$(MODULE)
run: lib/$(MODULE).ini $(R)
	$(CARGO) run -- $<
# RUST_BACKTRACE=1

# format
.PHONY: format
format: tmp/format_rs
tmp/format_rs: $(R)
	$(CARGO) check && $(CARGO) fmt && touch $@

# doc
.PHONY: doc
doc: doc/The_Rust_Programming_Language.pdf

doc/The_Rust_Programming_Language.pdf: $(HOME)/doc/Rust/The_Rust_Programming_Language.pdf
	cd doc ; ln -fs ../../doc/Rust/The_Rust_Programming_Language.pdf The_Rust_Programming_Language.pdf
$(HOME)/doc/Rust/The_Rust_Programming_Language.pdf:
	$(CURL) $@ https://www.scs.stanford.edu/~zyedidia/docs/rust/rust_book.pdf

# install
.PHONY: install update ref gz
install: doc ref gz
	sudo dpkg --add-architecture i386
	$(MAKE) update rust
update: $(RUSTUP)
	sudo apt update
	sudo apt install -uy `cat apt.txt`
	$(RUSTUP) self update ; $(RUSTUP) update
ref:
gz:

.PHONY: rust
rust: $(RUSTUP)
	$(RUSTUP) component add rustfmt
	$(RUSTUP) target add $(TARGET)
$(RUSTUP):
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
