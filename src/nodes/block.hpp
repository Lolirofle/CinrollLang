#ifndef __LOLIROFLE_CINROLL_NODES_BLOCK_HPP_INCLUDED__
#define __LOLIROFLE_CINROLL_NODES_BLOCK_HPP_INCLUDED__

#include "expression.hpp"
#include "structures/scope.hpp"
#include <list>

namespace cinroll{namespace nodes{
	class block : public expression,public cinroll::structures::scope{
	protected:
		std::list<cinroll::nodes::expression*> expressions;
	public:
		block();
		virtual ~block();

		std::ostream& operator<<(std::ostream& out);
	};
}}

#endif
