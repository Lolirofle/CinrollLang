#include "string_literal.hpp"

namespace cinroll{namespace nodes{
	string_literal::string_literal(std::string str) : str(str){}
	string_literal::~string_literal(){}

	std::ostream& string_literal::operator<<(std::ostream& out){
		out << "(str \"" << str << "\")";

		return out;
	}
}}
