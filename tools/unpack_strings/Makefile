CC ?= gcc

CFLAGS = -Wall -Wextra -Werror -std=c11 -O2

SRCS = unpack_strings.c

ifeq ($(OS),Windows_NT)
EXE := .exe
else
EXE :=
endif

.PHONY: all clean

all: unpack_strings$(EXE)
	@:

unpack_strings$(EXE): $(SRCS)
	$(CC) $(CFLAGS) $(SRCS) -o $@ $(LDFLAGS)

clean:
	$(RM) unpack_strings unpack_strings.exe