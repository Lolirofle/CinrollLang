#include "identifier_call.hpp"

namespace cinroll{namespace nodes{
	identifier_call::identifier_call(std::string str) : str(str){}
	identifier_call::~identifier_call(){}

	std::ostream& identifier_call::operator<<(std::ostream& out){
		out << "Identifier(" << str << ')';

		return out;
	}
}}
