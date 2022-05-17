/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    USING = 258,
    TIP_PRIMITIV = 259,
    VALOARE = 260,
    VALOARE_FLOTANTA = 261,
    DACA = 262,
    ALTFEL = 263,
    PENTRU = 264,
    CAT_TIMP = 265,
    RETURNEAZA = 266,
    FUNCTIE_PRINCIPALA = 267,
    EOL = 268,
    COMPARATORI = 269,
    NAMESPACE = 270,
    CLASA = 271,
    CONSTRUCTOR = 272,
    CONSTRUCTOR2 = 273,
    EXCEPTIE = 274,
    EXCEPTIET = 275,
    AFISARE = 276,
    TRY = 277,
    CATCH = 278,
    ASIGNARE = 279,
    FUNCTIE = 280,
    FUNCTIE2 = 281,
    ASIG = 282,
    RETURNT = 283
  };
#endif
/* Tokens.  */
#define USING 258
#define TIP_PRIMITIV 259
#define VALOARE 260
#define VALOARE_FLOTANTA 261
#define DACA 262
#define ALTFEL 263
#define PENTRU 264
#define CAT_TIMP 265
#define RETURNEAZA 266
#define FUNCTIE_PRINCIPALA 267
#define EOL 268
#define COMPARATORI 269
#define NAMESPACE 270
#define CLASA 271
#define CONSTRUCTOR 272
#define CONSTRUCTOR2 273
#define EXCEPTIE 274
#define EXCEPTIET 275
#define AFISARE 276
#define TRY 277
#define CATCH 278
#define ASIGNARE 279
#define FUNCTIE 280
#define FUNCTIE2 281
#define ASIG 282
#define RETURNT 283

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
