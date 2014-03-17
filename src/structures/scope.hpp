#ifndef __LOLIROFLE_CINROLL_STRUCTURES_SCOPE_HPP_INCLUDED__
#define __LOLIROFLE_CINROLL_STRUCTURES_SCOPE_HPP_INCLUDED__

#include <map>
#include <string>
#include "nodes/expression.hpp"
//#include "structures/type.hpp"

namespace cinroll{namespace structures{
	class scope{
	public:
		std::map<std::string,cinroll::nodes::expression*> definitions;
		//std::map<std::string,cinroll::structures::type*> type_definitions;

		~scope();
	};
}}

#endif
