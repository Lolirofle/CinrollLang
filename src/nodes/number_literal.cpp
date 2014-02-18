#include "number_literal.hpp"

namespace cinroll{namespace nodes{
	number_literal::number_literal(std::string str) : str(str){}

	void number_literal::print(std::ostream& out){
		out << "Number[" << this->name() << "](" << str << ')';
	}

	base10_number_literal::base10_number_literal(std::string str) : number_literal(str){}

	std::string base10_number_literal::name(){
		return "Base 10";
	}

	long base10_number_literal::convert(std::string str){
		std::istringstream convert(str);
		long out;
		if(!(convert >> out))
			out = 0;
		return out;
	}

	char_number_literal::char_number_literal(std::string str) : number_literal(str){}

	std::string char_number_literal::name(){
		return "Char";
	}

	long char_number_literal::convert(std::string str){
		return str[0];
	}
}}
