#ifndef __LOLIROFLE_CINROLL_NODES_DEFINITION_HPP_INCLUDED__
#define __LOLIROFLE_CINROLL_NODES_DEFINITION_HPP_INCLUDED__

#include "expression.hpp"
#include "structures/scope.hpp"
#include <string>

namespace cinroll{namespace nodes{
	class definition : public expression{
	public:
		std::string str;
		expression* expr;
		expression* type;

		definition(cinroll::structures::scope* scope,std::string str,expression* type = NULL,expression* expr = NULL);
		virtual ~definition();

		std::ostream& operator<<(std::ostream& out);
	};
}}

#endif
