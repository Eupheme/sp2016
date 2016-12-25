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

class APIImpl : IAPI
{
	private int[string] cookies;
	
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
		auto rows = db.query("select user_id from users where username = ? and password = ?", username, password);

		if (rows.length == 0)
			return "";

		string cookie = getSalt();
		cookies[cookie] = rows.front()["user_id"].to!int;

		return cookie;
	}

	void postLogout(string auth)
	{
		string sess = parseCookie(auth, "sess");
		writeln(sess);
		cookies.remove(sess);

		writeln("\nCookies:");
		foreach(string c, int i; cookies)
			writeln(c);
	}
}
