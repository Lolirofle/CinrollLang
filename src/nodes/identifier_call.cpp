#include "identifier_call.hpp"

namespace cinroll{namespace nodes{
	identifier_call::identifier_call(std::string str,expression* expr) : str(str),expr(expr){}
	identifier_call::~identifier_call(){
		if(expr)
			delete expr;
	}

	std::ostream& identifier_call::operator<<(std::ostream& out){
		out << "Identifier(" << str << ')';
		if(expr){
			out << " calls " << *expr;
		}

		return out;
	}
}}
