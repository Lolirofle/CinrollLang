#ifndef __LOLIROFLE_CINROLL_NODES_NUMBERLITERAL_HPP_INCLUDED__
#define __LOLIROFLE_CINROLL_NODES_NUMBERLITERAL_HPP_INCLUDED__

#include "expression.hpp"
#include <string>
#include <sstream>
#include <iostream>

namespace cinroll{namespace nodes{
	class number_literal : public expression{
	protected:
		std::string str;
	public:
		number_literal(std::string str);

		virtual std::string name()=0;
		virtual long convert(std::string str)=0;//TODO: Handle more complex cases
		//virtual cinroll::types::number type()=0;

		void print(std::ostream& out);
	};

	class base10_number_literal : public number_literal{
	public:
		base10_number_literal(std::string str);

		std::string name();

		long convert(std::string str);
	};

	class char_number_literal : public number_literal{
	public:
		char_number_literal(std::string str);

		std::string name();

		long convert(std::string str);
	};
}}

#endif
