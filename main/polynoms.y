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
	#include<math.h>
	typedef struct polynom{
		char Name[10];
		int Coeficients[100];
		char Type;
		int MaxPower;
	};
	struct polynom* AddNewPolynomArg(int coeficient, char Type, int power);
	void AddNewPolynomName(char* name, struct polynom* poly);
	struct polynom* MathForPoly(struct polynom* poly_one, char sign, struct polynom* poly_two);
	struct polynom* MergePoly(struct polynom* poly_one, char sign, struct polynom* poly_two);
	struct polynom* PolyFromNum(int num);
	struct polynom* AddNewPolynom(char type, int power);
	int MathForNum(int one, char sign, int two);
	void test();
	void test2();
}
%union {
	int number;
	char letter;
	char str[100];
	struct polynom *polynoms;
}
%token<number> t_number
%token<letter> t_variable
%token<str> t_variable_name

%token<letter> VARIABLE
%type<polynoms> EXPR
%type<polynoms> SKOB
%type<polynoms> POLYNOM
%type<polynoms> VAR_IN_POW
%type<number> EXPR_I
%type<number> EXPR_I_FULFILL
//%type<number> GLOBAL
%type<number> POW
%type<number> SKOB_I
%type<letter> SIGN

%token t_print t_short_assignment t_enter
%left t_plus 
%left t_minus
%left t_multiplication t_division
%right t_power
%left t_open_paren t_close_paren //check
%%

START:        START GLOBAL
            | GLOBAL
	        ;

GLOBAL:       VAR
			;

VAR: t_variable_name t_short_assignment POLYNOM{
			AddNewPolynomName($1,$3);
			Print();
}
;

POLYNOM:
		t_number VAR_IN_POW // x^2 x^2
		{
			
			$$ = MathForPoly($2,'*',PolyFromNum($1));
		}
		/*|VAR_IN_POW SIGN EXPR
		{
			$$ = MathForPoly($1,$2,$3);
		}*/
		|VAR_IN_POW
		{
			$$ = MathForPoly($1,'\0',$1);
		}
		|POLYNOM SIGN VAR_IN_POW
		{
			$$ = MathForPoly($1,$2,$3);
		}
		|POLYNOM SIGN EXPR_I
		{
			printf("TEST");
			$$ = MathForPoly($1,$2,PolyFromNum($3));
		}
		/*|EXPR SIGN VAR_IN_POW
		{
			$$ = MathForPoly($1,$2,$3);
		}
		|EXPR_I
		{
			$$ = MathForPoly(PolyFromNum($1),'\0',PolyFromNum($1));
		}*/
		|POLYNOM SIGN POLYNOM{
			printf("Here1");
			$$ = MathForPoly($1,$2,$3);
		}
		;

VAR_IN_POW:
	t_variable 
	{$$ = AddNewPolynom($1,1);}
	|t_variable POW
	{$$ = AddNewPolynom($1,$2);}
	;


POW: t_power t_number
	{$$ = $2;}
	|t_power SKOB_I
	{$$ = $2;}
	/*|t_power EXPR_I
	{$$ = $2;}*/
	;

SKOB_I:
	t_open_paren EXPR_I t_close_paren
	{$$ = $2;}
	;

EXPR_I:
	EXPR_I_FULFILL SIGN EXPR_I_FULFILL
	{
		$$ = MathForNum($1,$2,$3);
	}
	/*|t_number SIGN t_number
	{
		$$ = MathForNum($1,$2,$3);
	}
	|SKOB_I SIGN t_number
	{
		$$ = MathForNum($1,$2,$3);
	}
	|SKOB_I SIGN SKOB_I
	{
		$$ = MathForNum($1,$2,$3);
	}*/
	|SKOB_I SKOB_I
	{
		$$ = MathForNum($1,'*',$2);
	}
	;

EXPR_I_FULFILL:
	t_number
	|SKOB_I
	|EXPR_I
	;

SKOB:
	t_open_paren EXPR t_close_paren
	{$$ = $2;}
	;

EXPR: 	
	POLYNOM SIGN POLYNOM
	{
		$$ = MathForPoly($1,$2,$3);
	}
	|POLYNOM SIGN SKOB
	{
		$$ = MathForPoly($1,$2,$3);
	}
	|SKOB SIGN POLYNOM
	{
		$$ = MathForPoly($1,$2,$3);
	}
	|SKOB SIGN SKOB
	{
		$$ = MathForPoly($1,$2,$3);
	}
	|SKOB SKOB
	{
		$$ = MathForPoly($1,'*',$2);
	}
	;

