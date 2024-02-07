%{
#include "SportS.tab.h"
%}

%option noinput nounput noyywrap yylineno

ALLSTAR          "ALLSTAR"
PLAYER           "PLAYER"
SCORE            "SCORE"
TEAM             "TEAM"
IS               "IS"
START_WHISTLE    "START_WHISTLE"
END_WHISTLE      "END_WHISTLE"
STRATEGY         "STRATEGY"
PLAY             "PLAY"
WIN              "WIN"
TIE              "TIE"
LOSE             "LOSE"
PENALTY_SHOOTOUT "PENALTY_SHOOTOUT"
ANNOUNCE         "ANNOUNCE"
RESULT           "RESULT"
SUBSTITUTE       "SUBSTITUTE"
INBOUNDS         "INBOUNDS"
OUTBOUNDS        "OUTBOUNDS"
LEADS            "LEADS"
TRAILS           "TRAILS"
LEADS_OR_TIES    "LEADS_OR_TIES"
TRAILS_OR_TIES   "TRAILS_OR_TIES"
SCORES           "SCORES"
LOSES            "LOSES"
MULTIPLIES       "MULTIPLIES"
TACKLES          "TACKLES"
ANDGOAL          "AND_GOAL"
ORGOAL           "OR_GOAL"
NOTGOAL          "NOT_GOAL"
REMAINDER        "REMAINDER"
REFEREE          "REFEREE"
USING            "USING"
COACH            ";COACH"[^\n]*
NUMBER           [0-9]+
AID              "*"[a-zA-Z_][a-zA-Z0-9_]*
ID               [a-zA-Z_][a-zA-Z0-9_]*
STRING           \<[^\>]*\>

%%

{ALLSTAR}          { return ALLSTAR; }
{PLAYER}           { return PLAYER; }
{SCORE}            { return SCORE; }
{TEAM}             { return TEAM; }
{IS}               { return IS; }
{START_WHISTLE}    { return START_WHISTLE; }
{END_WHISTLE}      { return END_WHISTLE; }
{STRATEGY}         { return STRATEGY; }
{PLAY}             { return PLAY; }
{WIN}              { return WIN; }
{TIE}              { return TIE; }
{LOSE}             { return LOSE; }
{PENALTY_SHOOTOUT} { return PENALTY_SHOOTOUT; }
{ANNOUNCE}         { return ANNOUNCE; }
{RESULT}           { return RESULT; }
{SUBSTITUTE}       { return SUBSTITUTE; }
{INBOUNDS}         { return INBOUNDS; }
{OUTBOUNDS}        { return OUTBOUNDS; }
{LEADS}            { return LEADS; }
{TRAILS}           { return TRAILS; }
{LEADS_OR_TIES}    { return LEADS_OR_TIES; }
{TRAILS_OR_TIES}   { return TRAILS_OR_TIES; }
{SCORES}           { return SCORES; }
{LOSES}            { return LOSES; }
{MULTIPLIES}       { return MULTIPLIES; }
{TACKLES}          { return TACKLES; }
{ANDGOAL}          { return ANDGOAL; }
{ORGOAL}           { return ORGOAL; }
{NOTGOAL}          { return NOTGOAL; }
{REMAINDER}        { return REMAINDER; }
{USING}            { return USING; }
{COACH}            { }
{NUMBER}           { yylval.num = atoi(yytext); return NUMBER; }
{STRING}           {
                       int len = strlen(yytext) - 2; // Length of the string without quotes
                       yylval.str = malloc(len + 1); // Allocate memory for the new string (+1 for null terminator)
                       strncpy(yylval.str, yytext + 1, len); // Copy the string without the first and last character
                       yylval.str[len] = '\0'; // Null-terminate the string
                       return STRING;
                   }
{AID}              { yylval.id = strdup(yytext); return AID; }
{ID}               { yylval.id = strdup(yytext); return ID; }
(\ |\n|\r|\t)      { }
.                 {
                    return yytext[0];
                  }



%%

