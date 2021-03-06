module biblios.rest;
import biblios.db;
import vibe.d;

import std.random;
import std.algorithm : canFind;
import std.stdio;
import std.digest.sha;
import std.array : appender;
import std.format : formattedWrite;

enum authCookie = headerParam("auth", "Cookie");

@path("/api")
interface IAPI
{
	string postLogin(string username, string password);

	@authCookie
	bool postLogout(string auth = "");
	
	bool postRegister(string first, string last, string username, string email, string password);
	
	@authCookie
	MyItems[] getTransactionHistory(int order, int by, string auth = "");
	
	@authCookie
	MyItems[] getMyItems(int order, int by, string auth = "");
	
	@authCookie
	RequestedItems[] getRequestedItems(int order, int by, string auth = "");
	
	@authCookie
	bool postRequestedItem(string title, string author, string subject, string description, string auth = "");
	
	@authCookie
	RequestedItem getEditRequestedItem(int req, string auth = "");
	
	@authCookie
	bool postDeleteRequest(int req, string auth = "");
	
	@authCookie
	PendingUsers[] getPendingUsers(int order, int by, string auth = "");
	
	@authCookie
	AdminItems[] getAdminTransactionHistory(int order, int by, string auth = "");
	
	@authCookie
	int[] getItemGraph(string auth = "");
	
	@authCookie
	int[] getUserGraph(string auth = "");
	
	@authCookie
	int[] getAdminGraph(string username, string auth = "");
	
	@authCookie
	string[] getTopThree(int month, int year, string auth = "");
	
	@authCookie
	string[] getTopThreeUser(int month, int year, string auth = "");
	
	@authCookie
	string[] getTopThreeAdmin(int month, int year, string username, string auth = "");
	
	@authCookie
	User getProfile(string auth = "");
	
	@authCookie
	bool postEditProfile(string username, string first, string last, string email, byte[] picture, string date, string newpass, string auth = "");
	
	@authCookie
	User getProfileAdmin(string username, string auth = "");
	
	@authCookie
	Item[] getSearchItems(string search, int order = 0, int by = 0, string auth = "");
	
	@authCookie
	SearchUser[] getSearchUser(string search, string auth = "");
	
	@authCookie
	SearchItem[] getSearchItem(string search, string auth = "");
	
	@authCookie
	bool postAddItem(string title, string author, int isbn, string date, string subject, string description, string auth = "");
	
	@authCookie
	Item getEditItem(int itm, string auth = "");
	
	@authCookie
	bool postDeleteItem(int itm, string auth = "");
	
	@authCookie
	bool postEditItem(int itm, string title, string author, string published_date, int isbn, string subject, string description, string auth = "");
	
	@authCookie
	bool postBorrow(int user, int item, string auth = "");
	
	@authCookie
	Returns getReturn(string search, string auth = "");
	
	@authCookie
	SearchItem[] getReturnItem(string search, string auth);
	
	@authCookie
	bool postReturn(int user, int item, string auth = "");
	
	@authCookie
	bool postToAdmin(int usr, string auth);
	
	@authCookie
	bool postToUser(int usr, string auth = "");
	
	@authCookie
	bool postDeleteUser(int usr, string auth = "");
	
	@authCookie
	bool postDeletePendingUser(int usr, string auth);
	
	@authCookie
	string[] getSubjects(string auth);
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
	string picture;
}

struct Item
{
	int item_id;
	string title;
	string author;
	string published_date;
	int isbn;
	string subject;
	string description;
	int status;
	string picture;
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
	int request_id;
	string username;
	string title;
	string author;
	string requested_date;
	string subject;
	string description;
}

struct RequestedItem
{
	string title;
	string author;
	string subject;
	string description;
}

struct PendingUsers
{
	int user_id;
	string username;
	string name;
	string added_date;
	string email;
}

struct SearchUser
{
	int id;
	string username;
	string name;
	string picture;
}

struct SearchItem
{
	int id;
	string title;
	string isbn;
	string picture;
}

struct Returns
{
	SearchUser user;
	SearchItem item;
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
	
	private string hashFunction(string pass)
	{
		auto sha1 = new SHA1Digest();
		ubyte[] hash = sha1.digest(pass);
		auto writer = appender!string();
		formattedWrite(writer, "%(%x%)", hash);
		return writer.data;
	}
	
