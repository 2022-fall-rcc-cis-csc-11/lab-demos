
//
#include <iostream>

//
using std::cout, std::endl;

//
extern "C" {
	long file_io();
}


//
int main()
{
	//
	cout << "Hello from the Driver!" << endl;
	
	//
	long the_result = file_io();
	
	//
	cout << "The result was: " << the_result << endl;
	
	return 0;
}





