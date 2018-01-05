// objCounter.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
//#include "functions.h"

using namespace std;

//Define vector of all objects
std::vector<fsh_object *> objects;

//Some arma related thing 
extern "C"
{
	//--- Engine called on extension load 
	__declspec (dllexport) void __stdcall RVExtensionVersion(char *output, int outputSize);
	//--- STRING callExtension STRING
	__declspec (dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *function);
	//--- STRING callExtension ARRAY
	__declspec (dllexport) int __stdcall RVExtensionArgs(char *output, int outputSize, const char *function, const char **args, int argsCnt);
}

//turn int into string
std::string toStr(int x) {
	std::stringstream str;
	str << x;
	return str.str();
}

//splits a string into a vector
vector<string> explodeString(const string& str, const char& ch) {
	string next;
	vector<string> result;

	// For each character in the string
	for (string::const_iterator it = str.begin(); it != str.end(); it++) {
		// If we've hit the terminal character
		if (*it == ch) {
			// If we have some characters accumulated
			if (!next.empty()) {
				// Add them to the result vector
				result.push_back(next);
				next.clear();
			}
		}
		else {
			// Accumulate the next character into the sequence
			next += *it;
		}
	}
	if (!next.empty())
		result.push_back(next);
	return result;
}

//returns object count for passed name
int pull(std::string name) {
	bool found = false;
	for (int i = 0; i < objects.size(); i++) {
		fsh_object *obj = objects.at(i);
		std::string objName = obj->getName();
		if (objName == name) {
			i = objects.size();
			int objCount = obj->getCount();
			return objCount;
			found = true;
		}
	}
	if (!found)
		return -2;
}

//Sets all object counts back to 0
void resetCounts() {
	for (int i = 0; i < objects.size(); i++) {
		fsh_object *obj = objects.at(i);
		obj->setCount(0);
	}
}

void sortObjectsValue() {
	for (int i = 0; i < objects.size() - 1; i++) {
		for (int j = i + 1; j < objects.size(); j++) {
			fsh_object *iObj = objects.at(i);
			fsh_object *jObj = objects.at(j);

			if (iObj->getCPU() > jObj->getCPU()) {
				fsh_object *objTemp = objects.at(i);
				objects.at(i) = objects.at(j);
				objects.at(j) = objTemp;
			};
		};
	};
}

void sortObjectsCost() {
	for (int i = 0; i < objects.size() - 1; i++) {
		for (int j = i + 1; j < objects.size(); j++) {
			fsh_object *iObj = objects.at(i);
			fsh_object *jObj = objects.at(j);

			if (iObj->getCost() > jObj->getCost()) {
				fsh_object *objTemp = objects.at(i);
				objects.at(i) = objects.at(j);
				objects.at(j) = objTemp;
			};
		};
	};
}

//=================================================================================================//
//=================================================================================================//
//Evenly distributes funds according to weight. 
int distributeBallanced(const char **params) {

	//Funds
	int funds = atoi(params[0]);
	float debit = 0;
	float fbCost = 0;
	cout << "funds: " << funds << endl;

	//Sort objects by cost per unit (from best to worst value)
	sortObjectsValue();

	//Establish the common weight
	int commonWeight = 1;

	for (int i = 0; i < objects.size(); i++) {
		fsh_object *o = objects.at(i);
		commonWeight = commonWeight * o->getWeight();
	}

	//Work out full buy costs and object count
	for (int i = 0; i < objects.size(); i++) {
		fsh_object *obj = objects.at(i);
		int objWeight = obj->getWeight();
		int objCost = obj->getCost();
		int objFbCount = commonWeight / objWeight;
		int objFbCost = objFbCount * objCost;

		obj->setFbCount(objFbCount);
		fbCost = fbCost + objFbCost;
	}

	//We have a cost for full buy:
	cout << "Full buy total cost: " << fbCost << endl;
	const float fbRatio = fbCost / funds;

	//Do the sums and set object count
	for (int i = 0; i < objects.size(); i++) {
		fsh_object *obj = objects.at(i);
		int objCost = obj->getCost();
		int objFbCount = obj->getFbCount();
		int objCount = obj->getCount() + (objFbCount / fbRatio);
		obj->setCount(objCount);

		//Cost this up
		debit = debit + (objCount * objCost);

		//debug output
		cout << obj->getName() << ": weight = " << obj->getWeight() << ", cost = " << obj->getCost() << ", fbCount = " << obj->getFbCount() << ", count = " << obj->getCount() << endl;
	}

	//Work out left over funds
	funds = funds - debit;
	cout << "debit = " << debit << ", funds left = " << funds << endl;

	return funds;
}

