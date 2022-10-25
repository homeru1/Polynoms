%{
	#include<stdio.h>
	#include <string.h>
	int yylex(void);
	int yyerror(const char *s);
	int yyparse();
	int success = 1;
	extern FILE *yyin;
	#define YYDEBUG 1
%}
%code requires{

	typedef struct polynom{
	int Coeficients[100];
	char Type;
	int max_power;
	}polynom;
	void test();
	void test2();
}
%union {
	int number;
	char letter;
	char str[100];
	polynom polynoms;
}
%token<number> t_number
%token<letter> t_variable
%token<str> t_variable_name

%type<str> EXPR
%type<number> GLOBAL

%token t_print t_short_assignment t_enter
%left t_plus 
%left t_minus
%left t_multiplication
%right t_power
%left t_open_paren t_close_paren //check
%%

START:        START GLOBAL
            | GLOBAL
	        ;

GLOBAL:       EXPR EXPR{
	test();
}

VAR: t_variable_name t_short_assignment POLYNOM
;

POLYNOM:

;
EXPR: t_variable_name
{
	test2();
	
	}
%%


int amount_of_polynoms = 0;
polynom array_of_polynoms[100];

void test(){
	printf("!%d, %c!",amount_of_polynoms,array_of_polynoms[amount_of_polynoms-1].Type);
}
void test2(){
	//array_of_polynoms[amount_of_polynoms].Coeficients[0] = 10;
	amount_of_polynoms++;
}

int main(int argc, char **argv)
{
	if (argc > 1)
	{
		if(!(yyin = fopen(argv[1], "r")))
		{
		perror(argv[1]);
		return (1);
		}
	}
	yydebug = 0;
    yyparse();
    if(success)
    	printf("\nParsing Successful\n");
	else 
		printf("\nParsing not successful\n");
    return 0;
}

int yyerror(const char *msg)
{
	extern int yylineno;
	printf("Parsing Failed\nLine Number: %d %s\n",yylineno,msg);
	success = 0;
	return 0;
}