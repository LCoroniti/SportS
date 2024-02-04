%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>
#include <errno.h>
#include "vm/vm.h"
#include <portaudio.h>


extern int yylineno;
extern FILE *yyin;
int yylex(void);
void yyerror(const char *s) {
    fprintf(stderr, "Line %d: %s\n", yylineno, s);
}

typedef struct astnode astnode_t;
struct astnode{
    int type;
    union {
        int num;
        char* id;
        char* str;
        arr_t* arr;
        float flt;
    }val;
    struct astnode *child[5];
};
astnode_t* create_node(int type);

void optimize_ast(astnode_t* node);
int compile_ast(astnode_t* root);
void print_ast_dot(astnode_t* node, int depth);
void print_ast(astnode_t* node, int level);
void whistle();
%}

%define parse.error verbose

%union {
    int num;
    char* id;
    char* str;
    struct astnode* ast;
}

%type <ast> program statement variable_declaration assignment function_declaration
%type <ast> control_structure print_statement expression value function_call
%type <ast> condition tie_or_lose_branch parameter_def parameter_call expression_list
%type <ast> float datatype number string id boolean global_definition error aid
%type <ast> swap_statement

%token <str> function val param_def param_call assign_member array_is array_member expr_list
%token <str> IN OUT PROGRAM FLOAT PLAYER SCORE GOAL TEAM SET CNTRL ALLSTAR AID
%token <str> START_WHISTLE END_WHISTLE STRATEGY PLAY WIN TIE LOSE
%token <str> PENALTY_SHOOTOUT PRACTICE ANNOUNCE RESULT TIMEOUT SUBSTITUTE
%token <str> INBOUNDS OUTBOUNDS LEADS TRAILS LEADS_OR_TIES TRAILS_OR_TIES
%token <str> SCORES LOSES MULTIPLIES TACKLES ANDGOAL ORGOAL NOTGOAL REMAINDER
%token <str> SETS REFEREE INJURY USING
%token <num> NUMBER
%token <str> ID COACH IS STRING
//%token <str> FOUL OFFSIDE

//TODO: is this right?
// Define operator precedence and associativity here

%left ANDGOAL ORGOAL
%left SCORES LOSES
%left MULTIPLIES TACKLES
%left INBOUNDS OUTBOUNDS LEADS TRAILS LEADS_OR_TIES TRAILS_OR_TIES

%start start

%%
//TODO: as an extra add sounds (is this even possible?) would support the sport theme
//TODO: error handling

//TODO: include break (TIMEOUT) and continue (*name needed*) statements

//TODO: datatypes not used yet ... problems in usage?
    //TODO: add type checking
//TODO: ANNOUNCE parameter_call in one print not for each one
//TODO: call programs with parameters

//TODO: gloabal variables

start:
    program {
    //TODO: add sound
    //whistle();
    optimize_ast($1);
    compile_ast($1);
    print_ast($1, 0);
    print_ast_dot($1, 0);
    }


program:
      program statement { $$ = create_node(PROGRAM); $$->child[0] = $1; $$->child[1] = $2; }
    | %empty { $$ = NULL; }


statement:
      variable_declaration
    | global_definition
    | assignment
    | function_declaration
    | control_structure
    | print_statement
    | swap_statement
    | function_call
    | condition


global_definition:
      ALLSTAR datatype aid IS condition { $$ = create_node(ALLSTAR); $$->child[0] = $2; $$->child[1] = $3; $$->child[2] = $5; }
    | ALLSTAR aid IS condition { $$ = create_node(ALLSTAR); $$->child[0] = NULL; $$->child[1] = $2; $$->child[2] = $4; }
    | aid IS condition { $$ = create_node(ALLSTAR); $$->child[0] = NULL; $$->child[1] = $1; $$->child[2] = $3; }

aid:
    AID { $$ = create_node(AID); $$->val.id = $1; }


variable_declaration:
      datatype id { $$ = create_node(ID); $$->child[1] = $2; }
      | TEAM id { $$ = create_node(ID); $$->child[1] = $2; }