//-------------------------------------------------------------------------------------------------//
//Buy up as much weight as possible. 
int distributeStack(const char **params) {
	//Funds
	float funds = atoi(params[0]);
	cout << "funds: " << funds << endl;

	sortObjectsValue();

	//Go through each object from best value to worst, and buy up as much as possible
	for (int i = 0; i < objects.size(); i++) {
		fsh_object *obj = objects.at(i);
		float objCost = obj->getCost();
		if (objCost <= funds) {
			int objCount = floor(funds / objCost);
			funds = funds - (objCount * objCost);
			objCount = objCount + obj->getCount();
			obj->setCount(objCount);
		}
	}

	sortObjectsCost();

	//Finnally, check to see if we can get a cheapy
	for (int i = 0; i < objects.size(); i++) {
		fsh_object *obj = objects.at(i);
		float objCost = obj->getCost();
		if (objCost <= funds) {
			int objCount = floor(funds / objCost);
			funds = funds - (objCount * objCost);
			objCount = objCount + obj->getCount();
			obj->setCount(objCount);
		}
	}

	return funds;
}

//=================================================================================================//
//=================================================================================================//

// "objCounter" callExtension [function, args]
int __stdcall RVExtensionArgs(char *output, int outputSize, const char *function, const char **params, int paramsCount)
{
	if (strcmp(function, "add") == 0) {
		// [name, weight, cost]
		fsh_object *obj = new fsh_object(params);
		objects.push_back(obj);
		strncpy_s(output, outputSize, "added object", _TRUNCATE);
		return objects.size();
	}
	else if (strcmp(function, "clear") == 0) {
		objects.clear();
		strncpy_s(output, outputSize, "cleared", _TRUNCATE);
		return 0;
	} 
	else if (strcmp(function, "reset") == 0) {
		resetCounts();
		strncpy_s(output, outputSize, "resetting object counts", _TRUNCATE);
		return 0;
	}
	else if (strcmp(function, "pull") == 0) {
		int objCount = -1;
		if (objects.size() > 0) {
			objCount = pull(params[0]);
		};
		strncpy_s(output, outputSize, "pulled results", _TRUNCATE);
		return objCount;
	}
	else if (strcmp(function, "ballance") == 0) {
		int leftovers = distributeBallanced(params);
		strncpy_s(output, outputSize, "ballancing", _TRUNCATE);
		return leftovers;
	}
	else if (strcmp(function, "stack") == 0) {
		int leftovers = distributeStack(params);
		strncpy_s(output, outputSize, "stacking", _TRUNCATE);
		return leftovers;
	}
	else {
		strncpy_s(output, outputSize, "function not recognised", _TRUNCATE);
		return -1;
	}
}



// "objCounter" callExtension function
void __stdcall RVExtension(char *output, int outputSize, const char *function) {
	strncpy_s(output, outputSize, "we dont do this anymore- use an array", _TRUNCATE);
}

/*
{
	bool ret = false;

	//Run command
	const char *cmd = function;
	cout << "-----------------------------------------" << endl;
	cout << "Processing command: " << cmd << endl;

	std::string cmd_string = cmd;
	std::string params = cmd_string.substr(2, cmd_string.size() - 2);

	//Run command
	switch (cmd[0]) {
		//Add object
	case 'a': {
		cout << "adding object: " << params << endl;
		fsh_object *o = new fsh_object(params);
		objects.push_back(o);

		//Return number of objects now in system
		std::string str = toStr(objects.size());
		const char * c_string = str.c_str();

		cout << "new number of objects: " << c_string << endl;
		strncpy_s(output, outputSize, c_string, _TRUNCATE);
		ret = true;
	} break;
		//Clear all objects
	case 'c': {
		cout << "clearing all objects" << endl;
		objects.clear();
		strncpy_s(output, outputSize, "CLEAR", _TRUNCATE);
		ret = true;
	} break;
		//Run calculations with given funds
	case 'r': {
		if (objects.size() > 0) {
			cout << "running simulation" << endl;
			distributeBallanced(params);
			strncpy_s(output, outputSize, "DONE", _TRUNCATE);
			ret = true;
		}
	} break;
		//Pull request
	case 'p': {
		int objCount = -1;
		if (objects.size() > 0) {
			objCount = pull(params);
		};
		std::string str = toStr(objCount);
		const char * c_string = str.c_str();

		cout << params << ": count = " << c_string << endl;
		strncpy_s(output, outputSize, c_string, _TRUNCATE);
		ret = true;
	} break;
		//Not a valid commnad
	default: {
		cout << "Not a valid command" << endl;
		strncpy_s(output, outputSize, "NULL", _TRUNCATE);
	} break;
	}

	if (!ret) strncpy_s(output, outputSize, "GOON", _TRUNCATE);
}
*/

//--- Extension version information shown in .rpt file
void __stdcall RVExtensionVersion(char *output, int outputSize)
{
	//--- max outputSize is 32 bytes
	strncpy_s(output, outputSize, CURRENT_VERSION, _TRUNCATE);
}