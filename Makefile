CC = cc -g
LEX = flex
YACC = bison
CFLAGS = -DYYDEBUG=1

cparser:	cparser.tab.o cparser.o
	${CC} -o $@ cparser.tab.o cparser.o

cparser.tab.c cparser.tab.h:	cparser.y
	${YACC} -vd cparser.y

cparser.c:	cparser.l
	${LEX} -o $@ $<

cparser.o:	cparser.c cparser.tab.h

clean:
	rm -f cparser cparser.tab.c cparser.tab.h cparser.c cparser.tab.o cparser.o 

.SUFFIXES:	.l .y .c

