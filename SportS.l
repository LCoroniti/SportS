%{
#include "SportS.tab.h" // Ensure this header is correct for your parser definitions
%}

%option noyywrap

STRATEGY "strategy"
WHISTLE  "whistle"
TIMEOUT  "timeout"
ANNOUNCE "announce"
ROUND    "round"
MATCH    "match"
ALTERNATE "alternate"
PLAYER   "player"
TEAM     "team"
SCORES   "scores"

NUMBER   [0-9]+[a-z]+
ID       [a-zA-Z_]+
STRING   \'[^\']*\'

%%

{STRATEGY}       { return STRATEGY; }
{WHISTLE}        { return WHISTLE; }
{TIMEOUT}        { return TIMEOUT; }
{ANNOUNCE}       { return ANNOUNCE; }
{ROUND}          { return ROUND; }
{MATCH}          { return MATCH; }
{ALTERNATE} { return ALTERNATE; }
{PLAYER}         { return PLAYER; }
{TEAM}           { return TEAM; }
{SCORES}         { return SCORES; }

{NUMBER}         { return NUMBER; }
{ID}             { return ID; }
{STRING}         { return STRING; }
[ \t\n]+         // Skip whitespace
.                { return yytext[0]; }

%%
