#ifndef __LOLIROFLE_CINROLL_NODES_DEFINITION_HPP_INCLUDED__
#define __LOLIROFLE_CINROLL_NODES_DEFINITION_HPP_INCLUDED__

#include "statement.hpp"
#include "structures/scope.hpp"
#include <string>

namespace cinroll{namespace nodes{
	class definition : public statement{
	public:
		std::string str;
		expression* expr;
		expression* type;

		definition(cinroll::structures::scope* scope,std::string str,expression* type = NULL,expression* expr = NULL);
		virtual ~definition();
	};
}}

#endif
