%option yylineno

%{
	#include<stdio.h>
	#include"y.tab.h"
	#include<math.h>
	#include <string.h>
	extern int yyerror(const char *);
%}
%option noyywrap

%%
"print"					{									 							printf("print "); return t_print;}
":="					{									 							printf(":= ");return t_short_assignment;}
0|([1-9][0-9]*)			{yylval.number = atoi(yytext);  	 							printf("%d ",yylval.number); return t_number;}
[a-z]					{yylval.letter = yytext[0]; 		 							printf("%c ",yylval.letter); return t_variable;}
[A-Z][0-9A-Za-z]*		{strncpy(yylval.str, yytext, yyleng );yylval.str[yyleng] = '\0';printf("%s ",yylval.str); return t_variable_name;}
"("						{									 							printf("( "); return t_open_paren;}
")"						{									 							printf(") "); return t_close_paren;}
"+"						{									 							printf("+ ");return t_plus;}
"*"						{									 							printf("* ");return t_multiplication;}
"-"						{									 							printf("- ");return t_minus;}
"/"						{									  							printf("/ ");return t_division;}
":"						{									 							printf(": ");return t_division;}
"^"						{									 							printf("^ ");return t_power;}
\n						{									 							printf("\\n ");return t_enter;}
\/\*(.*\n?)*\*\/	;
\/\/(.*\\\n)*.*\n	;
[ \t]				;
<<EOF>> 																			{printf("eof "); static int once = 0; return (once = !once) ? t_eof : 0; }
.						{yyerror("Unknown command");}	

%%