assignment:
      datatype id IS condition { $$ = create_node(IS); $$->child[1] = $2; $$->child[2] = $4;}
      | id IS condition { $$ = create_node(IS); $$->child[1] = $1; $$->child[2] = $3;}
      | TEAM id IS '|' expression_list '|' { $$ = create_node(array_is); $$->child[1] = $2; $$->child[2] = $5; }
      | id IS '|' expression_list '|' { $$ = create_node(array_is); $$->child[1] = $1; $$->child[2] = $4; }
      | id '#' expression IS expression { $$ = create_node(assign_member); $$->child[0] = $1; $$->child[1] = $3; $$->child[2] = $5; }


datatype:
      PLAYER { $$ = create_node(PLAYER); }
    | SCORE { $$ = create_node(SCORE); }
    | GOAL { $$ = create_node(GOAL); }

function_declaration:
      STRATEGY id USING '|' parameter_def '|' START_WHISTLE program RESULT expression END_WHISTLE
      { $$ = create_node(function); $$->child[0] = $2; $$->child[1] = $5; $$->child[2] = $8; $$->child[3] = $10;}

parameter_def:
      parameter_def id { $$ = create_node(param_def); $$->child[0] = $1; $$->child[1] = $2; }
    | id { $$ = create_node(param_def); $$->child[0] = NULL; $$->child[1] = $1; }
    | %empty { $$ = NULL; }

function_call:
      PLAY id USING '|' parameter_call '|' { $$ = create_node(PLAY); $$->child[0] = $2; $$->child[1] = $5; }

parameter_call:
      parameter_call statement { $$ = create_node(param_call); $$->child[0] = $1; $$->child[1] = $2; }
    | statement { $$ = create_node(param_call); $$->child[0] = NULL; $$->child[1] = $1; }
    | %empty { $$ = NULL; }

control_structure:
      WIN condition START_WHISTLE program END_WHISTLE tie_or_lose_branch { $$ = create_node(WIN); $$->child[0] = $2; $$->child[1] = $4; $$->child[2] = $6; }
    | PENALTY_SHOOTOUT condition START_WHISTLE program END_WHISTLE { $$ = create_node(PENALTY_SHOOTOUT); $$->child[0] = $2; $$->child[1] = $4; }

tie_or_lose_branch:
       tie_or_lose_branch TIE condition START_WHISTLE program END_WHISTLE { $$ = create_node(TIE); $$->child[0] = $1; $$->child[1] = $3; $$->child[2] = $5; }
    |  tie_or_lose_branch LOSE START_WHISTLE program END_WHISTLE { $$ = create_node(LOSE); $$->child[0] = $1; $$->child[1] = $4; }
    | TIE condition START_WHISTLE program END_WHISTLE { $$ = create_node(TIE); $$->child[0] = NULL; $$->child[1] = $2; $$->child[2] = $4; }
    | %empty { $$ = NULL; }

condition:
      expression ANDGOAL expression { $$ = create_node(ANDGOAL); $$->child[0] = $1; $$->child[1] = $3; }
    | expression ORGOAL expression { $$ = create_node(ORGOAL); $$->child[0] = $1; $$->child[1] = $3; }
    | NOTGOAL expression { $$ = create_node(NOTGOAL); $$->child[0] = $2; }
    | expression INBOUNDS expression { $$ = create_node(INBOUNDS); $$->child[0] = $1; $$->child[1] = $3; }
    | expression OUTBOUNDS expression { $$ = create_node(OUTBOUNDS); $$->child[0] = $1; $$->child[1] = $3; }
    | expression LEADS expression { $$ = create_node(LEADS); $$->child[0] = $1; $$->child[1] = $3; }
    | expression TRAILS expression { $$ = create_node(TRAILS); $$->child[0] = $1; $$->child[1] = $3; }
    | expression LEADS_OR_TIES expression { $$ = create_node(LEADS_OR_TIES); $$->child[0] = $1; $$->child[1] = $3; }
    | expression TRAILS_OR_TIES expression { $$ = create_node(TRAILS_OR_TIES); $$->child[0] = $1; $$->child[1] = $3; }
    | expression


print_statement:
      ANNOUNCE '|' parameter_call '|'{ $$ = create_node(ANNOUNCE); $$->child[0] = $3; }


swap_statement:
        SUBSTITUTE expression '-' expression { $$ = create_node(SUBSTITUTE); $$->child[0] = $2; $$->child[1] = $4;}

