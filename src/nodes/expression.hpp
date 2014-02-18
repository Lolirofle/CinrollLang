#ifndef __LOLIROFLE_CINROLL_EXPRESSION_HPP_INCLUDED__
#define __LOLIROFLE_CINROLL_EXPRESSION_HPP_INCLUDED__

#include <string>
#include <list>
#include <iostream>
#include "number_converter.hpp"

namespace cinroll{namespace nodes{
	class expression{
	public:
		virtual ~expression(){};
		virtual void print(std::ostream& out)=0;
	};

	class block : public expression{
	protected:
		std::list<cinroll::nodes::expression*> expressions;
	public:
		block() : expressions() {}

		void print(std::ostream& out){
			out << "Block{";
			for(auto expr = this->expressions.begin(); expr!=this->expressions.end(); expr++){
				(*expr)->print(out);
				out << "; ";
			}
			out << '}' << std::endl;
		}
	};

	class number_literal : public expression{
	protected:
		std::string str;
		cinroll::number_converter converter;
	public:
		number_literal(std::string str,cinroll::number_converter& converter = cinroll::number_converter_base10) : str(str),converter(converter){}
		~number_literal(){}

		void print(std::ostream& out){
			out << "Number[" << converter.name << "](" << str << ')';
		}
	};

	class string_literal : public expression{
	protected:
		std::string str;
	public:
		string_literal(std::string str) : str(str){}
		~string_literal(){}

		void print(std::ostream& out){
			out << "String(" << str << ')';
		}
	};

	class identifier : public expression{
	protected:
		std::string str;
	public:
		identifier(std::string str) : str(str){}
		~identifier(){}

		void print(std::ostream& out){
			out << "Identifier(" << str << ')';
		}
	};
}}

#endif
