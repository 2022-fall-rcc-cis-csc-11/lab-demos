
//
#include <iostream>

//
using std::cout, std::endl;

//
extern "C" {
	void caller();
	long doStuff(char * cs, long someNumber);
}


//
int main()
{
	//
	cout << "Driver begin" << endl;
	
	//
	caller();
	
	//
	cout << "Driver done" << endl;
	
	return 0;
}


long doStuff(char * cs, long someNumber)
{
	//
	cout << cs << endl;
	cout << "Also, we received this number: " << someNumber << endl;
	
	return someNumber * 2;
}





