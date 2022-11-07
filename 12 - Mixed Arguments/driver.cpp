
//
#include <iomanip>
#include <iostream>

//
using std::cout, std::endl;

//
extern "C" {
	
	void coolStuff();
	
	long c_mixed_args(
		long a, long b,
		double c, double d,
		long * pLong, double * pDouble,
		long e,
		double f
	);
	
	void giveStuffToAssembly();
	
	double receiver(
		long a, long b, double c, double d,
		long * e, double * f
	);
	
	void arraySender();
	void arrayReceiver(double * d);
	
	void receiveFloatArrayFromAssembly(double * d);
}

//
int main()
{
	//
	cout << "Driver begin" << endl;
	
	//
	coolStuff();
	
	//
	giveStuffToAssembly();
	
	//
	cout << "Call arraySender() - BEGIN" << endl;
	arraySender();
	cout << "Call arraySender() - END" << endl;
	
	//
	cout << "Driver done" << endl;
	
	return 0;
}

long c_mixed_args(
	long a, long b,
	double c, double d,
	long * pLong, double * pDouble,
	long e,
	double f
)
{
	cout
		<< std::fixed << std::setprecision(5)
		<< "BEGIN c_mixed_args()" << endl
		<< endl
		<< "c_mixed_args() got:" << endl
		<< "> a = " << a << endl
		<< "> b = " << b << endl
		<< "> c = " << c << endl
		<< "> d = " << d << endl
		<< "> pLong = " << (*pLong) << endl
		<< "> pDouble = " << (*pDouble) << endl
		<< "> e = " << e << endl
		<< "> f = " << f << endl
		<< endl
		<< "END c_mixed_args()" << endl
		<< endl
		;
	
	//	Modify the incoming pointer'ed variables, somehow
	(*pLong) *= 2;
	(*pDouble) *= 2.0;
	
	cout
		<< "pLong after modification: " << (*pLong) << endl
		<< "pDouble after modification: " << (*pDouble) << endl
		<< endl
		;
	
	return 78633;
}

void giveStuffToAssembly()
{
	cout
		<< "giveStuffToAssembly() - BEGIN" << endl
		;
	
	//
	long a = 10;
	double b = 22.2;
	
	//
	cout << "Before calling the receiver: a = " << a << "; b = " << b << endl;
	
	//
	double result = receiver(71, 72, 9.9, 8.8, &a, &b);
	
	cout << "Receiver returned: " << result << endl;
	
	//
	cout << "After calling the receiver: a = " << a << "; b = " << b << endl;
	
	//
	double data[5];
	arrayReceiver(data);
	cout << "Modified array data:" << endl;
	for ( auto d : data ) {
		cout << d << " ";
	}
	cout << endl;
	
	cout
		<< endl
		<< "giveStuffToAssembly() - END" << endl
		;
}

void receiveFloatArrayFromAssembly(double * d)
{
	cout << "receiveFloatArrayFromAssembly() - BEGIN" << endl;
	
	d[0] = 5.0;
	d[1] = 6.1;
	d[2] = 7.2;
	d[3] = 8.3;
	d[4] = 9.4;
	
	//for ( size_t i = 0; i < 5; i++ ) {
	//	cout << d[i] << " ";
	//}
	
	cout << "receiveFloatArrayFromAssembly() - END" << endl;
}




