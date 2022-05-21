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
    PRIMITIVE_DATA_TYPE = 259,
    VALUE = 260,
    FLOTANT_VALUE = 261,
    IF = 262,
    ELSE = 263,
    FOR = 264,
    WHILE = 265,
    RETURNEAZA = 266,
    MAIN = 267,
    EOL = 268,
    NAMESPACE = 269,
    CLASS = 270,
    EXCEPTION = 271,
    PRINT = 272,
    ASIGNARE = 273,
    FUNCTION = 274,
    ASSIGN = 275,
    RETURNT = 276
  };
#endif
/* Tokens.  */
#define USING 258
#define PRIMITIVE_DATA_TYPE 259
#define VALUE 260
#define FLOTANT_VALUE 261
#define IF 262
#define ELSE 263
#define FOR 264
#define WHILE 265
#define RETURNEAZA 266
#define MAIN 267
#define EOL 268
#define NAMESPACE 269
#define CLASS 270
#define EXCEPTION 271
#define PRINT 272
#define ASIGNARE 273
#define FUNCTION 274
#define ASSIGN 275
#define RETURNT 276

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
