# Copyright © 2013  Mattias Andrée (maandree@member.fsf.org)
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.
# 
# [GNU All Permissive License]


OPTIMISATION=-Ofast

WARN = -Wall -Wextra -pedantic -Wdouble-promotion -Wformat=2 -Winit-self -Wmissing-include-dirs  \
       -Wtrampolines -Wfloat-equal -Wshadow -Wmissing-prototypes -Wmissing-declarations          \
       -Wredundant-decls -Wnested-externs -Wno-variadic-macros -Wsync-nand                       \
       -Wunsafe-loop-optimizations -Wcast-align -Wstrict-overflow -Wdeclaration-after-statement  \
       -Wundef -Wbad-function-cast -Wcast-qual -Wwrite-strings -Wlogical-op -Waggregate-return   \
       -Wstrict-prototypes -Wold-style-definition -Wpacked -Wvector-operation-performance        \
       -Wunsuffixed-float-constants -Wsuggest-attribute=const -Wsuggest-attribute=noreturn       \
       -Wsuggest-attribute=pure -Wsuggest-attribute=format -Wnormalized=nfkc -Wconversion        \
       -fstrict-aliasing -fstrict-overflow -fipa-pure-const -ftree-vrp -fstack-usage             \
       -funsafe-loop-optimizations

CFLAGS =
CPPFLAGS =
LDFLAGS =
C_FLAGS = $(WARN) $(OPTIMISATION) -std=c99 $(CFLAGS) $(CPPFLAGS) $(LDFLAGS)

SPIKE = $${SPIKE_PATH}
OPT = $(SPIKE)/add-on
OPTBIN = $(OPT)/libexec

PREFIX = /usr
DATA = /share
LICENSES = $(DATA)/licenses
PKGNAME = spike-ckeccak

CHECKFILE = LICENSE
CHECKHASH = 493411C4AE0C731998D8D46EF70938F71AF826E024545020628A995B074BA8FA1CFE704C5BB891C0303685A7A6C20E10FB48C8F14F7A5F1959CAF4C664DE4EF5EDBE3DC796E0CD73

TEMPFILE = /tmp/devel-spike-ckeccak-benchmark-testfile
BENCHMARK_SIZE = 100


.PHONY: all
all: c

.PHONY: c
c: bin/spike-ckeccak

bin/spike-ckeccak: obj/sha3.o obj/mane.o
	@mkdir -p "bin"
	$(CC) $(C_FLAGS) -o "$@" $^

obj/mane.o: src/sha3.h
obj/%.o: src/%.c src/%.h
	@mkdir -p "obj"
	$(CC) $(C_FLAGS) -c -o "$@" "$<"


.PHONY: check
check: bin/spike-ckeccak
	@[ $$(bin/spike-ckeccak $(CHECKFILE)) = $(CHECKHASH) ] && echo 'sha3sum test pass for file: $(CHECKFILE)'


.PHONY: install
install: bin/spike-ckeccak
	install -d -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"
	install -m644 -- COPYING LICENSE "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"
	install -d -- "$(DESTDIR)$(OPT)"
	install -m755 -- src/spike-ckeccak.py "$(DESTDIR)$(OPT)"
	install -d -- "$(DESTDIR)$(OPTBIN)"
	install -m755 -- bin/spike-ckeccak "$(DESTDIR)$(OPTBIN)"


.PHONY: uninstall
uninstall:
	-rm -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"/COPYING
	-rm -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"/LICENSE
	-rmdir -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(OPTBIN)"
	-rmdir -- "$(DESTDIR)$(OPTBIN)"/spike-ckeccak
	-rm -- "$(DESTDIR)$(OPT)"/spike-ckeccak.py
	-rmdir -- "$(DESTDIR)$(OPT)"


.PHONY: benchmark
benchmark: bin/spike-ckeccak
	@echo 'Generating test file ($(BENCHMARK_SIZE) MB)'
	@dd if=/dev/zero bs=1048576 count=$(BENCHMARK_SIZE) > "$(TEMPFILE)" 2>/dev/null
	@echo 'Running test'
	@time bin/spike-ckeccak "$(TEMPFILE)" >/dev/null
	@echo 'Cleaning up'
	@rm "$(TEMPFILE)"


.PHONY: clean
clean:
	-rm -r obj bin 2>/dev/null

