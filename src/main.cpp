#include "main.hpp"
#include "lang_rules.hpp"
#include "nodes/expression.hpp"

int main(){
	program = new cinroll::block();

	//Begin parsing using rules and tokens
	yyparse();
}
