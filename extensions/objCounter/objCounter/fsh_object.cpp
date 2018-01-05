#include "stdafx.h"
#include "functions.h"

using namespace std;

//splits a string into a vector
vector<string> explode(const string& str, const char& ch) {
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


//Passed string
fsh_object::fsh_object(std::string params) {
	std::vector<std::string> splitParams = explode(params, ',');
	std::string tempName = splitParams[0];
	std::string tempWeight = splitParams[1];
	std::string tempCost = splitParams[2];

	weight = atoi(tempWeight.c_str());
	cost = atoi(tempCost.c_str());
	costPerUnit = cost / weight;
	name = tempName;
	count = 0;
	fbCount = 0;
	cout << "======= new fsh_object =======" << endl;
	cout << "name: " << name << endl;
	cout << "weight: " << weight << endl;
	cout << "cost: " << cost << endl;
	cout << "cost per unit: " << costPerUnit << endl;
	cout << "==============================" << endl;
}

//Passed vector
fsh_object::fsh_object(const char **params) {
	const char *tempName = params[0];
	const char *tempWeight = params[1];
	const char *tempCost = params[2];

	weight = atoi(tempWeight);
	cost = atoi(tempCost);
	costPerUnit = cost / weight;
	name = tempName;
	count = 0;
	fbCount = 0;
	cout << "======= new fsh_object =======" << endl;
	cout << "name: " << name << endl;
	cout << "weight: " << weight << endl;
	cout << "cost: " << cost << endl;
	cout << "cost per unit: " << costPerUnit << endl;
	cout << "==============================" << endl;
}



fsh_object::fsh_object(void) {
	weight = 1;
	cost = 1;
	name = "any";
	count = 0;
	fbCount = 0;
}


void fsh_object::setFbCount(int x) {
	fbCount = x;
}

void fsh_object::setCount(int x) {
	count = x;
}



