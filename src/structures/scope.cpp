#include "scope.hpp"

namespace cinroll{namespace structures{
	scope::~scope(){
		for(auto i=this->definitions.begin(); i!=this->definitions.end(); ++i)
			delete i->second;
		this->definitions.erase(this->definitions.begin(),this->definitions.end());
	}
}}
