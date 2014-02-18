#ifndef __LOLIROFLE_CINROLL_NODES_STRINGLITERAL_HPP_INCLUDED__
#define __LOLIROFLE_CINROLL_NODES_STRINGLITERAL_HPP_INCLUDED__

#include "expression.hpp"
#include <string>

namespace cinroll{namespace nodes{
	class string_literal : public expression{
	protected:
		std::string str;
	public:
		string_literal(std::string str);
		~string_literal();

		void print(std::ostream& out);
	};
}}

#endif
