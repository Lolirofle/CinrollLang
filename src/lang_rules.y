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
  cinroll::nodes::expression* expression;
    cinroll::nodes::string_literal*  string;
    cinroll::nodes::number_literal*  number;

    cinroll::nodes::identifier_call* identifier_call;
    cinroll::nodes::definition* def;

  //Data
  str identifier;
}

//Tokens
%token INTEGER IDENTIFIER STRING BYTE
%token TOKEN_STATEMENT_END TOKEN_EQUAL TOKEN_PARENTHESIS_BEGIN TOKEN_PARENTHESIS_END TOKEN_BLOCK_BEGIN TOKEN_BLOCK_END TOKEN_DEFINE TOKEN_EOF TOKEN_COMMASEPARATOR

//Types from yylval for the rules
%type <number> INTEGER
%type <identifier> IDENTIFIER
%type <string> STRING

%type <expression> expression
%type <def> definition
%type <identifier_call> identifier_call

//Start in rule `program`
%start program

//Rules
%%

program: program expression TOKEN_STATEMENT_END { std::cout << *$2 << std::endl; delete $2; }
       | program TOKEN_STATEMENT_END            {}
       | /* Empty */
       ;

//////////////////////////////////////////////////////////////
//Expressions
expression: INTEGER         { $$ = $1; }
          | STRING          { $$ = $1; }
          | definition      { $$ = $1; }
          | identifier_call { $$ = $1; }
          | TOKEN_PARENTHESIS_BEGIN expression TOKEN_PARENTHESIS_END { $$ = $2; }
          | expression TOKEN_COMMASEPARATOR expression               { $$ = $1; }
          ;

definition: identifier_call IDENTIFIER TOKEN_EQUAL expression                                   { $$ = new cinroll::nodes::definition(currentScope,std::string($2.ptr,$2.length),$1,$4); }
          | identifier_call IDENTIFIER TOKEN_PARENTHESIS_BEGIN definition TOKEN_PARENTHESIS_END { $$ = new cinroll::nodes::definition(currentScope,std::string($2.ptr,$2.length)); }
          | identifier_call IDENTIFIER                                                          { $$ = new cinroll::nodes::definition(currentScope,std::string($2.ptr,$2.length)); }
          ;//TODO: datatype instead of IDENTIFIER for the type

identifier_call: IDENTIFIER TOKEN_PARENTHESIS_BEGIN expression TOKEN_PARENTHESIS_END { $$ = new cinroll::nodes::identifier_call(std::string($1.ptr,$1.length),$3); }
               | IDENTIFIER                                                          { $$ = new cinroll::nodes::identifier_call(std::string($1.ptr,$1.length)); }
               ;

%%

void yyerror(const char* str){
	fprintf(stderr,"Parsing Error: %s\n",str);
}
