
//
#include <iostream>

//
using std::cout, std::endl;

//
extern "C" {
	void coolStuff();
}


//
int main()
{
	//
	cout << "Driver begin" << endl;
	
	//
	coolStuff();
	
	//
	cout << "Driver done" << endl;
	
	return 0;
}






