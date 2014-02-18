%{
	#include "lang_rules.hpp"
	#include "nodes/expression.hpp"
	#include "number_converter.hpp"
	
	#define TOKEN(t) (yylval.token = t)
	#define YY_NO_INPUT

	extern "C" int yywrap(){
		return 1;
	}
%}

%option nounput

%%

[ \t]|(\/\*(.*)\*\/)|(\/\/([^\n]*)) ;

[;\n] {
	return TOKEN(TOKEN_STATEMENT_END);
}

"def"    return TOKEN(TOKEN_DEFINE);
":"      return TOKEN(TOKEN_TYPEHINT);

[A-Za-z][A-Za-z0-9]* {//Identifier
	yylval.identifier = new cinroll::nodes::identifier(std::string(yytext,yyleng));
	return IDENTIFIER;
}

[0-9]+ {//Integers
	yylval.number = new cinroll::nodes::number_literal(std::string(yytext,yyleng));
	return INTEGER;
}

\'(.)\' {//Char //TODO: Enforce "Char" type
	yylval.number = new cinroll::nodes::number_literal(std::string(yytext+1,1),cinroll::number_converter_char);
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
