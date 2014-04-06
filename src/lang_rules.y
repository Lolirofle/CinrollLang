%debug
%defines
%locations
%error-verbose

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

%type <expression> expression value_expression complex_expression
%type <statement> statement
%type <def> definition declaration function_declaration identifier_declaration
%type <identifier_call> identifier_call
%type <function_call> function_call
%type <binary_operation> binary_operation

%type <defs_tuple> definitions_tuple

%precedence TOKEN_EQUAL
%nonassoc TOKEN_PARENTHESIS_START
%left TOKEN_COMMA_SEPARATOR
%left SYMBOL
%precedence UNARY_OP_CALL

//Start in rule `program`
%start program

//Rules
%%

program: program statement TOKEN_STATEMENT_END {}
       | program TOKEN_STATEMENT_END           {}
       | %empty
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
         | STATEMENT_SHOW expression { $$ = NULL; std::cout << *$2 << std::endl; delete $2; }
         ;

definition: declaration
          | declaration TOKEN_EQUAL expression { $$->expr = $3; }
          ;

declaration: function_declaration
           | identifier_declaration
           ;

function_declaration: identifier_declaration TOKEN_PARENTHESIS_BEGIN definitions_tuple TOKEN_PARENTHESIS_END
                    ;

identifier_declaration: complex_expression IDENTIFIER { $$ = new cinroll::nodes::definition(currentScope,std::string($2.ptr,$2.length),$1); }
                      | complex_expression SYMBOL     { $$ = new cinroll::nodes::definition(currentScope,std::string($2.ptr,$2.length),$1); }
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
                  | function_call    { $$ = $1; }
                  | binary_operation { $$ = $1; }
                  | TOKEN_PARENTHESIS_BEGIN complex_expression TOKEN_PARENTHESIS_END { $$ = $2; }
                  ;

identifier_call: IDENTIFIER { $$ = new cinroll::nodes::identifier_call(std::string($1.ptr,$1.length)); }
//               | SYMBOL     { $$ = new cinroll::nodes::identifier_call(std::string($1.ptr,$1.length)); }
               ;

function_call: complex_expression expression %prec UNARY_OP_CALL { $$ = new cinroll::nodes::function_call($1,$2); }
             ;

binary_operation: expression SYMBOL expression                { $$ = new cinroll::nodes::binary_operation(new cinroll::nodes::identifier_call(std::string($2.ptr,$2.length)),$1,$3); }
                | expression TOKEN_COMMA_SEPARATOR expression { $$ = new cinroll::nodes::binary_operation(new cinroll::nodes::identifier_call(","),$1,$3); }
                ;
%%

void yyerror(const char* str){
	fprintf(stderr,"Parsing Error: %s\n",str);
}
