# Copyright © 2013  Mattias Andrée (maandree@member.fsf.org)
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.
# 
# [GNU All Permissive License]


# NB!  Do not forget to test against -O0, -O4 to -O6 is not safe
OPTIMISATION=-O6

CFLAGS = -Wall -Wextra -pedantic $(OPTIMISATION)
CPPFLAGS =
LDFLAGS =
C_FLAGS = $(CFLAGS) $(CPPFLAGS) $(LDFLAGS)

SPIKE = $${SPIKE_PATH}
OPT = $(SPIKE)/add-on
OPTBIN = $(OPT)/libexec

PREFIX = /usr
DATA = /share
LICENSES = $(DATA)/licenses
PKGNAME = spike-ckeccak

CHECKFILE = LICENSE
CHECKHASH = 493411C4AE0C731998D8D46EF70938F71AF826E024545020628A995B074BA8FA1CFE704C5BB891C0303685A7A6C20E10FB48C8F14F7A5F1959CAF4C664DE4EF5EDBE3DC796E0CD73


all: c

c: bin/spike-ckeccak

bin/spike-ckeccak: obj/sha3.o obj/mane.o
	@mkdir -p "bin"
	$(CC) $(C_FLAGS) -o "$@" $^

obj/%.o: src/%.c src/%.h
	@mkdir -p "obj"
	$(CC) $(C_FLAGS) -c -o "$@" "$<"


check: bin/spike-ckeccak
	@[ $$(bin/spike-ckeccak $(CHECKFILE)) = $(CHECKHASH) ] && echo 'sha3sum test pass for file: $(CHECKFILE)'


install: bin/spike-ckeccak
	install -d -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"
	install -m644 -- COPYING LICENSE "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"
	install -d -- "$(DESTDIR)$(OPT)"
	install -m755 -- src/spike-ckeccak.py "$(DESTDIR)$(OPT)"
	install -d -- "$(DESTDIR)$(OPTBIN)"
	install -m755 -- bin/spike-ckeccak "$(DESTDIR)$(OPTBIN)"


uninstall:
	-rm -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"/COPYING
	-rm -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"/LICENSE
	-rmdir -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(OPTBIN)"
	-rmdir -- "$(DESTDIR)$(OPTBIN)"/spike-ckeccak
	-rm -- "$(DESTDIR)$(OPT)"/spike-ckeccak.py
	-rmdir -- "$(DESTDIR)$(OPT)"


clean:
	-rm -r obj bin 2>/dev/null


.PHONY: all c check install uninstall clean

