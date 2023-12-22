%{
#include "SportS.tab.h" // Ensure this header is correct for your parser definitions
%}

%{
#include "your_parser_header.h" // Replace with the actual name of your Bison parser header file
%}

%option noinput nounput noyywrap yylineno

PLAYER           "player"
SCORE            "score"
SCORE_SCORE      "score:score"
GOAL             "goal"
IN               "in"
OUT              "out"
START_WHISTLE    "start whistle"
END_WHISTLE      "end whistle"
STRATEGY         "strategy"
PLAY             "play"
WIN              "win"
TIE              "tie"
LOSE             "lose"
TRAINING         "training"
PRACTICE         "practice"
ANNOUNCE         "announce"
RESULT           "result"
TIMEOUT          "timeout"
SUBSTITUTION     "substitution"
INBOUNDS         "inbounds"
OUTBOUNDS        "outbounds"
LEADS            "leads"
TRAILS           "trails"
LEADS_OR_TIES    "leads or ties"
TRAILS_OR_TIES   "trails or ties"
SCORES           "scores"
LOSES            "loses"
MULTIPLIES       "multiplies"
TACKLES          "tackles"
ANDGOAL          "andGoal"
ORGOAL           "orGoal"
NOTGOAL          "notGoal"
REMAINDER        "remainder"
SETS             "sets"
QUICK_PLAY       "quick play"
REFEREE          "referee"
INJURY           "injury"
COACH            "coach"
BUY              "buy"
NUMBER           [0-9]+
ID               [a-zA-Z_][a-zA-Z0-9_]*
STRING           \<[^\>]*\>

%%

{PLAYER}           { return PLAYER; }
{SCORE}            { return SCORE; }
{SCORE_SCORE}      { return SCORE_SCORE; }
{GOAL}             { return GOAL; }
{IN}               { return IN; }
{OUT}              { return OUT; }
{START_WHISTLE}    { return START_WHISTLE; }
{END_WHISTLE}      { return END_WHISTLE; }
{STRATEGY}         { return STRATEGY; }
{PLAY}             { return PLAY; }
{WIN}              { return WIN; }
{TIE}              { return TIE; }
{LOSE}             { return LOSE; }
{TRAINING}         { return TRAINING; }
{PRACTICE}         { return PRACTICE; }
{ANNOUNCE}         { return ANNOUNCE; }
{RESULT}           { return RESULT; }
{TIMEOUT}          { return TIMEOUT; }
{SUBSTITUTION}     { return SUBSTITUTION; }
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
{COACH}            { return COACH; }
{BUY}              { return BUY; }
{NUMBER}           { yylval.num = atoi(yytext); return NUMBER; }
{STRING}           { yylval.str = strdup(yytext); return STRING; }
{ID}               { yylval.id = strdup(yytext); return ID; }
(\ |\n)            { /* Ignore whitespace */ }
.                  { return yytext[0]; }

%%

