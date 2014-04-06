CC=g++
LINKER=g++
CFLAGS= -std=c++11 -Wall
LDFLAGS=

BINDIR=bin
OBJDIR=obj
SRCDIR=src
GENDIR=gen
OUT=cinrollc

OUTPREFIX=
OUTPOSTFIX=
OBJPOSTFIX=
SRCPOSTFIX=.cpp
HDRPOSTFIX=.hpp

ifeq ($(OS),Windows_NT)
	OUTPOSTFIX=.exe
	OBJPOSTFIX=.obj
else
	UNAME_S := $(shell uname -s)
	ifneq "$(or ($(UNAME_S),Linux),($(UNAME_S),Darwin))" ""
		OBJPOSTFIX=.o
	endif
endif

vpath %$(SRCPOSTFIX) $(SRCDIR)
vpath %$(SRCPOSTFIX) $(GENDIR)

rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

SOURCES=$(call rwildcard,./$(SRCDIR),*$(SRCPOSTFIX))
SOURCES_GEN=./$(GENDIR)/lang_tokens$(SRCPOSTFIX) ./$(GENDIR)/lang_rules$(SRCPOSTFIX)
OBJECTS=$(SOURCES:./$(SRCDIR)/%$(SRCPOSTFIX)=$(OBJDIR)/%$(OBJPOSTFIX)) $(SOURCES_GEN:./$(GENDIR)/%$(SRCPOSTFIX)=$(OBJDIR)/%$(OBJPOSTFIX)) 

all: CFLAGS+= -O3
all: generate $(OUT)

debug: CFLAGS+= -g -ftrapv -Wundef -Wpointer-arith -Wcast-align -Wwrite-strings -Wcast-qual -Wswitch-default -Wunreachable-code -Wfloat-equal -Wuninitialized -Wignored-qualifiers -Wsuggest-attribute=pure -Wsuggest-attribute=const
debug: generate $(OUT)

clean:
	$(RM) -rf $(GENDIR)/* $(OBJECTS) $(BINDIR)/$(OUT)

run:
	./$(BINDIR)/$(OUT)

$(GENDIR)/lang_rules$(SRCPOSTFIX): $(SRCDIR)/lang_rules.y
	$(OUTPREFIX)bison$(OUTPOSTFIX) -v --warnings=all -d -o $@ $^

$(GENDIR)/lang_rules.hpp: $(GENDIR)/lang_rules$(SRCPOSTFIX)

$(GENDIR)/lang_tokens$(SRCPOSTFIX): $(SRCDIR)/lang_tokens.l $(GENDIR)/lang_rules.hpp
	$(OUTPREFIX)flex$(OUTPOSTFIX) -o $@ $^

$(OBJDIR)/%$(OBJPOSTFIX): %$(SRCPOSTFIX)
	$(CC) -I$(SRCDIR) -I$(GENDIR) $(CFLAGS) -o $@ -c $<

generate: $(GENDIR)/lang_rules.hpp $(GENDIR)/lang_tokens$(SRCPOSTFIX)

$(OUT): $(OBJECTS)
	$(LINKER) $^ -o $(BINDIR)/$(OUTPREFIX)$@$(OUTPOSTFIX) $(LDFLAGS)
