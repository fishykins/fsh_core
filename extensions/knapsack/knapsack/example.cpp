
// classes example
#include <iostream>
#include <vector>

using namespace std;

class fsh_object {
	int weight;
	int cost;
	int goonyness;
public:
	void setValues(int,int);
	void addWeight(int x) {weight = weight + x;};
	int getWeight() { return weight; };
	int getCost() { return cost; };
	int getGoonyness() { return goonyness; };
};

void fsh_object::setValues(int x, int y) {
	weight = x;
	cost = y;
	goonyness = y / x;
};

// A utility function that returns maximum of two integers
int max(int a, int b)
{
	return (a > b) ? a : b;
}

// Returns the maximum value that can be put in a knapsack of capacity W
int knapSack(int capacity, int wt[], int val[], int objectCount)
{
	int i, w;

	int rowCount = objectCount + 1;
	int colCount = capacity + 1;

	int** K = new int*[rowCount];
	for (int i = 0; i < rowCount; ++i)
		K[i] = new int[colCount];



	// Build table K[][] in bottom up manner
	for (i = 0; i <= objectCount; i++)
	{
		for (w = 0; w <= capacity; w++)
		{
			if (i == 0 || w == 0)
				K[i][w] = 0;
			else if (wt[i - 1] <= w)
				K[i][w]
				= max(val[i - 1] + K[i - 1][w - wt[i - 1]], K[i - 1][w]);
			else
				K[i][w] = K[i - 1][w];
		}
	}

	return K[objectCount][capacity];
	delete[] K;
}

int main() {
	fsh_object bilbo, pippy, goldberry;
	bilbo.setValues(8, 50);
	pippy.setValues(4, 30);
	goldberry.setValues(2, 20);

	std::vector<fsh_object> objects;
	objects.push_back(fsh_object(bilbo));
	objects.push_back(fsh_object(pippy));
	objects.push_back(fsh_object(goldberry));

	cout << "Initial size: " << objects.size() << endl;

	cout << "Enter the number of items in a Knapsack:";
	int n, W;
	cin >> n;

	//int val[n], wt[n];
	int* val = NULL;
	int* wt = NULL;
	val = new int[n];
	wt = new int[n];

	for (int i = 0; i < n; i++)
	{
		cout << "Enter value and weight for item " << i << ":";
		cin >> val[i];
		cin >> wt[i];
	}

	//    int val[] = { 60, 100, 120 };
	//    int wt[] = { 10, 20, 30 };
	//    int W = 50;
	cout << "Enter the capacity of knapsack";
	cin >> W;
	cout << knapSack(W, wt, val, n) << endl;

	delete[] val, wt;
	//delete[] wt;

	return 0;
};