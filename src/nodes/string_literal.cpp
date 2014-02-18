#include "string_literal.hpp"

namespace cinroll{namespace nodes{
	string_literal::string_literal(std::string str) : str(str){}
	string_literal::~string_literal(){}

	void string_literal::print(std::ostream& out){
		out << "String(" << str << ')';
	}
}}
