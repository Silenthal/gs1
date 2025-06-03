CC ?= gcc

CFLAGS = -Wall -Wextra -Werror -std=c11 -O2 -D_POSIX_C_SOURCE=1

SRCS = unpack_overlay.c

ifeq ($(OS),Windows_NT)
EXE := .exe
else
EXE :=
endif

.PHONY: all clean

all: unpack_overlay$(EXE)
	@:

unpack_overlay$(EXE): $(SRCS)
	$(CC) $(CFLAGS) $(SRCS) -o $@ $(LDFLAGS)

clean:
	$(RM) unpack_overlay unpack_overlay.exe