CC ?= gcc

CFLAGS = -Wall -Wextra -Werror -std=c11 -O2

SRCS = pack_strings.c

ifeq ($(OS),Windows_NT)
EXE := .exe
else
EXE :=
endif

.PHONY: all clean

all: pack_strings$(EXE)
	@:

pack_strings$(EXE): $(SRCS)
	$(CC) $(CFLAGS) $(SRCS) -o $@ $(LDFLAGS)

clean:
	$(RM) pack_strings pack_strings.exe