expression_list:
      expression_list expression { $$ = create_node(expr_list); $$->child[0] = $1; $$->child[1] = $2; }
    | expression { $$ = create_node(expr_list); $$->child[0] = NULL; $$->child[1] = $1; }

expression:
     value REMAINDER expression { $$ = create_node(REMAINDER); $$->child[0] = $1; $$->child[1] = $3; }
    | value SCORES expression { $$ = create_node(SCORES); $$->child[0] = $1; $$->child[1] = $3; }
    | value LOSES expression { $$ = create_node(LOSES); $$->child[0] = $1; $$->child[1] = $3; }
    | value MULTIPLIES expression { $$ = create_node(MULTIPLIES); $$->child[0] = $1; $$->child[1] = $3; }
    | value TACKLES expression { $$ = create_node(TACKLES); $$->child[0] = $1; $$->child[1] = $3; }
    | value
    | function_call
    | id '#' expression { $$ = create_node(array_member); $$->child[0] = $1; $$->child[1] = $3; }
    | %empty { $$ = NULL; }


value:
      number
    | float
    | string
    | id
    | boolean


number:
      NUMBER { $$ = create_node(NUMBER); $$->val.num = $1; }

string:
      STRING { $$ = create_node(STRING); $$->val.str = $1; }

id:
      AID { $$ = create_node(AID); $$->val.id = $1; }
    | ID { $$ = create_node(ID); $$->val.id = $1; }

boolean:
      IN { $$ = create_node(IN); $$->val.str = $1; }
    | OUT { $$ = create_node(OUT); $$->val.str = $1; }

float:
      number ':' number { $$ = create_node(FLOAT); $$->child[0] = $1; $$->child[1] = $3; }

/*
error:
       %empty {$$ = NULL}
     | error FOUL
     | error OFFSIDE
     | error HANDBALL
     ;
*/


%%

prog_t *p;

astnode_t* create_node(int type) {
    astnode_t* node = calloc(1, sizeof *node);
    node->type = type;
    return node;
}

const char* get_node_type_name(int type) {
    switch (type) {
        case PROGRAM: return "PROGRAM";
        case AID: return "AID";
        case ID: return "ID";
        case NUMBER: return "NUMBER";
        case FLOAT: return "FLOAT";
        case STRING: return "STRING";
        case IN: return "IN";
        case OUT: return "OUT";
        case function: return "function";
        case PLAY: return "PLAY";
        case ANNOUNCE: return "ANNOUNCE";
        case WIN: return "WIN";
        case TIE: return "TIE";
        case LOSE: return "LOSE";
        case PENALTY_SHOOTOUT: return "PENALTY_SHOOTOUT";
        case ANDGOAL: return "ANDGOAL";
        case ORGOAL: return "ORGOAL";
        case NOTGOAL: return "NOTGOAL";
        case INBOUNDS: return "INBOUNDS";
        case OUTBOUNDS: return "OUTBOUNDS";
        case LEADS: return "LEADS";
        case TRAILS: return "TRAILS";
        case LEADS_OR_TIES: return "LEADS_OR_TIES";
        case TRAILS_OR_TIES: return "TRAILS_OR_TIES";
        case REMAINDER: return "REMAINDER";
        case SCORES: return "SCORES";
        case LOSES: return "LOSES";
        case MULTIPLIES: return "MULTIPLIES";
        case TACKLES: return "TACKLES";
        case SET: return "SET";
        case CNTRL: return "CNTRL";
        case PLAYER: return "PLAYER";
        case SCORE: return "SCORE";
        case GOAL: return "GOAL";
        case param_def: return "parameter_def";
        case param_call: return "parameter_call";
        case expr_list: return "expression_list";
        case val: return "value";
        case IS: return "IS";
        case array_is: return "array_is";
        case assign_member: return "assign_member";
        case array_member: return "array_member";
        case ALLSTAR: return "ALLSTAR";
        default: return "UNKNOWN";
    }
}