	private string orderBy(int order, int by)
	{
		string ord = " asc";
		if (order == 1) //descending
			ord = " desc";
		
		string ordby = "title";
		if (by == 1) //author
			ordby = "author";
		else if (by == 2) //borrowed date
			ordby = "borrowed_date";
		else if (by == 3) //returned date
			ordby = "returned_date";
		else if (by == 4) //requested date
			ordby = "requested_date";
		else if (by == 5) //username
			ordby = "username";
		else if (by == 6) //name
			ordby = "name";
		else if (by == 7) //added date
			ordby = "added_date";
		else if (by == 8) //published date
			ordby = "published_date";
		else if (by == 9) //status
			ordby = "status";
		
		string o = ordby ~ ord;
		return o;
	}
	
	private string getPictureName()
	{
		string str = "";
		for(int i = 0; i < 10; i++)
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
	
	//done
	string postLogin(string username, string password)
	{
		auto salt = db.query("SELECT salt FROM users WHERE username = ?", username);
		
		if (salt.length == 0)
			return "";
		
		string sp = salt.front()["salt"] ~ password;
		string pass = hashFunction(sp);
		
		auto rows = db.query("SELECT user_id, username, status, first_name, last_name, email, birth_date, added_date FROM users WHERE username = ? AND CAST(password AS CHAR(40)) LIKE CONCAT('%', ?, '%') AND status < 2", username, pass);
		
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

	//done
	bool postLogout(string auth)
	{
		string sess = parseCookie(auth, "sess");
		writeln(sess);
		cookies.remove(sess);
		return true;
	}
	
	//done
	bool postRegister(string first, string last, string username, string email, string password)
	{
		auto rows = db.query("SELECT username FROM users WHERE username LIKE ?", username);
		
		if (rows.length != 0) //username is taken
			return false;
		
		string salt = getSalt();
		string sp = salt ~ password;
		string pass = hashFunction(sp);
		
		db.query("INSERT INTO users (first_name, last_name, username, email, password, salt, status, added_date) VALUES (?, ?, ?, ?, ?, ?, 2, utc_date())", first, last, username, email, pass, salt);
		return true;
	}
	
	MyItems[] getTransactionHistory(int order, int by, string auth)
	{
		string ord = orderBy(order, by);
		
		MyItems[] allitems;
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return allitems;
			
		int id = cookies[sess].user_id;
		
		auto rows = db.query("SELECT t.borrowed_date, t.returned_date, i.title, i.author FROM transactions t INNER JOIN items i ON t.item_id = i.item_id WHERE t.user_id = ? AND NOT ISNULL(t.returned_date) ORDER BY " ~ ord, id);

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
	
	//done
	MyItems[] getMyItems(int order, int by, string auth)
	{
		string ord = orderBy(order, by);
		
		MyItems[] allitems;
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return allitems;
			
		int id = cookies[sess].user_id;
		
		auto rows = db.query("SELECT t.borrowed_date, ADDDATE(t.borrowed_date, INTERVAL 21 DAY) AS returned_date, i.title, i.author FROM transactions t INNER JOIN items i ON t.item_id = i.item_id WHERE t.user_id = ? AND ISNULL(t.returned_date) ORDER BY " ~ ord, id);

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
	
	//done
	RequestedItems[] getRequestedItems(int order, int by, string auth)
	{
		string ord = orderBy(order, by);
		
		RequestedItems[] allitems;
		
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return allitems;
		if (current.status != 1)
			return allitems;
		
		auto rows = db.query("SELECT r.request_id, r.title, r.author, r.requested_date, r.description, s.name, u.username FROM requests r INNER JOIN users u ON r.user_id = u.user_id INNER JOIN subjects s ON r.subject = s.subject_id ORDER BY " ~ ord);

		foreach (row; rows)
		{
			RequestedItems item;
			item.request_id = row["request_id"].to!int;
			item.username = row["username"];
			item.title = row["title"];
			item.author = row["author"];
			item.requested_date = row["requested_date"];
			item.subject = row["name"];
			item.description = row["description"];
			allitems ~= item;
		}
		return allitems;
	}
	
	bool postRequestedItem(string title, string author, string subject, string description, string auth)
	{
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return false;
			
		int id = cookies[sess].user_id;
		
		auto s = db.query("SELECT subject_id FROM subjects WHERE name = ?", subject);
		
		if (s.length == 0)
		{
			db.query("INSERT INTO subjects(name) VALUES ( ? )", subject);
			s = db.query("SELECT subject_id FROM subjects WHERE name = ?", subject);
		}
		
		db.query("INSERT INTO requests (user_id, title, author, requested_date, subject, description) VALUES (?, ?, ?, utc_date(), ?, ?)", id, title, author, s.front()["subject_id"], description);
		
		return true;
	}
	
	//done
	RequestedItem getEditRequestedItem(int req, string auth)
	{
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return RequestedItem();
		if (current.status != 1)
			return RequestedItem();
		
		auto rows = db.query("SELECT r.title, r.author, s.name, r.description FROM requests r INNER JOIN subjects s ON r.subject = s.subject_id WHERE request_id = ?", req);
		
		if (rows.length == 0)
			return RequestedItem();
		
		RequestedItem item;
		item.title = rows.front()["title"];
		item.author = rows.front()["author"];
		item.subject = rows.front()["name"];
		item.description = rows.front()["description"];
		
		return item;
	}
	
	//done
	bool postDeleteRequest(int req, string auth)
	{
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return false;
		
		db.query("DELETE FROM requests WHERE request_id = ?", req);
		return true;
	}
	
	//done
	PendingUsers[] getPendingUsers(int order, int by, string auth)
	{
		string ord = orderBy(order, by);
		
		PendingUsers[] allusers;
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return allusers;
		if (current.status != 1)
			return allusers;

		auto rows = db.query("SELECT user_id, username, CONCAT(first_name, ' ', last_name) AS name, email, added_date FROM users WHERE status = 2 ORDER BY " ~ ord);

		foreach (row; rows)
		{
			PendingUsers user;
			user.user_id = row["user_id"].to!int;
			user.username = row["username"];
			user.name = row["name"];
			user.email = row["email"];
			user.added_date = row["added_date"];
			allusers ~= user;
		}

		return allusers;
	}
	
	//done
	AdminItems[] getAdminTransactionHistory(int order, int by, string auth)
	{
		string ord = orderBy(order, by);
		
		AdminItems[] allitems;
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return allitems;
		if (current.status != 1)
			return allitems;
			
		if (cookies[sess].status != 1)
			return allitems;
		
		auto rows = db.query("SELECT t.borrowed_date, t.returned_date, i.title, i.author, u.username FROM transactions t INNER JOIN items i ON t.item_id = i.item_id INNER JOIN users u ON t.user_id = u.user_id AND NOT ISNULL(t.returned_date) ORDER BY " ~ ord);

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
	
	//done
	int[] getItemGraph(string auth)
	{
		int[] graphcnt = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return graphcnt;
		
		auto rows = db.query("SELECT COUNT(*) AS count, MONTH(added_date) AS month FROM items WHERE YEAR(added_date) = 2016 GROUP BY MONTH(added_date)");
		
		foreach (row; rows)
		{
			int month = row["month"].to!int - 1;
			graphcnt[month] = row["count"].to!int;		
		}
		
		return graphcnt;		
	}
	
	//done
	int[] getUserGraph(string auth)
	{
		int[] graphcnt = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return graphcnt;
		
		int id = cookies[sess].user_id;
		
		auto rows = db.query("SELECT COUNT(*) AS count, MONTH(borrowed_date) AS month FROM transactions WHERE YEAR(borrowed_date) = 2016 AND user_id = ? GROUP BY MONTH(borrowed_date)", id);
		
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
		User current = cookies.get(sess, User());
		if (current == User())
			return graphcnt;
		if (current.status != 1)
			return graphcnt;
		
		auto rows = db.query("SELECT COUNT(*) AS count, MONTH(borrowed_date) AS month FROM transactions WHERE YEAR(borrowed_date) = 2016 AND user_id IN (SELECT user_id FROM users WHERE username = ?) GROUP BY MONTH(borrowed_date)", username);
		
		foreach (row; rows)
		{
			int month = row["month"].to!int - 1;
			graphcnt[month] = row["count"].to!int;		
		}
		
		return graphcnt;		
	}
	
	string[] getTopThree(int month, int year, string auth)
	{
		string order = "";
		
		if (month > 0 && month < 13)
			order = "WHERE MONTH(borrowed_date) = " ~ month.to!string ~ " AND YEAR(borrowed_date) = " ~ year.to!string;
		
		string[] bookcnt = ["", "", ""];
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return bookcnt;
		
		auto rows = db.query("SELECT COUNT(*) AS count, i.title AS title FROM transactions t INNER JOIN items i ON t.item_id = i.item_id " ~ order ~ " GROUP BY t.item_id ORDER BY count desc, t.item_id asc");
		
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
	
	string[] getTopThreeUser(int month, int year, string auth)
	{
		string order = "";
		
		if (month > 0 && month < 13)
			order = "AND MONTH(borrowed_date) = " ~ month.to!string ~ " AND YEAR(borrowed_date) = " ~ year.to!string;
			
		string[] bookcnt = ["", "", ""];
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return bookcnt;
			
		int id = cookies[sess].user_id;
		
		auto rows = db.query("SELECT COUNT(*) AS count, i.title AS title FROM transactions t INNER JOIN items i ON t.item_id = i.item_id WHERE user_id = ? " ~ order ~ " GROUP BY t.item_id ORDER BY count desc, t.item_id asc", id);
		
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
	
	string[] getTopThreeAdmin(int month, int year, string username, string auth)
	{
		string order = "";
		
		if (month > 0 && month < 13)
			order = "AND MONTH(borrowed_date) = " ~ month.to!string ~ " AND YEAR(borrowed_date) = " ~ year.to!string;
			
		string[] bookcnt = ["", "", ""];
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return bookcnt;
		if (current.status != 1)
			return bookcnt;
		
		auto rows = db.query("SELECT COUNT(*) AS count, i.title AS title FROM transactions t INNER JOIN items i ON t.item_id = i.item_id WHERE user_id IN (SELECT user_id FROM users WHERE username = ?) " ~ order ~ " GROUP BY t.item_id ORDER BY count desc, t.item_id asc", username);
		
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
	
	//done
	User getProfile(string auth)
	{
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return User();
		return cookies[sess];
	}
	
	bool postEditProfile(string username, string first, string last, string email, byte[] picture, string date, string newpass, string auth)
	{
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return false;
		
		int id = cookies[sess].user_id;
		string picname = getPictureName();
		string pic = "user_" ~ id.to!string ~ picname;
		
		if (newpass.length != 0) //update password
		{
			string s = getSalt();
			string sp = s ~ newpass;
			string pass = hashFunction(sp);
			
			db.query("UPDATE users SET password = ?, salt = ? WHERE item_id = ?", pass, s, id);
		}
		
		if (date.length != 0)
			db.query("UPDATE users SET birth_date=? WHERE user_id = ?", date, id);
		if (picture.length != 0)
		{
			db.query("UPDATE users SET picture=? WHERE user_id = ?", pic, id);
			writeln(pic);
			auto newFile = File("files/" ~ pic ~ ".jpg", "wb");
			newFile.rawWrite(picture);
			newFile.close();
		}
		
		db.query("UPDATE users SET username=?, first_name=?, last_name=?, email=? WHERE user_id = ?", username, first, last, email, id);
		return true;
	}
	
	//done
	User getProfileAdmin(string username, string auth)
	{
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return User();
		if (current.status != 1)
			return User();
			
		auto rows = db.query("SELECT user_id, username, status, first_name, last_name, email, birth_date, added_date, picture FROM users WHERE username = ? AND status < 2", username);
		
		if (rows.length == 0)
			return User();
		
		User user;
		user.user_id = rows.front()["user_id"].to!int;
		user.username = rows.front()["username"];
		user.status = rows.front()["status"].to!int;
		user.first_name = rows.front()["first_name"];
		user.last_name = rows.front()["last_name"];
		user.email = rows.front()["email"];
		user.birth_date = rows.front()["birth_date"];
		user.added_date = rows.front()["added_date"];
		user.picture = rows.front()["picture"];
		
		return user;
	}
	
	//done admin, user
	Item[] getSearchItems(string search, int order, int by, string auth)
	{	
		string ord = orderBy(order, by);
		
		Item[] allitems;
		
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return allitems;
		
		auto rows = db.query("SELECT i.item_id, i.title, i.author, i.isbn, i.description, i.published_date, s.name, i.status, i.picture FROM items i INNER JOIN subjects s ON i.subject = s.subject_id WHERE i.title LIKE CONCAT('%', ?, '%') UNION SELECT i.item_id, i.title, i.author, i.isbn, i.description, i.published_date, s.name, i.status, i.picture FROM items i INNER JOIN subjects s ON i.subject = s.subject_id WHERE i.author LIKE CONCAT('%', ?, '%') UNION SELECT i.item_id, i.title, i.author, i.isbn, i.description, i.published_date, s.name, i.status, i.picture FROM items i INNER JOIN subjects s ON i.subject = s.subject_id WHERE i.description LIKE CONCAT('%', ?, '%') ORDER BY " ~ ord, search, search, search);
		
		foreach (row; rows)
		{
			Item item;
			item.item_id = row["item_id"].to!int;
			item.title = row["title"];
			item.author = row["author"];
			item.isbn = row["isbn"].to!int;
			item.published_date = row["published_date"];
			item.subject = row["name"];
			item.description = row["description"];
			item.status = row["status"].to!int;
			item.picture = row["picture"];
			allitems ~= item;
		}
		
		return allitems;
	}
	
	//done
	SearchUser[] getSearchUser(string search, string auth)
	{
		SearchUser[] allusers;
		
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return allusers;
		if (current.status != 1)
			return allusers;
			
		auto rows = db.query("SELECT user_id, username, picture, CONCAT(first_name, ' ', last_name) AS name FROM users WHERE username LIKE CONCAT(?, '%') AND status < 2 ORDER BY username", search);
		
		foreach (row; rows)
		{
			SearchUser user;
			user.id = row["user_id"].to!int;
			user.username = row["username"];
			user.name = row["name"];
			user.picture = row["picture"];
			allusers ~= user;
		}
		
		return allusers;	
	}
	
	//done
	SearchItem[] getSearchItem(string search, string auth)
	{

		SearchItem[] allitems;
		
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return allitems;
		if (current.status != 1)
			return allitems;
			
		auto rows = db.query("SELECT item_id, title, isbn, picture FROM items WHERE title LIKE CONCAT(?, '%') AND status = 0 ORDER BY title", search);
		
		foreach (row; rows)
		{
			SearchItem item;
			item.id = row["item_id"].to!int;
			item.title = row["title"];
			item.isbn = row["isbn"];
			item.picture = row["picture"];
			allitems ~= item;
		}
		
		return allitems;		
	}
	
	//done
	bool postAddItem(string title, string author, int isbn, string date, string subject, string description, string auth)
	{
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return false;
		if (current.status != 1)
			return false;
		
		auto s = db.query("SELECT subject_id FROM subjects WHERE name = ?", subject);
		
		if (s.length == 0)
		{
			db.query("INSERT INTO subjects(name) VALUES ( ? )", subject);
			s = db.query("SELECT subject_id FROM subjects WHERE name = ?", subject);
		}
		
		db.query("INSERT INTO items (title, author, isbn, published_date, added_date, subject, description, status) VALUES (?, ?, ?, ?, utc_date(), ?, ?, 0)", title, author, isbn, date, s.front()["subject_id"], description);
		
		return true;
	}
	
	//done
	Item getEditItem(int itm, string auth)
	{
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return Item();
		if (current.status != 1)
			return Item();
		
		auto rows = db.query("SELECT i.title, i.author, i.published_date, i.isbn, s.name, i.description, i.picture FROM items i INNER JOIN subjects s ON i.subject = s.subject_id WHERE item_id = ?", itm);
		
		if (rows.length == 0)
			return Item();
		
		Item item;
		item.item_id = itm;
		item.title = rows.front()["title"];
		item.author = rows.front()["author"];
		item.published_date = rows.front()["published_date"];
		item.isbn = rows.front()["isbn"].to!int;
		item.subject = rows.front()["name"];
		item.description = rows.front()["description"];
		item.picture = rows.front()["picture"];
		
		return item;
	}
	
	//done
	bool postEditItem(int itm, string title, string author, string published_date, int isbn, string subject, string description, string auth)
	{
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return false;
		if (current.status != 1)
			return false;
		
		auto s = db.query("SELECT subject_id FROM subjects WHERE name = ?", subject);
		
		if (s.length == 0)
		{
			db.query("INSERT INTO subjects(name) VALUES ( ? )", subject);
			s = db.query("SELECT subject_id FROM subjects WHERE name = ?", subject);
		}
		
		db.query("UPDATE items SET title=?, author=?, published_date=?, isbn=?, subject=?, description=? WHERE item_id = ?", title, author, published_date, isbn, s.front()["subject_id"], description, itm);
		
		return true;
	}
	
	//done
	bool postDeleteItem(int itm, string auth)
	{
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return false;
		if (current.status != 1)
			return false;
		
		db.query("DELETE FROM transactions WHERE item_id = ?", itm);
		db.query("DELETE FROM items WHERE item_id = ?", itm);
		return true;
	}
	
	//done
	bool postBorrow(int user, int item, string auth)
	{
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return false;
		if (current.status != 1)
			return false;
		
		db.query("UPDATE items SET status=1 WHERE item_id = ?", item);
		
		db.query("INSERT INTO transactions(user_id, item_id, borrowed_date) VALUES ( ?, ?, utc_date())", user, item);
		
		return true;
	}
	
	//done
	Returns getReturn(string search, string auth)
	{
		Returns ret;
		
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return ret;
		if (current.status != 1)
			return ret;
		
		auto rows = db.query("SELECT item_id, title, isbn, picture FROM items WHERE title LIKE CONCAT(?, '%') AND status = 1 ORDER BY title", search);
		
		if (rows.length == 0)
			return ret;
		
		SearchItem item;
		item.id = rows.front()["item_id"].to!int;
		item.title = rows.front()["title"];
		item.isbn = rows.front()["isbn"];
		item.picture = rows.front()["picture"];
		ret.item = item;
		
		auto r = db.query("SELECT u.user_id, u.username, u.picture, CONCAT(u.first_name, ' ', u.last_name) AS name FROM users u INNER JOIN transactions t ON u.user_id = t.user_id WHERE t.item_id = ? AND ISNULL(t.returned_date)", item.id);
		
		if (r.length == 0)
			return ret;
		
		SearchUser user;
		user.id = r.front()["user_id"].to!int;
		user.username = r.front()["username"];
		user.name = r.front()["name"];
		user.picture = r.front()["picture"];
		ret.user = user;
		
		return ret;
	}
	
	//done
	SearchItem[] getReturnItem(string search, string auth)
	{

		SearchItem[] allitems;
		
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return allitems;
		if (current.status != 1)
			return allitems;
			
		auto rows = db.query("SELECT item_id, title, isbn, picture FROM items WHERE title LIKE CONCAT(?, '%') AND status = 1 ORDER BY title", search);
		
		foreach (row; rows)
		{
			SearchItem item;
			item.id = row["item_id"].to!int;
			item.title = row["title"];
			item.isbn = row["isbn"];
			item.picture = row["picture"];
			allitems ~= item;
		}
		
		return allitems;		
	}
	
	//done
	bool postReturn(int user, int item, string auth)
	{
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return false;
		if (current.status != 1)
			return false;
		
		db.query("UPDATE items SET status=0 WHERE item_id = ?", item);
		
		db.query("UPDATE transactions SET returned_date = utc_date() WHERE user_id = ? AND item_id = ? AND ISNULL(returned_date)", user, item);
		
		return true;
	}
	
	bool postToAdmin(int usr, string auth)
	{
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return false;
		if (current.status != 1)
			return false;
			
		db.query("UPDATE users SET status=1 WHERE user_id = ?", usr);
		return true;
	}
	
	bool postToUser(int usr, string auth)
	{
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return false;
		if (current.status != 1)
			return false;
			
		db.query("UPDATE users SET status=0 WHERE user_id = ?", usr);
		return true;
	}
	
	bool postDeleteUser(int usr, string auth)
	{
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return false;
		if (current.status != 1)
			return false;
		
		db.query("UPDATE users SET status=3 WHERE user_id = ?", usr);
		return true;
	}
	
	bool postDeletePendingUser(int usr, string auth)
	{
		string sess = parseCookie(auth, "sess");
		User current = cookies.get(sess, User());
		if (current == User())
			return false;
		if (current.status != 1)
			return false;
		
		db.query("DELETE FROM users WHERE user_id = ?", usr);
		return true;
	}	
	
	//done
	string[] getSubjects(string auth)
	{
		string[] allsubjects;
		
		string sess = parseCookie(auth, "sess");
		if (cookies.get(sess, User()) == User())
			return allsubjects;
		
		auto rows = db.query("SELECT name FROM subjects");
		
		foreach (row; rows)
		{
			allsubjects ~= row["name"];
		}
		return allsubjects;
	}
}
