CC=gcc
CFLAGS=-ggdb -Wall -Ivm --std=gnu11
OBJS=
TARGETS=SportS

all: clean $(TARGETS)

%: %.lex.o %.tab.o $(OBJS) vm3/libvm3.a
	$(CC) -o $@ $^

%.tab.o: %.tab.c %.tab.h
	$(CC) -c $(CFLAGS) $< -o $@

%.lex.o: %.lex.c %.tab.h
	$(CC) -c $(CFLAGS) $< -o $@

%.tab.c %.tab.h: %.y
	bison --defines -t $^

%.lex.c: %.l
	flex -o $@ $^

vm3/libvm3.a:
	make -C vm

clean:
	make -C vm clean
	rm -f *.lex.* *.tab.* *.o $(TARGETS) *.vm3

.PHONY: vm3/libvm3.a

.PRECIOUS: SportS.tab.h