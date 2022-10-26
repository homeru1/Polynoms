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
%type<polynoms> NUMBER
%type<polynoms> NEG_NUMBER
%type<polynoms> NEG_POLINOM
//%type<number> EXPR_I
//%type<number> EXPR_I_FULFILL
//%type<number> GLOBAL
%type<polynoms> POW
//%type<number> SKOB_I
%type<letter> SIGN

%token t_print t_short_assignment t_enter t_error
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
|t_variable_name t_short_assignment NEG_POLINOM{
			AddNewPolynomName($1,$3);
			Print();
}
;


POLYNOM:
		POLYNOM t_plus POLYNOM
		{
			printf("== %d + %d ==",$$->Coeficients[0],$$->Coeficients[3]);
			$$ = MathForPoly($1,'+',$3);
		}
		|POLYNOM POLYNOM %prec t_multiplication
		{
			$$ = MathForPoly($1,'*',$2);
			//printf("== %d %d ==",$$->Coeficients[0],$$->Coeficients[3]);
		}
		|POLYNOM t_multiplication POLYNOM
		{
			//printf("== %d %c %d ==",$$->Coeficients[0],$2,$$->Coeficients[3]);
			$$ = MathForPoly($1,'*',$3);
		}
		|POLYNOM t_minus POLYNOM
		{
			//printf("== %d %c %d ==",$$->Coeficients[0],$2,$$->Coeficients[3]);
			$$ = MathForPoly($1,'-',$3);
			printf("(%d)",$$->Coeficients[0] );
		}
		|POLYNOM NEG_POLINOM %prec t_minus
		{
			//printf("== %d %c %d ==",$$->Coeficients[0],$2,$$->Coeficients[3]);
			$$ = MathForPoly($1,'-',$2);
			printf("(%d)",$$->Coeficients[0] );
		}
		| t_open_paren POLYNOM t_close_paren{
			$$ = $2;
		}
		|POLYNOM t_power POLYNOM
		{
			//printf("== %d %c %d ==",$$->Coeficients[0],$2,$$->Coeficients[3]);
			$$ = MathForPoly($1,'^',$3);
			printf("(%d)",$3->Coeficients[0] );
		}
		|VAR_IN_POW
		{
			$$ = $1;
		}
		|NUMBER
		{
			$$ = $1;
		}
		;

NEG_POLINOM:
		NEG_POLINOM POLYNOM %prec t_multiplication
		{
			$$ = MathForPoly($1,'*',$2);
		}
		|NEG_POLINOM SIGN POLYNOM 
		{
			printf("== %d %c %d ==",$1->Coeficients[1],$2,$3->Coeficients[1]);
			$$ = MathForPoly($1,$2,$3);
		}
		|NEG_POLINOM t_power POLYNOM
		{
			//printf("== %d %c %d ==",$$->Coeficients[0],$2,$$->Coeficients[3]);
			$$ = MathForPoly($1,'^',$3);
			printf("(%d)",$3->Coeficients[0] );
		}
		| t_open_paren NEG_POLINOM t_close_paren{
			$$ = $2;
		}
		|NEG_NUMBER
		{
			$$ = $1;
		}

NUMBER:
	t_number{
		$$=PolyFromNum($1);
	}
	|t_number POW
	{
		$$ = MathForPoly(PolyFromNum($1),'^',$2);
		}


NEG_NUMBER:
	t_minus t_number{
		$$=PolyFromNum(-1*$2);
	}
	|t_minus t_number POW
	{
		$$ = MathForPoly(PolyFromNum(-1*$2),'^',$3);
		}

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