void optimize_ast(astnode_t* node) {
    if (node == NULL) return;

    for (int i = 0; i < 5; i++) {
        optimize_ast(node->child[i]);
    }

    // Type checking and conversion
    int hasFloat = 0;
    for (int i = 0; i < 5; i++) {
        //TODO: if child is id check if its value is a float

        if (node->child[i] != NULL && node->child[i]->type == FLOAT) {
            hasFloat = 1;
            break;
        }
    }

    if (hasFloat) {
        for (int i = 0; i < 5; i++) {
            if (node->child[i] != NULL && node->child[i]->type == NUMBER && node->type != FLOAT) {
                astnode_t* fl = calloc(1, sizeof *node);
                fl->type = FLOAT;
                astnode_t* n1 = calloc(1, sizeof *node);
                n1->type = NUMBER;
                n1->val.num = node->child[i]->val.num;
                astnode_t* n2 = calloc(1, sizeof *node);
                n2->type = NUMBER;
                n2->val.num = 0;
                fl->child[0] = n1;
                fl->child[1] = n2;
                node->child[i] = fl;

            }
        }
    }

    //constant folding
    if(node->type == SCORES || node->type == LOSES || node->type == MULTIPLIES || node->type == TACKLES || node->type == REMAINDER) {
        if(node->child[0]->type == NUMBER && node->child[1]->type == NUMBER) {
            int result;
            switch (node->type) {
                case SCORES:
                    result = node->child[0]->val.num + node->child[1]->val.num;
                    break;
                case LOSES:
                    result = node->child[0]->val.num - node->child[1]->val.num;
                    break;
                case MULTIPLIES:
                    result = node->child[0]->val.num * node->child[1]->val.num;
                    break;
                case TACKLES:
                    result = node->child[0]->val.num / node->child[1]->val.num;
                    break;
                case REMAINDER:
                    result = node->child[0]->val.num % node->child[1]->val.num;
                    break;
                default:
                    break;
            }
            node->type = NUMBER;
            node->val.num = result;
            node->child[0] = NULL;
            node->child[1] = NULL;
        }

    }

}

