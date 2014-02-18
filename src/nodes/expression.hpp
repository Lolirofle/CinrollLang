#ifndef __LOLIROFLE_CINROLL_NODES_EXPRESSION_HPP_INCLUDED__
#define __LOLIROFLE_CINROLL_NODES_EXPRESSION_HPP_INCLUDED__

#include <iostream>

namespace cinroll{namespace nodes{
	class expression{
	public:
		virtual ~expression();
		virtual void print(std::ostream& out)=0;
	};
}}

#endif
