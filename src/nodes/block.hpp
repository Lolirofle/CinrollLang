#ifndef __LOLIROFLE_CINROLL_NODES_BLOCK_HPP_INCLUDED__
#define __LOLIROFLE_CINROLL_NODES_BLOCK_HPP_INCLUDED__

#include "expression.hpp"
#include <list>

namespace cinroll{namespace nodes{
	class block : public expression{
	protected:
		std::list<cinroll::nodes::expression*> expressions;
	public:
		block();

		void print(std::ostream& out);
	};
}}

#endif
