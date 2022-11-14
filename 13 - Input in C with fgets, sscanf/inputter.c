

#include <limits.h>
#include <stdio.h>


void theInputter(double * d)
{
	char buffer[LINE_MAX];
	
	//
	double temp;
	
	//
	char * getResult = fgets(buffer, LINE_MAX, stdin);
	printf("\n");
	if ( getResult != NULL ) {
		
		printf("Got something from the user: %s\n", buffer);
		
		int scanResult = sscanf(buffer, "%lf", &temp);
		if ( scanResult < 1 ) {
			printf("Failed to scan the user's input to a double!");
		}
		else {
			printf("Successfully scanned the user's input to a double!");
			(*d) = temp;
		}
	}
	else {
		printf("Got nothing from the user!");
	}
	printf("\n");
}
















