#include "block.hpp"

namespace cinroll{namespace nodes{
	block::block() : expressions(){}
	block::~block(){
		for(auto expr = this->expressions.begin(); expr!=this->expressions.end(); expr++){
			delete *expr;;
		}
	}

	std::ostream& block::operator<<(std::ostream& out){
		out << "block{";
		for(auto expr = this->expressions.begin(); expr!=this->expressions.end(); expr++){
			out << *expr << "; ";
		}
		out << '}' << std::endl;

		return out;
	}
}}
