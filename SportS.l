%{
#include "SportS.tab.h" // Ensure this header is correct for your parser definitions
%}

%option noinput nounput noyywrap yylineno

PLAYER           "PLAYER"
SCORE            "SCORE"
GOAL             "GOAL"
TEAM             "TEAM"
IN               "IN"
OUT              "OUT"
IS               "IS"
START_WHISTLE    "START_WHISTLE"
END_WHISTLE      "END_WHISTLE"
STRATEGY         "STRATEGY"
PLAY             "PLAY"
WIN              "WIN"
TIE              "TIE"
LOSE             "LOSE"
PENALTY_SHOOTOUT "PENALTY_SHOOTOUT"
PRACTICE         "PRACTICE"
ANNOUNCE         "ANNOUNCE"
RESULT           "RESULT"
TIMEOUT          "TIMEOUT"
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
SETS             "SETS"
QUICK_PLAY       "QUICK_PLAY"
REFEREE          "REFEREE"
INJURY           "INJURY"
USING            "USING"
COACH            "*COACH"[^\n]*
BUY              "BUY"
NUMBER           [0-9]+
ID               [a-zA-Z_][a-zA-Z0-9_]*
STRING           \<[^\>]*\>

%%

{PLAYER}           { return PLAYER; }
{SCORE}            { return SCORE; }
{GOAL}             { return GOAL; }
{TEAM}             { return TEAM; }
{IN}               { return IN; }
{OUT}              { return OUT; }
{IS}               { return IS; }
{START_WHISTLE}    { return START_WHISTLE; }
{END_WHISTLE}      { return END_WHISTLE; }
{STRATEGY}         { return STRATEGY; }
{PLAY}             { return PLAY; }
{WIN}              { return WIN; }
{TIE}              { return TIE; }
{LOSE}             { return LOSE; }
{PENALTY_SHOOTOUT} { return PENALTY_SHOOTOUT; }
{PRACTICE}         { return PRACTICE; }
{ANNOUNCE}         { return ANNOUNCE; }
{RESULT}           { return RESULT; }
{TIMEOUT}          { return TIMEOUT; }
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
{SETS}             { return SETS; }
{QUICK_PLAY}       { return QUICK_PLAY; }
{REFEREE}          { return REFEREE; }
{INJURY}           { return INJURY; }
{BUY}              { return BUY; }
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
{ID}               { yylval.id = strdup(yytext); return ID; }
(\ |\n|\r|\t)
.                  { return yytext[0]; }



%%

