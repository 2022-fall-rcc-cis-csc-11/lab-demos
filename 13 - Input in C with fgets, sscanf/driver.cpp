
#include <iostream>

extern "C"
{
	void theInputter(double * d);
}

using
	std::cout, std::endl
	;

int main()
{
	//
	cout << "Hello from the driver!" << endl;
	
	//
	double d = 1.23456789;
	
	//
	cout << "Initially, the double was: " << d << endl;
	theInputter(&d);
	cout << "Finally, the double was: " << d << endl;
	
	return 0;
}

