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
		int Coeficients[1000];
		char Type;
		int MaxPower;
	};
	struct polynom* AddNewPolynomArg(int coeficient, char Type, int power);
	void AddNewPolynomName(char* name, struct polynom* poly);
	struct polynom* MathForPoly(struct polynom* poly_one, char sign, struct polynom* poly_two);
	struct polynom* MergePoly(struct polynom* poly_one, char sign, struct polynom* poly_two);
	struct polynom* PolyFromNum(int num);
	struct polynom* AddNewPolynom(char type, struct polynom* power);
	struct polynom* FindByName(char* name);
	int MathForNum(int one, char sign, int two);
	void Print(struct polynom* poly);
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

%type<polynoms> SKOB
%type<polynoms> POLYNOM
%type<polynoms> VAR_IN_POW
%type<polynoms> NUMBER
%type<polynoms> POW

%token t_print t_short_assignment t_enter t_eof
%left t_plus 
%left t_minus
%left t_multiplication t_division
%right t_power
%left t_open_paren t_close_paren
%%

START:        START GLOBAL
            | GLOBAL
	        ;

GLOBAL:       VAR END_SYMBOLS
			| OUTPUT END_SYMBOLS
			| END_SYMBOLS
			;

VAR: t_variable_name t_short_assignment POLYNOM{
			AddNewPolynomName($1,$3);
			//Print(FindByName($1));
}
;

END_SYMBOLS:
	t_enter
	|t_eof

OUTPUT:	t_print t_open_paren t_variable_name t_close_paren {
	Print(FindByName($3));
}

POLYNOM:
		POLYNOM t_plus POLYNOM
		{
			$$ = MathForPoly($1,'+',$3);
		}
		|POLYNOM POLYNOM %prec t_multiplication
		{
			$$ = MathForPoly($1,'*',$2);
		}
		|POLYNOM t_multiplication POLYNOM
		{
			$$ = MathForPoly($1,'*',$3);
		}
		|POLYNOM t_minus POLYNOM
		{
			$$ = MathForPoly($1,'-',$3);
		}
		|POLYNOM t_division POLYNOM
		{
			$$ = MathForPoly($1,'/',$3);
		}
		| t_open_paren POLYNOM t_close_paren{
			$$ = $2;
		}
		|POLYNOM t_power POLYNOM
		{
			$$ = MathForPoly($1,'^',$3);
		}
		|t_minus POLYNOM{
			$$ = MathForPoly($2,'*',PolyFromNum(-1));
		}
		|VAR_IN_POW
		{
			$$ = $1;
		}
		|NUMBER
		{
			$$ = $1;
		}
		|t_variable_name {
			$$ = FindByName($1);
		}
		;

NUMBER:
	t_number{$$=PolyFromNum($1);}
	|t_number POW
	{$$ = MathForPoly(PolyFromNum($1),'^',$2);}

VAR_IN_POW:
	t_variable 
	{$$ = AddNewPolynom($1,PolyFromNum(1));}
	|t_variable POW
	{
		$$ = AddNewPolynom($1,$2);
		}
	;


POW: t_power NUMBER
	{$$ = $2;}
	|t_power SKOB
	{$$ = $2;}
	|t_power NUMBER POW
	{
			$$ = MathForPoly($2,'^',$3);
		}
SKOB:
	t_open_paren POLYNOM t_close_paren
	{$$ = $2;}
	;


%%


int amount_of_polynoms = 0;
struct polynom* array_of_polynoms[50];

struct polynom* AddNewPolynom(char type, struct polynom* power){
	if(power->MaxPower !=0){
		yyerror("Error in AddNewPolyonm");
	}
	struct polynom* tmp = (struct polynom*)calloc(1,sizeof(struct polynom));
	tmp->Type = type;
	tmp->Coeficients[power->Coeficients[0]] = 1;
	tmp->MaxPower = power->Coeficients[0];
	return tmp;
}

int max(int x, int y) {
    if(x > y) {
        return x;
    } else {
        return y;
    }
}

void Shrink(struct polynom* poly){
	poly->MaxPower=0;
	for(int i = 0; i<1000;i++){
		if(poly->Coeficients[i]!=0 & poly->MaxPower < i){
			poly->MaxPower=i;
		}
	}
	if(poly->MaxPower == 0){
		poly->Type = '1';
	}
	return;

}

