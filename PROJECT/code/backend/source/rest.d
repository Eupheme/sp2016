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
	
	@authCookie
	MyItems[] getTransactionHistory(string auth = "");
	
	@authCookie
	MyItems[] getMyItems(string auth = "");
	
	@authCookie
	RequestedItems[] getRequestedItems(string auth = "");
	
	@authCookie
	PendingUsers[] getPendingUsers(string auth = "");
	
	@authCookie
	AdminItems[] getAdminTransactionHistory(string auth = "");
	
	@authCookie
	int[] getItemGraph(string auth = "");
	
	@authCookie
	int[] getUserGraph(string auth = "");
	
	@authCookie
	@bodyParam("username", "username")
	int[] getAdminGraph(string username, string auth = "");
	
	@authCookie
	string[] getTopThree(string auth = "");
	
	@authCookie
	string[] getTopThreeUser(string auth = "");
	
	@authCookie
	@bodyParam("username", "username")
	string[] getTopThreeAdmin(string username, string auth = "");
	
	@authCookie
	User getProfile(string auth = "");
	
	@authCookie
	@bodyParam("username", "username")
	User getProfileAdmin(string username, string auth = "");
	
}

struct User
{
	int user_id;
	int status;
	string username;
	string first_name;
	string last_name;
	string birth_date;
	string added_date;
	string email;
	
}

struct MyItems
{
	string title;
	string author;
	string borrowed_date;
	string returned_date;
}

struct AdminItems
{
	string username;
	string title;
	string author;
	string borrowed_date;
	string returned_date;
}

struct RequestedItems
{
	string username;
	string title;
	string author;
	string published_date;
}

struct PendingUsers
{
	string username;
	string first_name;
	string last_name;
	string added_date;
	string email;
}

class APIImpl : IAPI
{
	private User[string] cookies;
	
	private string getSalt()
	{
		string str = "";
		for(int i = 0; i < 32; i++)
		{
			auto rand = uniform(0, 62);
			if (rand < 10)
				rand += 48;
			else if (rand < 36)
				rand += 55;
			else
				rand += 61;
			
			auto randch = to!char(rand);
			str ~= randch;
		}
		return str;
	}

