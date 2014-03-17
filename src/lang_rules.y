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

	std::list<cinroll::nodes::definition*>* tuple_def;

	//Data
	str identifier;
}

//Tokens
%token INTEGER IDENTIFIER STRING BYTE SYMBOL
%token TOKEN_STATEMENT_END TOKEN_EQUAL TOKEN_PARENTHESIS_BEGIN TOKEN_PARENTHESIS_END TOKEN_BLOCK_BEGIN TOKEN_BLOCK_END TOKEN_DEFINE TOKEN_EOF TOKEN_COMMA_SEPARATOR
%token STATEMENT_SHOW

//Types from yylval for the rules
%type <number> INTEGER
%type <identifier> IDENTIFIER SYMBOL
%type <string> STRING

%type <expression> expression
%type <statement> statement
%type <def> definition
%type <identifier_call> identifier_call
%type <function_call> function_call

%type <tuple_def> tuple_definition

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
statement: definition        { $$ = $1; std::cout << "Defines " << $1->str << " = " << $1->expr << std::endl;}
         | STATEMENT_SHOW expression { $$ = NULL; std::cout << *$2 << std::endl; delete $2; }
         ;

definition: identifier_call IDENTIFIER TOKEN_EQUAL expression                                         { $$ = new cinroll::nodes::definition(currentScope,std::string($2.ptr,$2.length),$1,$4); }
          | identifier_call IDENTIFIER TOKEN_PARENTHESIS_BEGIN tuple_definition TOKEN_PARENTHESIS_END { $$ = new cinroll::nodes::definition(currentScope,std::string($2.ptr,$2.length)); }
          | identifier_call IDENTIFIER                                                                { $$ = new cinroll::nodes::definition(currentScope,std::string($2.ptr,$2.length)); }
          | identifier_call                                                                           { $$ = new cinroll::nodes::definition(currentScope,""); }
          ;//TODO: datatype instead of IDENTIFIER for the type

tuple_definition: definition                                        { $$ = new std::list<cinroll::nodes::definition*>(); $$->push_front($1); }
                | definition TOKEN_COMMA_SEPARATOR tuple_definition { $3->push_front($1); }
                ;

//////////////////////////////////////////////////////////////
//Expressions
expression: INTEGER         { $$ = $1; }
          | STRING          { $$ = $1; }
          | identifier_call { $$ = $1; }
          | function_call   { $$ = $1; }
          | TOKEN_PARENTHESIS_BEGIN expression TOKEN_PARENTHESIS_END { $$ = $2; }
          ;

identifier_call: IDENTIFIER { $$ = new cinroll::nodes::identifier_call(std::string($1.ptr,$1.length)); }
               | SYMBOL     { $$ = new cinroll::nodes::identifier_call(std::string($1.ptr,$1.length)); }
               | TOKEN_COMMA_SEPARATOR { $$ = new cinroll::nodes::identifier_call(std::string(",",1)); }
               ;

function_call: expression TOKEN_PARENTHESIS_BEGIN expression TOKEN_PARENTHESIS_END { $$ = new cinroll::nodes::function_call($1,$3); }
             | expression identifier_call expression                               { $$ = new cinroll::nodes::function_call($2,$1); }
             ;
%%

void yyerror(const char* str){
	fprintf(stderr,"Parsing Error: %s\n",str);
}
