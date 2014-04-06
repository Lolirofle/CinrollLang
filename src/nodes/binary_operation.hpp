#ifndef __LOLIROFLE_CINROLL_NODES_BINARY_OPERATION_HPP_INCLUDED__
#define __LOLIROFLE_CINROLL_NODES_BINARY_OPERATION_HPP_INCLUDED__

#include "expression.hpp"
#include <string>

namespace cinroll{namespace nodes{
	class identifier_call;

	class binary_operation : public expression{
	public:
		identifier_call* op;
		expression* left;
		expression* right;

		binary_operation(identifier_call* op,expression* left,expression* right);
		~binary_operation();

		std::ostream& operator<<(std::ostream& out);
	};
}}

#endif
