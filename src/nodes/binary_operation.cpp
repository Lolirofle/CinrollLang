#include "binary_operation.hpp"
#include "identifier_call.hpp"

namespace cinroll{namespace nodes{
	binary_operation::binary_operation(identifier_call* op,expression* left,expression* right) : op(op),left(left),right(right){}
	binary_operation::~binary_operation(){
		delete op;
		delete left;
		delete right;
	}

	std::ostream& binary_operation::operator<<(std::ostream& out){
		out << "(binop " << *left << " " << *op << " " << *right << ")";

		return out;
	}
}}
