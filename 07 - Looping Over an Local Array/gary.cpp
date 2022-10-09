
//
#include <iostream>

//
using std::cout, std::endl;

//
extern "C" {
	long looper();
}


//
int main()
{
	//
	cout << "Hello!" << endl;
	
	//
	long the_result = looper();
	
	//
	cout << "The result was: " << the_result << endl;
	
	return 0;
}





