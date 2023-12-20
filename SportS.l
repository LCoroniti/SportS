%{
#include "sportscript.tab.h" // Ensure this header is correct for your parser definitions
%}

%option noinput nounput noyywrap yylineno

// Define patterns for SportScript tokens
STRATEGY "strategy"
WHISTLE  "whistle"
TIMEOUT  "timeout"
ANNOUNCE "announce"
ROUND    "round"
MATCH    "match"
ALTERNATE_PLAY "alternate play"
PLAYER   "player"
TEAM     "team"
NUMBER   [0-9]+[a-z]+  // For unique number formats like 100pt, 5sec
ID       [a-zA-Z_]+    // Identifiers can include uppercase characters for SportScript
STRING   \'[^\']*\'    // Single quotes for string literals

%%

{STRATEGY}       { return STRATEGY; }
{WHISTLE}        { return WHISTLE; }
{TIMEOUT}        { return TIMEOUT; }
{ANNOUNCE}       { return ANNOUNCE; }
{ROUND}          { return ROUND; }
{MATCH}          { return MATCH; }
{ALTERNATE_PLAY} { return ALTERNATE_PLAY; }
{PLAYER}         { return PLAYER; }
{TEAM}           { return TEAM; }
{NUMBER}         { yylval.num = strdup(yytext); return NUMBER; }
{ID}             { yylval.id = strdup(yytext); return ID; }
{STRING}         { yylval.str = strdup(yytext+1); yylval.str[strlen(yylval.str)-1] = 0; return STRING; }
[ \t\n]+         // Skip whitespace
.                { return yytext[0]; }  // Catch all for single characters

%%
