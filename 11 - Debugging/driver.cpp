
//
#include <iostream>

//
using std::cout, std::endl;

//
extern "C" {
	void coolStuff();
}


//	Proto
void f();
void g();
void h();
int i();


//
int main()
{
	//
	cout << "Driver begin" << endl;
	
	//
	f();
	
	//
	coolStuff();
	
	//
	cout << "Driver done" << endl;
	
	return 0;
}

void f()
{
	g();
}

void g()
{
	h();
}

void h()
{
	//
	int a = 0;
	
	a = i();
	
	//
	if ( a > 50 ) {
		throw std::runtime_error("Test exception");
	}
}

int i()
{
	//
	int a = 0;
	
	//
	for ( int i = 0; i < 10; i++ ) {
		a += i;
	}
	
	return a;
}






