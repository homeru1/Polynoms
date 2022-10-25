%option yylineno

%{
	#include<stdio.h>
	#include"y.tab.h"
	#include<math.h>
	extern int yyerror(const char *);
%}
%%
"string"|					 		 {printf("vtype ");return t_vtype;}	

%%

int yywrap(void)
{
    return 1;
}