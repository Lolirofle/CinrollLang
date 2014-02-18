#ifndef __LOLIROFLE_CINROLL_NODES_IDENTIFIER_HPP_INCLUDED__
#define __LOLIROFLE_CINROLL_NODES_IDENTIFIER_HPP_INCLUDED__

#include "expression.hpp"
#include <string>

namespace cinroll{namespace nodes{
	class identifier : public expression{
	protected:
		std::string str;
	public:
		identifier(std::string str);
		~identifier();

		void print(std::ostream& out);
	};
}}

#endif