SIGN: t_plus {$$ = '+';}
	| t_minus {$$ = '-';}
	| t_multiplication {$$ = '*';}
	| t_division {$$ = '/';}
	;

%%


int amount_of_polynoms = 0;
struct polynom* array_of_polynoms[50];

struct polynom* MergePoly(struct polynom* poly_one, char sign, struct polynom* poly_two){ //{*}{t_sign,'\0'}{NULL, *}
	return NULL;
}
struct polynom* AddNewPolynom(char type, int power){
	struct polynom* tmp = (struct polynom*)calloc(1,sizeof(struct polynom));
	tmp->Type = type;
	tmp->Coeficients[power] = 1;
	tmp->MaxPower = power;
	return tmp;
}

int max(int x, int y) {
    if(x > y) {
        return x;
    } else {
        return y;
    }
}

void AddPoly(struct polynom* poly_one,struct polynom* poly_two){
	for (int i = 0; i <= max(poly_one->MaxPower, poly_two->MaxPower); i++)
	{
		printf("|%d + %d|\n",poly_one->Coeficients[i],poly_two->Coeficients[i] );
		poly_one->Coeficients[i]+=poly_two->Coeficients[i];
	}
	if(poly_one->MaxPower < poly_two->MaxPower){
		poly_one->MaxPower = poly_two->MaxPower;
	}
	printf("Out\n");
	return;
}
void SubPoly(struct polynom* poly_one,struct polynom* poly_two){
	return;
}
void MulPoly(struct polynom* poly_one,struct polynom* poly_two){
	return;
}
void PowPoly(struct polynom* poly_one,struct polynom* poly_two){
	return;
}

struct polynom* MathForPoly(struct polynom* poly_one, char sign, struct polynom* poly_two){
		switch (sign){
		case '+':
		AddPoly(poly_one,poly_two);
		break;
		case '-':
		SubPoly(poly_one,poly_two);
		break;
		case '*':
		MulPoly(poly_one,poly_two);
		break;
		case '^':
		//add check for second poly max_power is ziro
		PowPoly(poly_one,poly_two);
		break;
		case '\0':
		return poly_one;
	}
	free(poly_two);
	poly_two = NULL;
	return poly_one;
}

struct polynom* PolyFromNum(int num){
	struct polynom* tmp = (struct polynom*)calloc(1,sizeof(struct polynom));
	tmp->Type = '1';
	tmp->Coeficients[0] = num;
	tmp->MaxPower = 0;
	return tmp;
}

struct polynom* AddNewPolynomArg(int coeficient, char type, int power){
	/*if(array_of_polynoms[amount_of_polynoms].MaxPower < power){
		array_of_polynoms[amount_of_polynoms].MaxPower = power;
	}
	array_of_polynoms[amount_of_polynoms].Type = type;
	array_of_polynoms[amount_of_polynoms].Coeficients[power]=coeficient;
	printf("||Coef:%d, Type:%c, Power:%d||\n",coeficient,type,power);*/
	
	return NULL;
}

int MathForNum(int one, char sign, int two){
	switch (sign){
		case '+':
		return one + two;
		case '-':
		return one - two;
		case '*':
		return one * two;
		case ':':
		return (int)(one/two);
		case '/':
		return (int)(one/two);
		case '^':
		return (int)pow(one,two);
	}
	return 0;
}

void Print(){
	printf("\n");
	for(int i = 0; i<amount_of_polynoms; i++){
		for(int j = 0; j<=array_of_polynoms[i]->MaxPower; j++){
			if(array_of_polynoms[i]->Coeficients[j] ==0){
				continue;
			}
			if(array_of_polynoms[i]->Coeficients[j]>1){
				if(j==1){
					printf("<<%s = %d%c>>\n",array_of_polynoms[i]->Name,array_of_polynoms[i]->Coeficients[j],array_of_polynoms[i]->Type);
				} else {
				printf("<<%s = %d%c^%d>>\n",array_of_polynoms[i]->Name,array_of_polynoms[i]->Coeficients[j],array_of_polynoms[i]->Type,j);
				}
			} else {
				if(j==1){
					printf("<<%s = %c>>\n",array_of_polynoms[i]->Name,array_of_polynoms[i]->Type);
				}else {
				printf("<<%s = %c^%d>>\n",array_of_polynoms[i]->Name,array_of_polynoms[i]->Type,j);
				}
			}
		}
	}
}
void AddNewPolynomName(char* name, struct polynom* poly){
	array_of_polynoms[amount_of_polynoms] = poly;
	poly = NULL;
	strncpy(array_of_polynoms[amount_of_polynoms]->Name,name,strlen(name)+1);
	amount_of_polynoms++;
	return;
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