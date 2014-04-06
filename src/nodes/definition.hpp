#ifndef __LOLIROFLE_CINROLL_NODES_DEFINITION_HPP_INCLUDED__
#define __LOLIROFLE_CINROLL_NODES_DEFINITION_HPP_INCLUDED__

#include "statement.hpp"
#include "structures/scope.hpp"
#include <string>
#include <list>

namespace cinroll{namespace nodes{
	class definition : public statement{
	public:
		std::string identifier;
		expression* expr;
		expression* type;
		std::list<cinroll::nodes::definition*>* args;

		definition(cinroll::structures::scope* scope,std::string identifier,expression* type = NULL,expression* expr = NULL,std::list<cinroll::nodes::definition*>* args = NULL);
		virtual ~definition();
	};
}}

#endif
