%{
#include <stdio.h>
#include <stdlib.h>
// Additional C code and headers (if necessary)

// Forward declarations
void yyerror(const char *s);
int yylex(void);
%}

// Token declarations
%token STRATEGY WHISTLE TIMEOUT ANNOUNCE ROUND MATCH ALTERNATE PLAYER TEAM SCORES
%token NUMBER ID STRING

%%

// Grammar rules
program:
           program statement
    | /* empty */
    ;

statement:
	     declaration
    | expression
    | control_flow
    ;

declaration:
	       TYPE variable_declaration
    ;

variable_declaration:
		        ID
    | ID SCORES expression
    ;

expression:
	      NUMBER
    | STRING
    | ID
    | expression OPERATOR expression
    ;

control_flow:
	        if_statement
    | loop_statement
    ;

if_statement:
	        MATCH expression WHISTLE block WHISTLE
    | MATCH expression WHISTLE block WHISTLE ALTERNATE WHISTLE block WHISTLE
    ;

loop_statement:
	          ROUND expression WHISTLE block WHISTLE
    ;

block:
         statement
    | WHISTLE program WHISTLE
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    if (yyparse() == 0) {
        printf("SportScript parsed successfully!\n");
    }
    return 0;
}

