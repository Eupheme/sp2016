module biblios.db;
public import mysql.d;

Mysql db;

void connectDB()
{
	db = new Mysql("localhost", 3306, "root", "", "biblios");
}