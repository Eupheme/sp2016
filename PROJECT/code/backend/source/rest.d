module biblios.rest;
import biblios.db;
import vibe.d;

import std.random;
import std.algorithm : canFind;
import std.stdio;

enum authCookie = headerParam("auth", "Cookie");

@path("/api")
interface IAPI
{
	string postLogin(string username, string password);

	@authCookie
	void postLogout(string auth = "");
}

struct User
{
	int user_id;
	int status;
	string username;
}

struct MyItems
{
	string title;
	string author;
	int borrowed_date;
	int returned_date;
}

class APIImpl : IAPI
{
	private User[string] cookies;
	
	private string getSalt()
	{
		string str = "";
		for(int i = 0; i < 32; i++)
		{
			auto rand = uniform(32, 128);
			auto randch = to!char(rand);
			str ~= randch;
		}
		return str;
	}

	private string parseCookie(string cookie, string key)
	{
		writeln("\nParsing...");
		foreach(string c; cookie.split(";"))
		{
			string[] arr = c.split("=");
			foreach (string s; arr)
				writeln("\"" ~ s.strip() ~ "\"");
			if (arr[0].strip() == key)
				return arr[1];
		}

		return "";
	}
	
	string postLogin(string username, string password)
	{
		auto rows = db.query("select * from users where username = ? and password = ?", username, password);
		
		if (rows.length == 0)
			return "";
	
		User user;
		user.user_id = rows.front()["user_id"].to!int;
		user.username = rows.front()["username"];
		user.status = rows.front()["status"].to!int;
		
		string cookie = getSalt();
		cookies[cookie] = user;

		return cookie;
	}

	void postLogout(string auth)
	{
		string sess = parseCookie(auth, "sess");
		writeln(sess);
		cookies.remove(sess);
	}
	
	MyItems[] getMyItems(string auth)
	{
		string sess = parseCookie(auth, "sess");
		int id = cookies[sess].user_id;
		
		auto rows = db.query("select t.borrowed_date, t.returned_date, i.title, i.author from transactions t inner join items i on t.item_id = i.item_id where t.user_id = ?", id);
		
		MyItems[] allitems;
		for (auto row : rows)
		{
			MyItems item;
			item.title = row["i.title"];
			item.author = row["i.author"];
			item.borrowed_date = row["t.borrowed_date"];
			item.returned_date = row["t.returned_date"];
			allitems ~= item;
		}
		return allitems;
	}
}
