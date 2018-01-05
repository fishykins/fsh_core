#include <iostream>
#include <stdlib.h>
#include <vector>
#include <string>
#include <sstream>

#include "fsh_object.h"

using namespace std;

std::vector<fsh_object *> objects;

char *commands[] = {
	"a:bilbo,2,500",
	"c:",
	"p:goonatron",
	"a:bilbo,2,2",
	"a:pippi,3,3",
	"a:pansy,4,6",
	"a:golbezza,5,12",
	"a:bibble,1,3",
	"goon",
	"p:pippi",
	"r:50",
	"p:pippi",
	"r:26",
	"p:pippi",
	"r:52",
	"p:bilbo",
	"p:pippi",
	"p:pansy",
	"p:golbezza",
	"p:bibble",
	"p:goonatron",
	NULL
};

// A utility function that returns maximum of two integers
int max(int a, int b)
{
	return (a > b) ? a : b;
};

//turn int into string
std::string toStr(int x) {
	std::stringstream str;
	str << x;
	return str.str();
}

//A function to explode a string into an array
vector<string> explodeMain(const string& str, const char& ch) {
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

//A function that calculates item count, based on weight and cost
void distribute(std::string params) {

	//Funds
	std::vector<std::string> splitParams = explodeMain(params, ',');
	std::string tempFunds = splitParams[0];
	int funds = atoi(tempFunds.c_str());
	float debit = 0;
	float fbCost = 0;
	cout << "funds: " << funds << endl;

	//Sort objects by cost per unit (from best to worst value)
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

	//Establish the common weight
	int commonWeight = 1;

	for (int i = 0; i < objects.size(); i++) {
		fsh_object *o = objects.at(i);
		commonWeight = commonWeight * o->getWeight();
	}

	//Work out full buy costs and object count
	for (int i = 0; i < objects.size(); i++) {
		fsh_object *obj = objects.at(i);
		int obj_weight = obj->getWeight();
		int obj_cost = obj->getCost();
		int obj_fbCount = commonWeight / obj_weight;
		int obj_fbCost = obj_fbCount * obj_cost;

		obj->setFbCount(obj_fbCount);
		fbCost = fbCost + obj_fbCost;
	}

	//We have a cost for full buy:
	cout << "Full buy total cost: " << fbCost << endl;
	const float fbRatio = fbCost / funds;

	//Do the sums and set object count
	for (int i = 0; i < objects.size(); i++) {
		fsh_object *obj = objects.at(i);
		int obj_cost = obj->getCost();
		int obj_fbCount = obj->getFbCount();
		int obj_count = obj_fbCount / fbRatio;
		obj->setCount(obj_count);

		//Cost this up
		debit = debit + (obj_count * obj_cost);

		//debug output
		cout << obj->getName() << ": weight = " << obj->getWeight() << ", cost = " << obj->getCost() << ", fbCount = " << obj->getFbCount() << ", count = " << obj->getCount() << endl;
	}
	
	//Work out left over funds
	funds = funds - debit;
	cout << "debit = " << debit << ", funds left = " << funds << endl;

	//Buy up anything we can
}

//returns object count for passed name
int pull(std::string name) {
	bool found = false;
	for (int i = 0; i < objects.size(); i++) {
		fsh_object *obj = objects.at(i);
		std::string objName = obj->getName();
		cout << "comparing " << name << " to " << objName << endl;
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

int main() {
	bool ret = false;

	//Run commands
	for (int i = 0; commands[i] != NULL; i++) {
		char *cmd = commands[i];
		cout << "-----------------------------------------" << endl;
		cout << "Processing command: " << cmd << endl;

		std::string cmd_string = commands[i];
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
			//strncpy_s(output, outputSize, c_string, _TRUNCATE);
			ret = true;
		} break;
			//Clear all objects
		case 'c': {
			cout << "clearing all objects" << endl;
			objects.clear();
			//strncpy_s(output, outputSize, "CLEAR", _TRUNCATE);
			ret = true;
		} break;
			//Run calculations with given funds
		case 'r': {
			if (objects.size() > 0) {
				cout << "running simulation" << endl;
				distribute(params);
				//strncpy_s(output, outputSize, "DONE", _TRUNCATE);
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
			//strncpy_s(output, outputSize, c_string, _TRUNCATE);
			ret = true;
		} break;
			//Not a valid commnad
		default: {
			cout << "Not a valid command" << endl;
			//strncpy_s(output, outputSize, "NULL", _TRUNCATE);
		} break;
		}

		if (!ret) {
			cout << "nothing returned" << endl;
			//strncpy_s(output, outputSize, "GOON", _TRUNCATE);
		}
	}

	return 0;
};

