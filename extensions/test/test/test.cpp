// test.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"


extern "C"
{
	__declspec (dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *function);
};

void __stdcall RVExtension(char *output, int outputSize, const char *function)
{
	if (!strncmp(function, "a:", 2)) { //Add an object

	}
	else if (!strncmp(function, "c:", 2)) { //Clear the objects

	}
	else if (!strncmp(function, "r:", 2)) { //Run simulation

	}
	else { //Not a recognised command

	};



	strncpy_s(output, outputSize, "Goons", _TRUNCATE);
};