#include "expression.hpp"

namespace cinroll{namespace nodes{
	expression::~expression(){}

	std::ostream& operator<<(std::ostream& out,expression& expr){
		expr.operator<<(out);
		return out;
	}
}}
