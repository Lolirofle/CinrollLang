#ifndef __LOLIROFLE_CINROLL_NODES_EXPRESSION_HPP_INCLUDED__
#define __LOLIROFLE_CINROLL_NODES_EXPRESSION_HPP_INCLUDED__

#include <iostream>

namespace cinroll{namespace nodes{
	class expression{
	public:
		virtual ~expression();
		virtual std::ostream& operator<<(std::ostream& out)=0;
	};
	
	std::ostream& operator<<(std::ostream& out,expression& expr);
}}

#endif
