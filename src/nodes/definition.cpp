#include "definition.hpp"

namespace cinroll{namespace nodes{
	definition::definition(cinroll::structures::scope* scope,std::string str,expression* type,expression* expr) : str(str),expr(expr),type(type){
		scope->definitions[str]=expr;//TODO: SHould this happen in beforehand like it does now and not when compiled?
	}

	definition::~definition(){
		delete this->expr;
	}

	std::ostream& definition::operator<<(std::ostream& out){
		out << "Define(" << str << ")";
		if(this->expr)
			out << " as " << *this->expr;

		return out;
	}
}}
