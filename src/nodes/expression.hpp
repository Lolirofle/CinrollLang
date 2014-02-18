#ifndef __LOLIROFLE_CINROLL_EXPRESSION_HPP_INCLUDED__
#define __LOLIROFLE_CINROLL_EXPRESSION_HPP_INCLUDED__

#include <string>
#include <list>

namespace cinroll{
	class expression{
	public:
		virtual std::string toString()=0;
	};

	class block : public expression{
	protected:
		std::list<cinroll::expression*> expressions;
	public:
		block() : expressions() {}

		std::string toString(){
			return "block";
		}
	};

	class number : public expression{
	protected:
		std::string str;
	public:
		number(std::string str) : str(str){}

		std::string toString(){
			return str;
		}
	};

	class string : public expression{
	protected:
		std::string str;
	public:
		string(std::string str) : str(str){}

		std::string toString(){
			return str;
		}
	};

	class identifier : public expression{
	protected:
		std::string str;
	public:
		identifier(std::string str) : str(str){}

		std::string toString(){
			return str;
		}
	};
}

#endif
