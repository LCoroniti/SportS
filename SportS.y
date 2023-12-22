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
    }v; //for what?
    struct astnode *child[10]; //change max number of children as needed
} astnode_t;
astnode_t* create_node(int type);

int compile_ast(astnode_t* root);

%}

%define parse.error detailed

%union {
    int num;            // For numerical values
    char* str;          // For string values
    struct astnode* ast;     // For AST nodes
    // Add other types as needed
}

%type <ast> program statement variable_declaration assignment function_declaration
%type <ast> control_structure print_statement expression value function_call comment include

%token <str> PLAYER SCORE SCORE_SCORE GOAL IN OUT
%token <str> START_WHISTLE END_WHISTLE STRATEGY PLAY WIN TIE LOSE
%token <str> TRAINING PRACTICE ANNOUNCE RESULT TIMEOUT SUBSTITUTION
%token <str> INBOUNDS OUTBOUNDS LEADS TRAILS LEADS_OR_TIES TRAILS_OR_TIES
%token <str> SCORES LOSES MULTIPLIES TACKLES ANDGOAL ORGOAL NOTGOAL REMAINDER
%token <str> SETS QUICK_PLAY REFEREE INJURY USING
%token <num> NUMBER
%token <str> ID COACH BUY DATATYPE IS STRING

// Define operator precedence and associativity here (TODO: is this right?)
%left ANDGOAL ORGOAL
%left SCORES LOSES
%left MULTIPLIES TACKLES
%left INBOUNDS OUTBOUNDS LEADS TRAILS LEADS_OR_TIES TRAILS_OR_TIES

%start start

%%
//TODO: include break (TIMEOUT) and continue (SUBSTITUTION) statements

start:
    program { compile_ast($1); }


program:
    | program statement { $$ = create_node(program); $$->child[0] = $1; $$->child[1] = $2; }


statement:
      variable_declaration
    | assignment
    | function_declaration
    | control_structure
    | print_statement
    | function_call
    | include //should i even support this?
    | comment
    //TODO get input from user

comment:
    COACH { $$ = create_node(/* params */); }

include:
    BUY '@' STRING

variable_declaration:
      datatype ID  //add ID to global variables

assignment:
      datatype ID IS value
      | ID IS value

datatype:
      PLAYER
    | SCORE
    | GOAL
    ;

function_declaration:
      STRATEGY ID USING '|' parameter_list '|' START_WHISTLE program RESULT END_WHISTLE { $$ = create_node(/* params */); }

function_call:
        PLAY ID USING '|' argument_list '|' { $$ = create_node(/* params */); }

control_structure:
      WIN  expression  START_WHISTLE program END_WHISTLE { $$ = create_node(/* params */); }
    | TRAINING  expression  START_WHISTLE program END_WHISTLE { $$ = create_node(/* params */); }

print_statement:
      ANNOUNCE value END_WHISTLE { $$ = create_node(/* params */); }

expression:
      value ANDGOAL value { $$ = create_node(/* params */); }
    | value ORGOAL value { $$ = create_node(/* params */); }
    | value NOTGOAL value { $$ = create_node(/* params */); }
    | value REMAINDER value { $$ = create_node(/* params */); }
    | value SCORES value { $$ = create_node(/* params */); }
    | value LOSES value { $$ = create_node(/* params */); }
    | value MULTIPLIES value { $$ = create_node(/* params */); } //TODO other keyword for MULTIPLIES!
    | value TACKLES value { $$ = create_node(/* params */); }
    | value INBOUNDS value { $$ = create_node(/* params */); }
    | value OUTBOUNDS value { $$ = create_node(/* params */); }
    | value LEADS value { $$ = create_node(/* params */); }
    | value TRAILS value { $$ = create_node(/* params */); }
    | value LEADS_OR_TIES value { $$ = create_node(/* params */); }
    | value TRAILS_OR_TIES value { $$ = create_node(/* params */); }
    | value IS value { $$ = create_node(/* params */); }
    //TODO: finish expression

value:
      NUMBER { $$ = create_node(/* params */); }
    | STRING { $$ = create_node(/* params */); }
    | ID { $$ = create_node(/* params */); }


%%

int main(int argc, char **argv) {
    // Your main function code
    return yyparse();
}

// Define additional functions used in the grammar
