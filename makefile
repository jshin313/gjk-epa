# CC=clang
CC=gcc

CC_WEB=emcc
FLAGS_WEB=-s USE_SDL=2 -s USE_SDL_GFX=2 --bind -s WASM=1 -O3
WEBGENDIR=public/gen

CFLAGS=-I$(IDIR) -Wall -Wextra -fPIC
GJKEPAIDIR=src/gjk_epa
IDIR=src
SDIR=src
ODIR=obj
BINDIR=bin

LIBS=-lSDL2 -lSDL2_gfx

_GJKEPADEPS = vector.h gjk.h fixed_point.h epa.h error.h utils.h
GJKEPADEPS = $(patsubst %,$(GJKEPAIDIR)/%,$(_GJKEPADEPS))

_DEPS =  loop.h
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))

_OBJ = main.o utils.o loop.o vector.o gjk.o fixed_point.o epa.o error.o
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

$(ODIR)/%.o: $(GJKEPAIDIR)/%.c $(GJKEPADEPS)
	@mkdir -p $(@D)
	$(CC) -c -o $@ $< $(CFLAGS)

$(ODIR)/%.o: $(SDIR)/%.c $(DEPS)
	@mkdir -p $(@D)
	$(CC) -c -o $@ $< $(CFLAGS)


$(BINDIR)/main: $(OBJ)
	@mkdir -p $(@D)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

.PHONY: clean

clean:
	rm -rf $(ODIR) $(BINDIR) $(WEBGENDIR) *~ core

# WebASM version
wasm:
	@mkdir -p $(WEBGENDIR)
	$(CC_WEB) $(SDIR)/*.c $(GJKEPAIDIR)/*.c -o $(WEBGENDIR)/index.js $(FLAGS_WEB)

ti:
	make -f makefile.ti84pce
