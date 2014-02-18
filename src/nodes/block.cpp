#include "block.hpp"

namespace cinroll{namespace nodes{
	block::block() : expressions(){}

	void block::print(std::ostream& out){
		out << "Block{";
		for(auto expr = this->expressions.begin(); expr!=this->expressions.end(); expr++){
			(*expr)->print(out);
			out << "; ";
		}
		out << '}' << std::endl;
	}
}}
