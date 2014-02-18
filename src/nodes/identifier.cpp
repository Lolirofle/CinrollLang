#include "identifier.hpp"

namespace cinroll{namespace nodes{
	identifier::identifier(std::string str) : str(str){}
	identifier::~identifier(){}

	void identifier::print(std::ostream& out){
		out << "Identifier(" << str << ')';
	}
}}
