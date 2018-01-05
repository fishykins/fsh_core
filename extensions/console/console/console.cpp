#include <stdlib.h>
#include <iostream>
#include <sstream>
#include <stdexcept>

#include <mysql_connection.h>
#include <mysql_driver.h> //This is the goon that caused all the issues

#include <cppconn/driver.h>
#include <cppconn/exception.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>
#include <cppconn/prepared_statement.h>

#define DB_HOST "tcp://127.0.0.1:3306"
#define DB_USER "root"
#define DB_PASSWORD "goon"
#define DB_DATABASE "test"

using namespace std;

int goon()
{
	int goon_level, goon_actual;

	cout << "How much of a goon are you?\n";
	cin >> goon_level;

	goon_actual = goon_level * 2;

	cout << "No, you are infact ";
	cout << goon_actual << "!\n";

	return 0;
}

int main(int argc, const char **argv)
{
	string url(argc >= 2 ? argv[1] : DB_HOST);
	const string user(argc >= 3 ? argv[2] : DB_USER);
	const string password(argc >= 4 ? argv[3] : DB_PASSWORD);
	const string database(argc >= 5 ? argv[4] : DB_DATABASE);

	cout << "url: " << url << endl;
	cout << "database: " << database << endl;
	cout << "User: " << user << endl;
	cout << "Password: " << password << endl;
	cout << endl;

	cout << "Setting up drivers..." << endl;
	sql::mysql::MySQL_Driver *driver;
	sql::Connection *con;
	sql::Statement *stmt;

	cout << "getting driver instance..." << endl;
	driver = sql::mysql::get_mysql_driver_instance();

	cout << "connecting..." << endl;
	con = driver->connect(url, user, password); //It all goes wrong here...
	cout << "connection established!" << endl;

	//stmt = con->createStatement();
	//stmt->execute("INSERT INTO goons(id, name, levelofgooniness) VALUES (4, 'Dooda', 73)");
		
	delete con;
	delete stmt;

	cout << "Done." << endl;
	return EXIT_SUCCESS;
}