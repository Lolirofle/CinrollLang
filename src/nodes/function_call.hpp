#ifndef __LOLIROFLE_CINROLL_NODES_FUNCTIONCALL_HPP_INCLUDED__
#define __LOLIROFLE_CINROLL_NODES_FUNCTIONCALL_HPP_INCLUDED__

#include "expression.hpp"
#include <string>

namespace cinroll{namespace nodes{
	class function_call : public expression{
	public:
		expression* expr;
		expression* arg;

		function_call(expression* expr,expression* arg);
		~function_call();

		std::ostream& operator<<(std::ostream& out);
	};
}}

#endif
