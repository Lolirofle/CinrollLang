%{
	#include "lang_rules.hpp"
	#include "nodes/all.hpp"
	
	#define TOKEN(t) (yylval.token = t)
	#define YY_NO_INPUT

	extern "C" int yywrap(){
		return 1;
	}
%}

%option nounput

%%

[ \t\n]|(\/\*(.*)\*\/)|(\/\/([^\n]*)) ;

[;] {
	return TOKEN(TOKEN_STATEMENT_END);
}

[,] {
	return TOKEN(TOKEN_COMMA_SEPARATOR);
}

"SHOW" {
	return TOKEN(STATEMENT_SHOW);
}

[A-Za-z_][A-Za-z_0-9]* {//Identifier
	yylval.identifier = (str){(size_t)yyleng,yytext};
	return IDENTIFIER;
}

[0-9][0-9_]* {//Integers
	yylval.number = new cinroll::nodes::base10_number_literal(std::string(yytext,yyleng));
	return INTEGER;
}

[=]?[+\-*/!#%&?<>|]+ {//Symbols
	yylval.identifier = (str){(size_t)yyleng,yytext};
	return SYMBOL;
}

\'(.)\' {//Char //TODO: Enforce "Char" type
	yylval.number = new cinroll::nodes::char_number_literal(std::string(yytext+1,1));
	return STRING;
}

\"(.*)\" {//String
	yylval.string = new cinroll::nodes::string_literal(std::string(yytext+1,yyleng-2));
	return STRING;
}

"=" return TOKEN(TOKEN_EQUAL);
"(" return TOKEN(TOKEN_PARENTHESIS_BEGIN);
")" return TOKEN(TOKEN_PARENTHESIS_END);
"{" return TOKEN(TOKEN_BLOCK_BEGIN);
"}" return TOKEN(TOKEN_BLOCK_END);

%%
