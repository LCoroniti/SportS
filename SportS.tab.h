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
    IN = 263,
    OUT = 264,
    PROGRAM = 265,
    FLOAT = 266,
    PLAYER = 267,
    SCORE = 268,
    GOAL = 269,
    TEAM = 270,
    SET = 271,
    CNTRL = 272,
    START_WHISTLE = 273,
    END_WHISTLE = 274,
    STRATEGY = 275,
    PLAY = 276,
    WIN = 277,
    TIE = 278,
    LOSE = 279,
    PENALTY_SHOOTOUT = 280,
    PRACTICE = 281,
    ANNOUNCE = 282,
    RESULT = 283,
    TIMEOUT = 284,
    SUBSTITUTION = 285,
    INBOUNDS = 286,
    OUTBOUNDS = 287,
    LEADS = 288,
    TRAILS = 289,
    LEADS_OR_TIES = 290,
    TRAILS_OR_TIES = 291,
    SCORES = 292,
    LOSES = 293,
    MULTIPLIES = 294,
    TACKLES = 295,
    ANDGOAL = 296,
    ORGOAL = 297,
    NOTGOAL = 298,
    REMAINDER = 299,
    SETS = 300,
    QUICK_PLAY = 301,
    REFEREE = 302,
    INJURY = 303,
    USING = 304,
    NUMBER = 305,
    ID = 306,
    COACH = 307,
    BUY = 308,
    IS = 309,
    STRING = 310
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 37 "SportS.y"

    int num;            // For numerical values
    char* id;           // For identifiers
    char* str;          // For string values
    struct astnode* ast;     // For AST nodes
    // Add other types as needed

#line 121 "SportS.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SPORTS_TAB_H_INCLUDED  */
