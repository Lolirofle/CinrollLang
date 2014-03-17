#ifndef __LOLIROFLE_CINROLL_NODES_IDENTIFIERCALL_HPP_INCLUDED__
#define __LOLIROFLE_CINROLL_NODES_IDENTIFIERCALL_HPP_INCLUDED__

#include "expression.hpp"
#include <string>

namespace cinroll{namespace nodes{
	class identifier_call : public expression{
	public:
		std::string str;

		identifier_call(std::string str);
		~identifier_call();

		std::ostream& operator<<(std::ostream& out);
	};
}}

#endif
