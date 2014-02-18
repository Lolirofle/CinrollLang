#include "number_converter.hpp"

#include <sstream>

namespace cinroll{
	number_converter number_converter_base10 = (number_converter){
		"Base 10",
		+[](std::string str) -> long{
			std::istringstream convert(str);
			long out;
			if(!(convert >> out))
				out = 0;
			return out;
		}
	};

	number_converter number_converter_char = (number_converter){
		"Char",
		+[](std::string str) -> long{
			return str[0];
		}
	};
}