void print_ast_dot(astnode_t* node, int depth) {
    static FILE* dot;
    if (depth == 0) {
        dot = fopen("ast.gv", "w");
        fprintf(dot, "digraph ast {\n");
    }
    if (node == NULL) return;

    // Print node to file
    fprintf(dot, "\"%p\" [label=\"Type: %s", (void*)node, get_node_type_name(node->type));
    switch (node->type) {
        case NUMBER:
            fprintf(dot, "\\nNumber: %d", node->val.num);
            break;
        case STRING:
            fprintf(dot, "\\nString: %s", node->val.str);
            break;
        case ID:
            fprintf(dot, "\\nID: %s", node->val.id);
            break;
        default:
            break;
    }
    fprintf(dot, "\"];\n");

    // Print edges to children
    for (int i = 0; i < 5; i++) {
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

void print_ast(astnode_t* node, int level) {
    if (node == NULL) return;

    // Indentation for levels
    for (int i = 0; i < level; i++) {
        printf("  ");
    }

    // Print node type and value based on node type
    printf("Node Type: %s", get_node_type_name(node->type));
    switch (node->type) {
        case NUMBER:
            printf(", Number: %d\n", node->val.num);
            break;
        case STRING:
            printf(", String: %s\n", node->val.str);
            break;
        case ID:
            printf(", ID: %s\n", node->val.id);
            break;
        case FLOAT:
            printf(", Float: %d:%d\n", node->child[0]->val.num, node->child[1]->val.num);
            break;
        default:
            printf("\n");
    }

    // Recursively print children
    for (int i = 0; i < 5; i++) {
        if(node->child[i] != NULL) {
            print_ast(node->child[i], level + 1);
        }
    }
}

int compile_ast(astnode_t* root) {
    int c, nrparams, jmp, pc, jt;
    struct var *v;


    if (root == NULL) return 0;
    printf("Node Type: %s\n", get_node_type_name(root->type));

    switch (root->type) {
        case PROGRAM:
            compile_ast(root->child[0]);
            compile_ast(root->child[1]);
            break;
        case function:
            jmp = prog_add_num(p, -1);
            prog_add_op(p, JUMP);
            var_reset();
            compile_ast(root->child[1]);
            prog_register_function(p, root->child[0]->val.id, prog_next_pc(p));
            compile_ast(root->child[2]);
            compile_ast(root->child[3]);
            prog_add_op(p, RET);
            prog_set_num(p, jmp, prog_next_pc(p));
            break;
        case PLAY:
            nrparams = 0;
            if (root->child[1] != NULL) {
                nrparams = compile_ast(root->child[1])+1;
            }
            prog_add_num(p, nrparams);
            c = prog_new_constant(p, v_str_new_cstr(root->child[0]->val.id));
            prog_add_num(p, c);
            prog_add_op(p, CONSTANT);
            //TODO: set the parameter variables with the values from the parameter call
            prog_add_op(p, CALL);
            break;
        case param_def:
            compile_ast(root->child[0]);
            v = var_add_local(root->child[1]->val.id);
            break;
        case param_call:
            compile_ast(root->child[1]);
            if(root->child[0] != NULL) {
                c = compile_ast(root->child[0]) + 1;
            } else {
                c = 0;
            }
            return c;
            break;
        case expr_list:
            compile_ast(root->child[1]);
            if(root->child[0] != NULL) {
                c = compile_ast(root->child[0]) + 1;
            } else {
                c = 0;
            }
            return c;
            break;
        case ALLSTAR:
            compile_ast(root->child[2]); //value
            v = var_add_global(root->child[1]->val.id);
            prog_add_num(p, v->nr);
            prog_add_op(p, SETGLOBAL);
            break;

        case IS:
            compile_ast(root->child[2]);
            v = var_get_or_addlocal(root->child[1]->val.id);
            prog_add_num(p, v->nr);
            prog_add_op(p, SETVAR);
            break;
        case array_is:
            nrparams = 0;
            if (root->child[2] != NULL) {
                nrparams = compile_ast(root->child[2])+1;
                printf("nrparams: %d\n", nrparams);
            }
            prog_add_num(p, nrparams);
            prog_add_op(p, MKARRAY);
            v = var_get_or_addlocal(root->child[1]->val.id);
            prog_add_num(p, v->nr);
            prog_add_op(p, SETVAR);
            prog_add_num(p, v->nr);
            break;
        case assign_member:
            compile_ast(root->child[2]); //value (expression)
            compile_ast(root->child[1]); //number
            compile_ast(root->child[0]); //id
            prog_add_op(p, INDEXAS);
            break;

        case array_member:
            compile_ast(root->child[1]); //number
            compile_ast(root->child[0]); //id
            prog_add_op(p, INDEX1);
            break;
        case val:
            compile_ast(root->child[0]);
            compile_ast(root->child[1]);
            break;

        case NUMBER:
            prog_add_num(p, root->val.num);
            break;
        case FLOAT:
            prog_add_num(p, root->child[1]->val.num);
            prog_add_num(p, root->child[0]->val.num);
            prog_add_op(p, MKFLOAT);
            break;
        case AID:
            v = var_get(root->val.id);
            prog_add_num(p, v->nr);
            prog_add_op(p, GETGLOBAL);
            break;
        case ID:
            v = var_get_or_addlocal(root->val.id);
            prog_add_num(p, v->nr);
            prog_add_op(p, GETVAR);
            break;
        case STRING:
            c = prog_new_constant(p, v_str_new_cstr(root->val.str));
            prog_add_num(p, c);
            prog_add_op(p, CONSTANT);
            break;
        case WIN:
            compile_ast(root->child[0]);
            prog_add_op(p, CONDBEGIN);
            compile_ast(root->child[1]);
            prog_add_op(p, CONDELSE);
            compile_ast(root->child[2]);
            prog_add_op(p, CONDEND);
            break;
        case TIE:
            compile_ast(root->child[0]);
            compile_ast(root->child[1]);
            prog_add_op(p, CONDBEGIN);
            compile_ast(root->child[2]);
            prog_add_op(p, CONDELSE);
            prog_add_op(p, CONDEND);
            break;
        case LOSE:
            compile_ast(root->child[0]);
            prog_add_op(p, CONDELSE);
            compile_ast(root->child[1]);
            prog_add_op(p, CONDEND);
            break;
        case PENALTY_SHOOTOUT:
            prog_add_op(p, LOOPBEGIN);
            compile_ast(root->child[0]);
            prog_add_op(p, LOOPBODY);
            compile_ast(root->child[1]);
            prog_add_op(p, LOOPEND);
            break;
        case OUTBOUNDS:
            compile_ast(root->child[1]);
            compile_ast(root->child[0]);
            prog_add_op(p, NOTEQUAL);
            break;
        case INBOUNDS:
            compile_ast(root->child[1]);
            compile_ast(root->child[0]);
            prog_add_op(p, EQUAL);
            break;
        case TRAILS:
            compile_ast(root->child[1]);
            compile_ast(root->child[0]);
            prog_add_op(p, LESS);
            break;
        case REMAINDER:
            compile_ast(root->child[1]);
            compile_ast(root->child[0]);
            prog_add_op(p, MOD);
            break;
        case TACKLES:
            compile_ast(root->child[1]);
            compile_ast(root->child[0]);
            prog_add_op(p, DIV);
            break;
        case MULTIPLIES:
            compile_ast(root->child[1]);
            compile_ast(root->child[0]);
            prog_add_op(p, MUL);
            break;
        case SCORES:
            compile_ast(root->child[1]);
            compile_ast(root->child[0]);
            prog_add_op(p, ADD);
            break;
        case LOSES:
            compile_ast(root->child[1]);
            compile_ast(root->child[0]);
            prog_add_op(p, SUB);
            break;
        case ANNOUNCE:
            nrparams = 0;
            if (root->child[0] != NULL) {
                nrparams = compile_ast(root->child[0])+1;
            }
            //print the n top values from the stack in one line
            prog_add_num(p, nrparams);
            prog_add_op(p, PRINTN);
            break;
        case SUBSTITUTE:
            //is working for array members and ids

            //e.g. array:  SUBSTITUTE list #startIndex - list #i
            //or: SUSTITUTE expression - expression

            //push value of child[0] on the stack
            compile_ast(root->child[0]);

            //push id of child[1] on the stack
            if(root->child[1]->type == ID) {
                v = var_get_or_addlocal(root->child[1]->val.id);
                prog_add_num(p, v->nr); //pushes the mapped number of the id on the stack
            } else if(root->child[1]->type == array_member) {
                compile_ast(root->child[1]->child[1]); //index number on stack (stack: id, index)
                v = var_get_or_addlocal(root->child[1]->child[0]->val.id);
                prog_add_num(p, v->nr); //pushes the mapped number of the id on the stack
            } else {
                printf("Given type for substitute is not supported!\n");
            }

            //push value of child[1] on the stack
            compile_ast(root->child[1]);

            //push id of child[0] on the stack
            if(root->child[0]->type == ID) {
                v = var_get_or_addlocal(root->child[0]->val.id);
                prog_add_num(p, v->nr); //pushes the mapped number of the id on the stack
            } else if(root->child[0]->type == array_member) {
                compile_ast(root->child[0]->child[1]); //index number on stack (stack: id, index)
                v = var_get_or_addlocal(root->child[0]->child[0]->val.id);
                prog_add_num(p, v->nr); //pushes the mapped number of the id on the stack

            } else {
                printf("Given type for substitute is not supported!\n");
            }

            //set child[0] with the value of child[1]
            //need to differentiate between id and array_member
            if(root->child[0]->type == ID) {
                prog_add_op(p, SETVAR);
            } else if(root->child[0]->type == array_member) {
                prog_add_op(p, GETVAR);
                prog_add_op(p, INDEXAS);
            } else {
                printf("Given type for substitute is not supported!\n");
            }

            //set child[1] with the value of child[0]
            //need to differentiate between id and array_member
            if(root->child[1]->type == ID) {
                prog_add_op(p, SETVAR);
            } else if(root->child[1]->type == array_member) {
                prog_add_op(p, GETVAR);
                prog_add_op(p, INDEXAS);
            } else {
                printf("Given type for substitute is not supported!\n");
            }

            break;
        default:
            printf("Unhandled AST node %s\n", get_node_type_name(root->type));
            assert(0);
            break;
    }


    return 0;
}



int main(int argc, char **argv) {
    p = prog_new();
    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        fprintf(stderr, "Could not open file: %s\n", strerror(errno));
        return 1;
    }
    int yylineno = 1;
    int st = yyparse();
    prog_dump(p);
    if (st == 0) {
        printf("Parse successful!\n");
    } else {
        printf("Parse failed!\n");
    }

    char bytecode[1000];
    snprintf(bytecode, 1000, "%s.vm3", argv[1]);
    prog_write(p, bytecode);
    exec_t *e = exec_new(p);
    exec_set_debuglvl(e, E_DEBUG2);
    exec_run(e);

    return st;
}