EXPR:
	EXPR SIGN EXPR{
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
	|t_number{
		$$ = PolyFromNum($1);
	}
	|VAR_IN_POW{
		$$ = PolyFromNum($1);
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
	for(int i = poly->MaxPower; i>=0;i++){
		if(poly->Coeficients[i]==0){
			poly->MaxPower--;
		}else{
			return;
		}
	}
	return;

}

void AddPoly(struct polynom* poly_one,struct polynom* poly_two){
	printf("\n");
	printf("Max step:%d %d \n",poly_one->MaxPower,poly_two->MaxPower);
	int coef[100] = {0};
	for (int i = 0; i <= max(poly_one->MaxPower, poly_two->MaxPower); i++)
	{
		printf("|step:%d %d + %d|\n",i,poly_one->Coeficients[i],poly_two->Coeficients[i] );
		coef[i] = poly_one->Coeficients[i]+ poly_two->Coeficients[i];
	}
	if(poly_one->MaxPower < poly_two->MaxPower){
		poly_one->MaxPower = poly_two->MaxPower;
	}
	memcpy(poly_one->Coeficients,&coef,100*sizeof(int));
	Shrink(poly_one);
	//printf("Out\n");
	return;
}
void SubPoly(struct polynom* poly_one,struct polynom* poly_two){
	int coef[100] = {0};
	for (int i = 0; i <= max(poly_one->MaxPower, poly_two->MaxPower); i++)
	{
		printf("|%d + %d|\n",poly_one->Coeficients[i],poly_two->Coeficients[i] );
		coef[i] = poly_one->Coeficients[i]-poly_two->Coeficients[i];
	}
	if(poly_one->MaxPower < poly_two->MaxPower){
		poly_one->MaxPower = poly_two->MaxPower;
	}
	memcpy(poly_one->Coeficients,&coef,100*sizeof(int));
	Shrink(poly_one);
	//printf("Out\n");
	return;
}
void MulPoly(struct polynom* poly_one,struct polynom* poly_two){
	int coef[1000] = {0};
	for(int i = 0; i <= poly_one->MaxPower; i++){
		//printf("DEGREE FIRST POLYNOM: %d\n", poly_one->MaxPower);
		for(int j = 0; j <= poly_two->MaxPower; j++){
		//printf("DEGREE SECOND POLYNOM: %d\n",poly_two->MaxPower);
			//printf("\n===!!TEST %d[%d]  += %d[%d] * %d[%d]!!!===\n", coef[i+j],i+j,poly_one->Coeficients[i],i,poly_two->Coeficients[j],j);
			coef[i+j] += (poly_one->Coeficients[i] * poly_two->Coeficients[j]);
			if(poly_one->MaxPower < i+j && coef[i+j] != 0){
				poly_one->MaxPower = i+j;
			}
		}
		//poly_one->MaxPower = poly_one->MaxPower*poly_two->MaxPower;
		//printf("%d and %d", poly_one->Coeficients[1],poly_two->Coeficients[0]);
	}
	memcpy(poly_one->Coeficients,&coef,1000*sizeof(int));
	//printf("<<%d>>", poly_one->Coeficients[256]);
	if(poly_one->Type == '1'){
		poly_one->Type = poly_two->Type;
	}
	return;
}
void PowPoly(struct polynom* poly_one,struct polynom* poly_two){
	return;
}

struct polynom* MathForPoly(struct polynom* poly_one, char sign, struct polynom* poly_two){

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
		printf("%c and %c ",poly_one->Type,poly_two->Type);
		memcpy(&tmp,poly_one,sizeof(struct polynom));
		for(int i = 0; i<poly_two->Coeficients[0]-1;i++){
		MulPoly(poly_one,&tmp);
		}
		//printf("<%d> ",tmp.Coeficients[1]);
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
	printf("!!!%d!!!\n",array_of_polynoms[0]->Coeficients[256]);
	printf("\n==================================================================================\n");
	for(int i = 0; i<amount_of_polynoms; i++){
		for(int j = 0; j<=array_of_polynoms[i]->MaxPower; j++){
			if(array_of_polynoms[i]->Coeficients[j] ==0){
				continue;
			}
			if(array_of_polynoms[i]->Coeficients[j]!=1){
				if(j==1){
					printf("<<%s = %d%c>>\n",array_of_polynoms[i]->Name,array_of_polynoms[i]->Coeficients[j],array_of_polynoms[i]->Type);
				} else if(j == 0) {
				printf("<<%s = %d>>\n",array_of_polynoms[i]->Name,array_of_polynoms[i]->Coeficients[j]);
				}else {
				printf("<<%s = %d%c^%d>>\n",array_of_polynoms[i]->Name,array_of_polynoms[i]->Coeficients[j],array_of_polynoms[i]->Type,j);
				}
			} else {
				if(j==1){
					printf("<<%s = %c>>\n",array_of_polynoms[i]->Name,array_of_polynoms[i]->Type);
				}else if(j==0){
				printf("<<%s = 1>>\n",array_of_polynoms[i]->Name);
				} else {
				printf("<<%s = %c^%d>>\n",array_of_polynoms[i]->Name,array_of_polynoms[i]->Type,j);
				}
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