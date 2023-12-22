%{
#include <stdio.h>
#include <stdlib.h>
// Add any other necessary C headers and definitions here

extern int yylex();
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

typedef struct astnode{
    // Define your AST node structure here
    int type;
    union {
        int num;
        char* str;
    }; //v; for what?
    struct astnode *child[10]; //change max number of children as needed
} astnode_t;
astnode_t* node(int type);

int compile_ast(astnode_t* root);

%}

%define parse.error detailed

%union {
    int num;            // For numerical values
    char* str;          // For string values
    struct astnode* ast;     // For AST nodes
    // Add other types as needed
}

%type <ast> program statement num id str //add more types as needed

%token <str> PLAYER SCORE SCORE_SCORE GOAL IN OUT
%token <str> START_WHISTLE END_WHISTLE STRATEGY PLAY WIN TIE LOSE
%token <str> TRAINING PRACTICE ANNOUNCE RESULT TIMEOUT SUBSTITUTION
%token <str> INBOUNDS OUTBOUNDS LEADS TRAILS LEADS_OR_TIES TRAILS_OR_TIES
%token <str> SCORES LOSES MULTIPLIES DIVIDES ANDGOAL ORGOAL NOTGOAL REMAINDER
%token <str> SETS QUICK_PLAY REFEREE INJURY
%token <num> NUMBER
%token ID

//define left and right associativity as well as precedence

%start program

%%

program:
    | program statement
    ;

statement:
      variable_declaration
    | function_declaration
    | assignment_statement
    | control_structure
    | print_statement
    ;

variable_declaration:
      PLAYER ID SETS expression END_WHISTLE { $$ = create_node(/* params */); }
    ;

function_declaration:
      STRATEGY USING '(' parameter_list ')' START_WHISTLE statements END_WHISTLE { $$ = create_node(/* params */); }
    ;

assignment_statement:
      ID SETS expression END_WHISTLE { $$ = create_node(/* params */); }
    ;

control_structure:
      WIN '(' expression ')' START_WHISTLE statements END_WHISTLE { $$ = create_node(/* params */); }
    | TRAINING '(' expression ')' START_WHISTLE statements END_WHISTLE { $$ = create_node(/* params */); }
    | PRACTICE '(' assignment_statement expression ';' expression ')' START_WHISTLE statements END_WHISTLE { $$ = create_node(/* params */); }
    ;

print_statement:
      ANNOUNCE expression END_WHISTLE { $$ = create_node(/* params */); }
    ;

expression:
      NUMBER { $$ = create_node(/* params */); }
    | ID { $$ = create_node(/* params */); }
    | expression SCORES expression { $$ = create_node(/* params */); }
    // Add other expressions and operators
    ;

%%

int main(int argc, char **argv) {
    // Your main function code
    return yyparse();
}

// Define additional functions used in the grammar
