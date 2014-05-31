#include "function_call.hpp"

namespace cinroll{namespace nodes{
	function_call::function_call(expression* expr,expression* arg) : expr(expr),arg(arg){}
	function_call::~function_call(){
		delete arg;
		delete expr;
	}

	std::ostream& function_call::operator<<(std::ostream& out){
		out << "(function (" << *expr << ") (" << *arg << "))";

		return out;
	}
}}