	private string parseCookie(string cookie, string key)
	{
		writeln("Cookies:");
		foreach(key, User val; cookies)
			writeln(key);
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
		auto rows = db.query("select user_id, username, status, first_name, last_name, email, birth_date, added_date from users where username = ? and password = ? and status <> 2", username, password);
		
		if (rows.length == 0)
			return "";
	
		User user;
		user.user_id = rows.front()["user_id"].to!int;
		user.username = rows.front()["username"];
		user.status = rows.front()["status"].to!int;
		user.first_name = rows.front()["first_name"];
		user.last_name = rows.front()["last_name"];
		user.email = rows.front()["email"];
		user.birth_date = rows.front()["birth_date"];
		user.added_date = rows.front()["added_date"];
		
		
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
	
	MyItems[] getTransactionHistory(string auth)
	{
		MyItems[] allitems;
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return allitems;
			
		int id = cookies[sess].user_id;
		
		auto rows = db.query("select t.borrowed_date, t.returned_date, i.title, i.author from transactions t inner join items i on t.item_id = i.item_id where t.user_id = ?", id);

		foreach (row; rows)
		{
			MyItems item;
			item.title = row["title"];
			item.author = row["author"];
			item.borrowed_date = row["borrowed_date"];
			item.returned_date = row["returned_date"];
			allitems ~= item;
		}
		return allitems;
	}
	
	MyItems[] getMyItems(string auth)
	{
		MyItems[] allitems;
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return allitems;
			
		int id = cookies[sess].user_id;
		
		auto rows = db.query("select t.borrowed_date, ADDDATE(t.borrowed_date, INTERVAL 21 DAY) AS returned_date, i.title, i.author from transactions t inner join items i on t.item_id = i.item_id where t.user_id = ? and isnull(t.returned_date)", id);

		foreach (row; rows)
		{
			MyItems item;
			item.title = row["title"];
			item.author = row["author"];
			item.borrowed_date = row["borrowed_date"];
			item.returned_date = row["returned_date"];
			allitems ~= item;
		}
		return allitems;
	}
	
	RequestedItems[] getRequestedItems(string auth)
	{
		RequestedItems[] allitems;
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return allitems;
		
		auto rows = db.query("select r.title, r.author, r.published_date, u.username from requests r inner join users u on r.user_id = u.user_id");

		foreach (row; rows)
		{
			RequestedItems item;
			item.username = row["username"];
			item.title = row["title"];
			item.author = row["author"];
			item.published_date = row["published_date"];
			allitems ~= item;
		}
		return allitems;
	}
	
	PendingUsers[] getPendingUsers(string auth)
	{
		PendingUsers[] allusers;
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return allusers;

		
		auto rows = db.query("select username, first_name, last_name, email, added_date from users where status = 2");

		foreach (row; rows)
		{
			PendingUsers user;
			user.username = row["username"];
			user.first_name = row["first_name"];
			user.last_name = row["last_name"];
			user.email = row["email"];
			user.added_date = row["added_date"];
			allusers ~= user;
		}

		return allusers;

	}
	
	AdminItems[] getAdminTransactionHistory(string auth)
	{
		AdminItems[] allitems;
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return allitems;
			
		if (cookies[sess].status != 1)
			return allitems;
		
		auto rows = db.query("select t.borrowed_date, t.returned_date, i.title, i.author, u.username from transactions t inner join items i on t.item_id = i.item_id inner join users u on t.user_id = u.user_id");

		foreach (row; rows)
		{
			AdminItems item;
			item.username = row["username"];
			item.title = row["title"];
			item.author = row["author"];
			item.borrowed_date = row["borrowed_date"];
			item.returned_date = row["returned_date"];
			allitems ~= item;
		}
		return allitems;
	}
	
	int[] getItemGraph(string auth)
	{
		int[] graphcnt = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return graphcnt;
		
		auto rows = db.query("select count(*) as count, month(added_date) as month from items where year(added_date) = 2016 group by month(added_date)");
		
		foreach (row; rows)
		{
			int month = row["month"].to!int - 1;
			graphcnt[month] = row["count"].to!int;		
		}
		
		return graphcnt;		
	}
	
	int[] getUserGraph(string auth)
	{
		int[] graphcnt = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return graphcnt;
		
		int id = cookies[sess].user_id;
		
		auto rows = db.query("select count(*) as count, month(borrowed_date) as month from transactions where year(borrowed_date) = 2016 and user_id = ? group by month(borrowed_date)", id);
		
		foreach (row; rows)
		{
			int month = row["month"].to!int - 1;
			graphcnt[month] = row["count"].to!int;		
		}
		
		return graphcnt;		
	}
	
	int[] getAdminGraph(string username, string auth)
	{
		int[] graphcnt = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return graphcnt;
		
		auto rows = db.query("select count(*) as count, month(borrowed_date) as month from transactions where year(borrowed_date) = 2016 and user_id IN (SELECT user_id FROM users WHERE username = ?) group by month(borrowed_date)", username);
		
		foreach (row; rows)
		{
			int month = row["month"].to!int - 1;
			graphcnt[month] = row["count"].to!int;		
		}
		
		return graphcnt;		
	}
	
	string[] getTopThree(string auth)
	{
		string[] bookcnt = ["", "", ""];
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return bookcnt;
		
		auto rows = db.query("select count(*) as count, i.title as title from transactions t inner join items i on t.item_id = i.item_id group by t.item_id order by count desc, t.item_id asc");
		
		int cnt = 0;
		foreach (row; rows)
		{
			if (cnt < 3)
			{
				bookcnt[cnt] = row["title"]; //picture and title?
				cnt++;
			}
			else
				break;
		}
		
		return bookcnt;
	}
	
	string[] getTopThreeUser(string auth)
	{
		string[] bookcnt = ["", "", ""];
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return bookcnt;
			
		int id = cookies[sess].user_id;
		
		auto rows = db.query("select count(*) as count, i.title as title from transactions t inner join items i on t.item_id = i.item_id where user_id = ? group by t.item_id order by count desc, t.item_id asc", id);
		
		int cnt = 0;
		foreach (row; rows)
		{
			if (cnt < 3)
			{
				bookcnt[cnt] = row["title"]; //picture and title?
				cnt++;
			}
			else
				break;
		}
		
		return bookcnt;
	}
	
	string[] getTopThreeAdmin(string username, string auth)
	{
		string[] bookcnt = ["", "", ""];
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return bookcnt;
		
		auto rows = db.query("select count(*) as count, i.title as title from transactions t inner join items i on t.item_id = i.item_id where user_id IN (SELECT user_id FROM users WHERE username = ?) group by t.item_id order by count desc, t.item_id asc", username);
		
		int cnt = 0;
		foreach (row; rows)
		{
			if (cnt < 3)
			{
				bookcnt[cnt] = row["title"]; //picture and title?
				cnt++;
			}
			else
				break;
		}
		
		return bookcnt;
	}
	
	User getProfile(string auth)
	{
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return User();
		return cookies[sess];
	}
	
	User getProfileAdmin(string username, string auth)
	{
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return User();
			
		auto rows = db.query("select user_id, username, status, first_name, last_name, email, birth_date, added_date from users where username = ?", username);

		User user;
		user.user_id = rows.front()["user_id"].to!int;
		user.username = rows.front()["username"];
		user.status = rows.front()["status"].to!int;
		user.first_name = rows.front()["first_name"];
		user.last_name = rows.front()["last_name"];
		user.email = rows.front()["email"];
		user.birth_date = rows.front()["birth_date"];
		user.added_date = rows.front()["added_date"];
		
		return user;
	}
	
}
