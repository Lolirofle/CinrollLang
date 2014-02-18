#ifndef __LOLIROFLE_CINROLL_NUMBER_CONVERTER_HPP_INCLUDED__
#define __LOLIROFLE_CINROLL_NUMBER_CONVERTER_HPP_INCLUDED__

#include <string>

namespace cinroll{
	struct number_converter{
		std::string name;
		long(*convert)(std::string str);//TODO: Handle more complex cases
		//cinroll::types::number(*type)
	};

	extern number_converter number_converter_base10;
	extern number_converter number_converter_char;
}

#endif