void AddPoly(struct polynom* poly_one,struct polynom* poly_two){
	int coef[1000] = {0};
	for (int i = 0; i <= max(poly_one->MaxPower, poly_two->MaxPower); i++)
	{
		coef[i] = poly_one->Coeficients[i]+ poly_two->Coeficients[i];
	}
	if(poly_one->MaxPower < poly_two->MaxPower){
		poly_one->MaxPower = poly_two->MaxPower;
	}
	memcpy(poly_one->Coeficients,&coef,100*sizeof(int));
	Shrink(poly_one);
	return;
}
void SubPoly(struct polynom* poly_one,struct polynom* poly_two){
	int coef[1000] = {0};
	for (int i = 0; i <= max(poly_one->MaxPower, poly_two->MaxPower); i++)
	{
		coef[i] = poly_one->Coeficients[i]-poly_two->Coeficients[i];
	}
	if(poly_one->MaxPower < poly_two->MaxPower){
		poly_one->MaxPower = poly_two->MaxPower;
	}
	memcpy(poly_one->Coeficients,&coef,100*sizeof(int));
	Shrink(poly_one);
	return;
}
void MulPoly(struct polynom* poly_one,struct polynom* poly_two){
	int coef[1000] = {0};
	for(int i = 0; i <= poly_one->MaxPower; i++){
		for(int j = 0; j <= poly_two->MaxPower; j++){
			coef[i+j] += (poly_one->Coeficients[i] * poly_two->Coeficients[j]);
			if(poly_one->MaxPower < i+j && coef[i+j] != 0){
				poly_one->MaxPower = i+j;
			}
		}
	}
	memcpy(poly_one->Coeficients,&coef,1000*sizeof(int));
	if(poly_one->Type == '1'){
		poly_one->Type = poly_two->Type;
	}
	return;
}

int CheckForZero(struct polynom* poly_one){
	if(poly_one->MaxPower>0){
		return 0;
	}else if(poly_one->Coeficients[0]!=0){
		return 0;
	}
	return 1;
}

struct polynom* MathForPoly(struct polynom* poly_one, char sign, struct polynom* poly_two){
		if(poly_one->Type !=poly_two->Type){
			if (poly_one->Type != '1' & poly_two->Type != '1' ){
			printf("== %c and %c ==\n",poly_one->Type,poly_two->Type);
			 yyerror("Differet vars");
			 exit(-1);
			}
		}
		struct polynom tmp;
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
		if(CheckForZero(poly_one)){
			if(CheckForZero(poly_two)){
			yyerror("Error: 0^0");
			 exit(-1);
			}
		}
		memcpy(&tmp,poly_one,sizeof(struct polynom));
		for(int i = 0; i<poly_two->Coeficients[0]-1;i++){
		MulPoly(poly_one,&tmp);
		}
		break;
		case '/':
		poly_one->Coeficients[0] = (int)(poly_one->Coeficients[0]/poly_two->Coeficients[0]);
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

struct polynom* FindByName(char* name){
	for(int i = 0; i<amount_of_polynoms;i++ ){
		if(strcmp(name,array_of_polynoms[i]->Name) == 0){
			return array_of_polynoms[i];
		}
	}
}

void Print(struct polynom* poly){
	printf("\n==================================================================================\n");
		for(int j = 0; j<=poly->MaxPower; j++){
			if(poly->Coeficients[j] ==0){
				continue;
			}
			if(poly->Coeficients[j]!=1){
				if(j==1){
					printf("<<%s = %d%c>>\n",poly->Name,poly->Coeficients[j],poly->Type);
				} else if(j == 0) {
				printf("<<%s = %d>>\n",poly->Name,poly->Coeficients[j]);
				}else {
				printf("<<%s = %d%c^%d>>\n",poly->Name,poly->Coeficients[j],poly->Type,j);
				}
			} else {
				if(j==1){
					printf("<<%s = %c>>\n",poly->Name,poly->Type);
				}else if(j==0){
				printf("<<%s = 1>>\n",poly->Name);
				} else {
				printf("<<%s = %c^%d>>\n",poly->Name,poly->Type,j);
				}
			}
	}
	printf("==================================================================================\n");
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