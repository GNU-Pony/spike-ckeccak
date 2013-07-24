# Copyright © 2013  Mattias Andrée (maandree@member.fsf.org)
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.
# 
# [GNU All Permissive License]


# NB!  Do not forget to test against -O0, -O4 to -O6 is not safe
CFLAGS=-Wall -Wextra -pedantic -O6
CPPFLAGS=
LDFLAGS=
C_FLAGS=$(CFLAGS) $(CPPFLAGS) $(LDFLAGS)



c: obj/sha3.o
obj/%.o: src/%.c src/%.h
	mkdir -p "obj"
	$(CC) $(C_FLAGS) -c -o "$@" "$<"


clean:
	-rm -r obj bin 2>/dev/null


.PHONY: clean c

