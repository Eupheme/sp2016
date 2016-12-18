import vibe.d;
import std.stdio;
import biblios.db;
import biblios.rest;

shared static this()
{
	auto router = new URLRouter;
	router.registerRestInterface(new APIImpl);
	
	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "127.0.0.1"];
	listenHTTP(settings, router);
	connectDB();
	
	foreach (r; router.getAllRoutes())
		writeln(r);
}

