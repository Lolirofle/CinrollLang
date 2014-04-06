#include "definition.hpp"

namespace cinroll{namespace nodes{
	definition::definition(cinroll::structures::scope* scope,std::string identifier,expression* type,expression* expr,std::list<cinroll::nodes::definition*>* args) : identifier(identifier),expr(expr),type(type),args(args){
		scope->definitions[identifier]=expr;//TODO: SHould this happen in beforehand like it does now and not when compiled?
	}

	definition::~definition(){
		delete this->expr;
	}
}}
