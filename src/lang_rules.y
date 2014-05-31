%debug
%defines
%locations
%error-verbose

//%glr-parser

%code requires{
	#include "nodes/all.hpp"
	#include "main.hpp"
	#include <string>
	#include <iostream>

	//Declarations
	#define YYERROR_VERBOSE 1

	extern int yylineno;
	extern int yylex();
	extern void yyerror(const char* str);

	struct str{
		size_t length;
		char* ptr;
	};
}

//Defines the type of yylval
%union{
	//Token enumerator IDs
	int token;

	//Token storage IDs
	cinroll::nodes::statement* statement;
    cinroll::nodes::definition* def;

	cinroll::nodes::expression* expression;
		cinroll::nodes::string_literal* string;
		cinroll::nodes::number_literal* number;

		cinroll::nodes::identifier_call* identifier_call;
    cinroll::nodes::function_call* function_call;
		cinroll::nodes::binary_operation* binary_operation;

	std::list<cinroll::nodes::definition*>* defs_tuple;

	//Data
	str identifier;
}

//Tokens
%token TOKEN_STATEMENT_END TOKEN_EQUAL TOKEN_PARENTHESIS_BEGIN TOKEN_PARENTHESIS_END TOKEN_BLOCK_BEGIN TOKEN_BLOCK_END TOKEN_COMMA_SEPARATOR
%token STATEMENT_SHOW

//Types from yylval for the rules
%token <number> INTEGER
%token <identifier> IDENTIFIER SYMBOL
%token <string> STRING

%type <expression> expression value_expression complex_expression type_expression
%type <statement> statement scoped_statement
%type <def> definition declaration function_declaration identifier_declaration
%type <identifier_call> identifier_call
%type <function_call> function_call unary_operation
%type <binary_operation> binary_operation
%type <identifier> identifier

%type <defs_tuple> definitions_tuple

%precedence TOKEN_EQUAL
%left TOKEN_COMMA_SEPARATOR
%precedence UNARY_OP_CALL
%left SYMBOL
%precedence TOKEN_PARENTHESIS_BEGIN

//Start in rule `statements`
%start statements

//Rules
%%

statements: statements statement TOKEN_STATEMENT_END {}
          | statements TOKEN_STATEMENT_END           {}
          | %empty
          ;

identifier: IDENTIFIER
          | SYMBOL
          ;

//////////////////////////////////////////////////////////////
//Statements
statement: definition {
                      $$ = $1;
                      std::cout << "Defines \"" << $1->identifier << '"';
                      if($1->type)std::cout << " of type \"" << *$1->type << '"';
                      if($1->expr)std::cout << " = " << *$1->expr;
                      std::cout << std::endl;
                      }
         | STATEMENT_SHOW expression         { $$ = NULL; std::cout << *$2 << std::endl; delete $2; }
         | type_expression scoped_statement { $$ = NULL; delete $1;}
         ;

scoped_statement: TOKEN_BLOCK_BEGIN statement TOKEN_BLOCK_END { $$ = NULL; }
                ;

definition: declaration
          | declaration TOKEN_EQUAL expression { $$->expr = $3; }
          ;

declaration: function_declaration
           | identifier_declaration
           ;

function_declaration: identifier_declaration TOKEN_PARENTHESIS_BEGIN definitions_tuple TOKEN_PARENTHESIS_END
                    ;

identifier_declaration: type_expression identifier { $$ = new cinroll::nodes::definition(currentScope,std::string($2.ptr,$2.length),$1); }
                      ;

definitions_tuple: definition                                         { $$ = new std::list<cinroll::nodes::definition*>(); $$->push_front($1); }
                 | definition TOKEN_COMMA_SEPARATOR definitions_tuple { $3->push_front($1); }
                 ;

//////////////////////////////////////////////////////////////
//Expressions
expression: value_expression
          | complex_expression
          ;

value_expression: INTEGER { $$ = $1; }
                | STRING  { $$ = $1; }
                | TOKEN_PARENTHESIS_BEGIN value_expression TOKEN_PARENTHESIS_END { $$ = $2; }
                ;

complex_expression: identifier_call  { $$ = $1; }
                  | binary_operation { $$ = $1; }
                  | function_call    { $$ = $1; }
                  | unary_operation  { $$ = $1; }
                  | TOKEN_PARENTHESIS_BEGIN complex_expression TOKEN_PARENTHESIS_END { $$ = $2; }
                  ;

type_expression: identifier_call { $$ = $1; }
               | function_call   { $$ = $1; }
               | TOKEN_PARENTHESIS_BEGIN complex_expression TOKEN_PARENTHESIS_END { $$ = $2; }
               ;

identifier_call: identifier { $$ = new cinroll::nodes::identifier_call(std::string($1.ptr,$1.length)); }
               ;

function_call: type_expression TOKEN_PARENTHESIS_BEGIN expression TOKEN_PARENTHESIS_END { $$ = new cinroll::nodes::function_call($1,$3); }
             ;

unary_operation: SYMBOL expression %prec UNARY_OP_CALL { $$ = new cinroll::nodes::function_call(new cinroll::nodes::identifier_call(std::string($1.ptr,$1.length)),$2); }
               ;

binary_operation: expression SYMBOL expression                { $$ = new cinroll::nodes::binary_operation(new cinroll::nodes::identifier_call(std::string($2.ptr,$2.length)),$1,$3); }
                | expression TOKEN_COMMA_SEPARATOR expression { $$ = new cinroll::nodes::binary_operation(new cinroll::nodes::identifier_call(","),$1,$3); }
                ;
%%

void yyerror(const char* str){
	fprintf(stderr,"Parsing Error: %s\n",str);
}
