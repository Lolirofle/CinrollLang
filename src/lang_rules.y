%debug
%defines
%locations
%error-verbose

%code requires{
  #include "nodes/expression.hpp"
  #include <string>
  #include <iostream>

  //Declarations
  #define YYERROR_VERBOSE 1

  extern int yylineno;
  extern int yylex();
  extern void yyerror(const char* str);
}

//Defines the type of yylval
%union{
  //Token enumerator IDs
  int token;

  //Token storage IDs
  cinroll::nodes::identifier*     identifier;
  cinroll::nodes::string_literal* string;
  cinroll::nodes::number_literal* number;

  cinroll::nodes::expression* expression;
}

//Tokens
%token INTEGER IDENTIFIER STRING BYTE
%token TOKEN_STATEMENT_END TOKEN_EQUAL TOKEN_PARENTHESIS_BEGIN TOKEN_PARENTHESIS_END TOKEN_BLOCK_BEGIN TOKEN_BLOCK_END TOKEN_DEFINE TOKEN_TYPEHINT

//Types from yylval for the rules
%type <number> INTEGER
%type <identifier> IDENTIFIER
%type <string> STRING

%type <expression> expression

//Start in rule `program`
%start program

//Rules
%%

program: program expression TOKEN_STATEMENT_END { $2->print(std::cout); std::cout << std::endl; delete $2; } ;
       | 
       ;

//////////////////////////////////////////////////////////////
//Expressions
expression: INTEGER    { $$ = $1; }
          | IDENTIFIER { $$ = $1; }
          | STRING     { $$ = $1; }
          ;

%%

void yyerror(const char* str){
	fprintf(stderr,"Parsing Error: %s\n",str);
}
