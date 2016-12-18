module biblios.rest;
import biblios.db;
import vibe.d;

import std.random;

@path("/api")
interface IAPI
{
	string postLogin(string username, string password);
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
	
	string postLogin(string username, string password)
	{
		auto rows = db.query("select user_id from users where username = ? and password = ?", username, password);
		if (rows.length == 0)
			return "";
		string cookie = getSalt();
		cookies[cookie] = rows.front()["user_id"].to!int;
		return cookie;
	}
}