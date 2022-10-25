/* A Bison parser, made by GNU Bison 2.7.  */

/* Bison interface for Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2012 Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
/* Line 2058 of yacc.c  */
#line 11 "..\\main\\polynoms.y"

	#include<malloc.h>
	#include<stdlib.h>
	#include<math.h>
	typedef struct polynom{
		char Name[100];
		int Coeficients[100];
		char Type;
		int MaxPower;
	};
	struct polynom* AddNewPolynomArg(int coeficient, char Type, int power);
	struct polynom* AddNewPolynomName(char* name);
	struct polynom* MathForPoly(struct polynom* poly_one, char sign, struct polynom* poly_two);
	struct polynom* MergePoly(struct polynom* poly_one, char sign, struct polynom* poly_two);
	struct polynom* AddNewPolynom(char type, int power);
	int MathForNum(int one, char sign, int two);
	void test();
	void test2();


/* Line 2058 of yacc.c  */
#line 67 "y.tab.h"

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     t_number = 258,
     t_variable = 259,
     t_variable_name = 260,
     VARIABLE = 261,
     t_print = 262,
     t_short_assignment = 263,
     t_enter = 264,
     t_plus = 265,
     t_minus = 266,
     t_division = 267,
     t_multiplication = 268,
     t_power = 269,
     t_close_paren = 270,
     t_open_paren = 271
   };
#endif
/* Tokens.  */
#define t_number 258
#define t_variable 259
#define t_variable_name 260
#define VARIABLE 261
#define t_print 262
#define t_short_assignment 263
#define t_enter 264
#define t_plus 265
#define t_minus 266
#define t_division 267
#define t_multiplication 268
#define t_power 269
#define t_close_paren 270
#define t_open_paren 271



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{
/* Line 2058 of yacc.c  */
#line 30 "..\\main\\polynoms.y"

	int number;
	char letter;
	char str[100];
	struct polynom *polynoms;


/* Line 2058 of yacc.c  */
#line 122 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
