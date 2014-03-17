#include "main.hpp"
#include "lang_rules.hpp"
#include "nodes/expression.hpp"

cinroll::nodes::expression* program;
cinroll::structures::scope* currentScope;

int main(){
	auto _program = new cinroll::nodes::block();
	program = _program;
	currentScope = _program;

	//Begin parsing using rules and tokens
	yyparse();
}
