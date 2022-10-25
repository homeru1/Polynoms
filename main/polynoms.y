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
	#include<malloc.h>
	#include<stdlib.h>
	typedef struct polynom{
	char Name[100];
	int Coeficients[100];
	char Type;
	int MaxPower;
	}polynom;
	void AddNewPolynomArg(int coeficient, char Type, int power);
	void AddNewPolynomName(char* name);
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

%token<letter> VARIABLE
%type<polynoms> EXPR
%type<number> GLOBAL
%type<number> POW
%type<polynoms> SKOB
%type<letter> SIGN

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

GLOBAL:       VAR

VAR: t_variable_name t_short_assignment POLYNOM{
			AddNewPolynomName($1);
}
;

POLYNOM:
		EXPR t_variable POW
		{
			AddNewPolynomArg($1,$2,$3);
		}
		| t_variable POW EXPR
		{
			AddNewPolynomArg($3,$1,$2);
		}
		|t_variable POW
		{
			AddNewPolynomArg(1,$1,$2);
		}
;

POW: t_power t_number
	{$$ = $2;} //$$ == *int   $2 == t_number
	|t_power SKOB
	{$$ = $2;}
	;

SKOB:
	t_open_paren EXPR t_close_paren
	{$$ = $2;}
	;
EXPR: t_number SIGN t_number
	{}
	;
EXPR_FOR_POLYNOMS:
	POLYNOM SIGN POLYNOM;
	{MathForPoly($1,$3,$2);}
	;
SIGN: t_plus {$$ = '+';}
	| t_minus {$$ = '-';}
	| t_multiplication {$$ = '*';}
	;

%%


int amount_of_polynoms = 0;
polynom array_of_polynoms[100];
polynom* MathForPoly(polynom* Poly_one, polynom* Poly_two, char sign){
	polynom* tmp = (polynom*)calloc(1,sizeof(polynom));
	
}
void AddNewPolynomArg(int coeficient, char type, int power){
	if(array_of_polynoms[amount_of_polynoms].MaxPower < power){
		array_of_polynoms[amount_of_polynoms].MaxPower = power;
	}
	array_of_polynoms[amount_of_polynoms].Type = type;
	array_of_polynoms[amount_of_polynoms].Coeficients[power]=coeficient;
	printf("||Coef:%d, Type:%c, Power:%d||\n",coeficient,type,power);
	
}
void Print(){
	for(int i = 0; i<amount_of_polynoms; i++){
		for(int j = 0; j<=array_of_polynoms[i].MaxPower; j++){
			if(array_of_polynoms[i].Coeficients[j] !=0){
				if(array_of_polynoms[i].Coeficients[j]>1){
					printf("<<%s = %d%c^%d>>\n",array_of_polynoms[i].Name,array_of_polynoms[i].Coeficients[j],array_of_polynoms[i].Type,j);
				} else {
					printf("<<%s = %c^%d>>\n",array_of_polynoms[i].Name,array_of_polynoms[i].Type,j);
				}
			}
		}
	}
}
void AddNewPolynomName(char* name){
	strcpy(array_of_polynoms[amount_of_polynoms].Name,name);
	amount_of_polynoms++;
	Print();
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