// spendingLogic.cpp : Defines the exported functions for the DLL application.
//
#include "stdafx.h"


extern "C"
{
	__declspec (dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *function);
};

void __stdcall RVExtension(char *output, int outputSize, const char *function)
{
	if (!strncmp(function, "a:", 2)) { //Add an object
		strncpy_s(output, outputSize, "ADD", _TRUNCATE);
	}
	else if (!strncmp(function, "c:", 2)) { //Clear the objects
		strncpy_s(output, outputSize, "CLEAR", _TRUNCATE);
	}
	else if (!strncmp(function, "r:", 2)) { //Run simulation
		strncpy_s(output, outputSize, "RUN", _TRUNCATE);
	}
	else { //Not a recognised command
		strncpy_s(output, outputSize, "GOON", _TRUNCATE);
	};
};