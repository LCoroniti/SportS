%{
#include <stdio.h>
#include <stdlib.h>
// Add any other necessary C headers and definitions here

int yylex(void);
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

typedef struct astnode{
    // Define your AST node structure here
    int type;
    union {
        int num;
        char* str;
    }val;
    struct astnode *child[10]; //change max number of children as needed
} astnode_t;
astnode_t* create_node(int type);

int compile_ast(astnode_t* root);

void print_ast_dot(astnode_t* node, int depth) {
    static FILE* dot;
    if (depth == 0) {
        dot = fopen("ast.gv", "w");
        fprintf(dot, "digraph ast {\n");
    }
    if (node == NULL) return;

    // Print node to file
    fprintf(dot, "\"%p\" [label=\"Type: %d", (void*)node, node->type);
    if (node->val.str != NULL) {
        fprintf(dot, "\\nValue: %s", node->val.str);
    }
    fprintf(dot, "\"];\n");

    // Print edges to children
    for (int i = 0; i < 10; i++) {
        if (node->child[i] != NULL) {
            fprintf(dot, "\"%p\" -> \"%p\";\n", (void*)node, (void*)node->child[i]);
            print_ast_dot(node->child[i], depth + 1);
        }
    }

    if (depth == 0) {
        fprintf(dot, "}\n");
        fclose(dot);
    }
}
%}

//%define parse.error simple //change to detailed?

%union {
    int num;            // For numerical values
    char* id;           // For identifiers
    char* str;          // For string values
    struct astnode* ast;     // For AST nodes
    // Add other types as needed
}

%type <ast> program statement variable_declaration assignment function_declaration
%type <ast> control_structure print_statement expression value function_call comment include
%type <ast> datatype condition tie_or_lose_branch parameter_list

%token <str> PLAYER SCORE GOAL IN OUT PROGRAM FLOAT
%token <str> START_WHISTLE END_WHISTLE STRATEGY PLAY WIN TIE LOSE
%token <str> PENALTY_SHOOTOUT PRACTICE ANNOUNCE RESULT TIMEOUT SUBSTITUTION
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
    | program statement { $$ = create_node(PROGRAM); $$->child[0] = $1; $$->child[1] = $2; printf("digraph G {\n"); print_ast_dot($$, 0); printf("}\n"); }
    | %empty { $$ = NULL; }


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
    COACH

include:
    BUY '@' STRING

variable_declaration:
      datatype ID

assignment:
      datatype ID IS expression { $$ = create_node(IS); $$->child[0] = $2; $$->child[1] = $4;}
      | ID IS expression { $$ = create_node(IS); $$->child[0] = $1; $$->child[1] = $3;}

datatype:
      PLAYER
    | SCORE
    | GOAL
    ;

function_declaration:
      STRATEGY ID USING '|' parameter_list '|' START_WHISTLE program RESULT END_WHISTLE

function_call:
      PLAY ID USING '|' parameter_list '|' { $$ = create_node(PLAY); $$->child[0] = $2; $$->child[1] = $5; }

parameter_list:
      parameter_list value
    | value
    | %empty { $$ = NULL; }

control_structure:
      WIN condition START_WHISTLE program END_WHISTLE tie_or_lose_branch { $$ = create_node(WIN); $$->child[0] = $2; $$->child[1] = $4; $$->child[2] = $6; }
    | PENALTY_SHOOTOUT  condition  START_WHISTLE program END_WHISTLE { $$ = create_node(PENALTY_SHOOTOUT); $$->child[0] = $2; $$->child[1] = $4; }

tie_or_lose_branch:
       tie_or_lose_branch TIE condition START_WHISTLE program END_WHISTLE { $$ = create_node(TIE); $$->child[0] = $3; $$->child[1] = $5; }
    |  tie_or_lose_branch LOSE START_WHISTLE program END_WHISTLE { $$ = create_node(LOSE); $$->child[0] = $4; }
    | TIE condition START_WHISTLE program END_WHISTLE { $$ = create_node(TIE); $$->child[0] = $2; $$->child[1] = $4; }
    | %empty { $$ = NULL; }

condition:
      value ANDGOAL value { $$ = create_node(ANDGOAL); $$->child[0] = $1; $$->child[1] = $3; }
    | value ORGOAL value { $$ = create_node(ORGOAL); $$->child[0] = $1; $$->child[1] = $3; }
    | NOTGOAL value { $$ = create_node(NOTGOAL); $$->child[0] = $2;}
    | value INBOUNDS value { $$ = create_node(INBOUNDS); $$->child[0] = $1; $$->child[1] = $3; }
    | value OUTBOUNDS value { $$ = create_node(OUTBOUNDS); $$->child[0] = $1; $$->child[1] = $3; }
    | value LEADS value { $$ = create_node(LEADS); $$->child[0] = $1; $$->child[1] = $3; }
    | value TRAILS value { $$ = create_node(TRAILS); $$->child[0] = $1; $$->child[1] = $3; }
    | value LEADS_OR_TIES value { $$ = create_node(LEADS_OR_TIES); $$->child[0] = $1; $$->child[1] = $3; }
    | value TRAILS_OR_TIES value { $$ = create_node(TRAILS_OR_TIES); $$->child[0] = $1; $$->child[1] = $3; }


print_statement:
      ANNOUNCE parameter_list END_WHISTLE { $$ = create_node(ANNOUNCE); $$->child[0] = $2; }

expression:
     value REMAINDER value { $$ = create_node(REMAINDER); $$->child[0] = $1; $$->child[1] = $3; }
    | value SCORES value { $$ = create_node(SCORES); $$->child[0] = $1; $$->child[1] = $3; }
    | value LOSES value { $$ = create_node(LOSES); $$->child[0] = $1; $$->child[1] = $3; }
    | value MULTIPLIES value { $$ = create_node(MULTIPLIES); $$->child[0] = $1; $$->child[1] = $3; } //TODO other keyword for MULTIPLIES!
    | value TACKLES value { $$ = create_node(TACKLES); $$->child[0] = $1; $$->child[1] = $3; }
    | condition
    | value


value:
      NUMBER
    | NUMBER ':' NUMBER { $$ = create_node(FLOAT); $$->child[0] = $1; $$->child[1] = $3; } //float
    | STRING
    | ID
    | IN
    | OUT


%%

astnode_t* create_node(int type) {
    astnode_t* node = calloc(1, sizeof *node);
    node->type = type;
    return node;
}

int compile_ast(astnode_t* root) {
    // Your code to compile the AST goes here
    return 0;
}

void print_ast(astnode_t* node, int level) {
    if (node == NULL) return;

    // Indentation for levels
    for (int i = 0; i < level; i++) {
        printf("  ");
    }

    // Print node type and value
    printf("Node Type: %d", node->type);
    if (node->val.str) {
        printf(", Value: %s\n", node->val.str);
    } else {
        printf("\n");
    }

    // Recursively print children
    for (int i = 0; i < 10; i++) {
        if(node->child[i] != NULL) {

            print_ast(node->child[i], level + 1);
        }
    }
}



int main(int argc, char **argv) {
    // Your main function code
    return yyparse();
}
