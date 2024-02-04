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
    expr_list = 265,
    IN = 266,
    OUT = 267,
    PROGRAM = 268,
    FLOAT = 269,
    PLAYER = 270,
    SCORE = 271,
    GOAL = 272,
    TEAM = 273,
    SET = 274,
    CNTRL = 275,
    ALLSTAR = 276,
    AID = 277,
    START_WHISTLE = 278,
    END_WHISTLE = 279,
    STRATEGY = 280,
    PLAY = 281,
    WIN = 282,
    TIE = 283,
    LOSE = 284,
    PENALTY_SHOOTOUT = 285,
    PRACTICE = 286,
    ANNOUNCE = 287,
    RESULT = 288,
    TIMEOUT = 289,
    SUBSTITUTE = 290,
    INBOUNDS = 291,
    OUTBOUNDS = 292,
    LEADS = 293,
    TRAILS = 294,
    LEADS_OR_TIES = 295,
    TRAILS_OR_TIES = 296,
    SCORES = 297,
    LOSES = 298,
    MULTIPLIES = 299,
    TACKLES = 300,
    ANDGOAL = 301,
    ORGOAL = 302,
    NOTGOAL = 303,
    REMAINDER = 304,
    SETS = 305,
    QUICK_PLAY = 306,
    REFEREE = 307,
    INJURY = 308,
    USING = 309,
    NUMBER = 310,
    ID = 311,
    COACH = 312,
    BUY = 313,
    IS = 314,
    STRING = 315
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 42 "SportS.y"

    int num;            // For numerical values
    char* id;           // For identifiers
    char* str;          // For string values
    struct astnode* ast;     // For AST nodes
    // Add other types as needed

#line 126 "SportS.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SPORTS_TAB_H_INCLUDED  */
