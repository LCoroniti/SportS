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

#ifndef YY_YY_SPORTS_TAB_H_INCLUDED
# define YY_YY_SPORTS_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    function = 258,
    val = 259,
    param_def = 260,
    param_call = 261,
    assign_member = 262,
    array_is = 263,
    array_member = 264,
    IN = 265,
    OUT = 266,
    PROGRAM = 267,
    FLOAT = 268,
    PLAYER = 269,
    SCORE = 270,
    GOAL = 271,
    TEAM = 272,
    SET = 273,
    CNTRL = 274,
    START_WHISTLE = 275,
    END_WHISTLE = 276,
    STRATEGY = 277,
    PLAY = 278,
    WIN = 279,
    TIE = 280,
    LOSE = 281,
    PENALTY_SHOOTOUT = 282,
    PRACTICE = 283,
    ANNOUNCE = 284,
    RESULT = 285,
    TIMEOUT = 286,
    SUBSTITUTE = 287,
    INBOUNDS = 288,
    OUTBOUNDS = 289,
    LEADS = 290,
    TRAILS = 291,
    LEADS_OR_TIES = 292,
    TRAILS_OR_TIES = 293,
    SCORES = 294,
    LOSES = 295,
    MULTIPLIES = 296,
    TACKLES = 297,
    ANDGOAL = 298,
    ORGOAL = 299,
    NOTGOAL = 300,
    REMAINDER = 301,
    SETS = 302,
    QUICK_PLAY = 303,
    REFEREE = 304,
    INJURY = 305,
    USING = 306,
    NUMBER = 307,
    ID = 308,
    COACH = 309,
    BUY = 310,
    IS = 311,
    STRING = 312
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 40 "SportS.y"

    int num;            // For numerical values
    char* id;           // For identifiers
    char* str;          // For string values
    struct astnode* ast;     // For AST nodes
    // Add other types as needed

#line 123 "SportS.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SPORTS_TAB_H_INCLUDED  */
