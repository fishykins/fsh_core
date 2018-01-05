#pragma once


class fsh_object {
private:
	std::string name;
	float weight;
	float cost;
	float costPerUnit;
	int fbCount;
	int count;


public:
	fsh_object(void);
	fsh_object(std::string);
	fsh_object(const char **);

	void setFbCount(int);
	void setCount(int);
	int getWeight() { return weight; };
	int getCost() { return cost; };
	int getFbCount() { return fbCount; };
	int getCount() { return count; };
	float getCPU() { return costPerUnit; };
	std::string getName() { return name; };
};
