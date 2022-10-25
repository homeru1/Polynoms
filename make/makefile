all: bison flex start

bison:
	win_bison.exe -d -y -v ..\main\polynoms.y
flex:
	win_flex.exe ..\main\polynoms.l
	gcc y.tab.c lex.yy.c -o ..\polynoms -lm
clear:
	del y.tab.c
	del y.tab.h
	del lex.yy.c
	del y.output
	del ..\polynoms.exe
	del ..\output.txt
start:
	..\polynoms.exe ..\test.txt
