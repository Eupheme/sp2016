# Installation

## Prerequisites

You will need the following things properly installed on your computer.

* [nginx](https://www.nginx.com)
* [dmd](https://dlang.org/)
* [dub](https://code.dlang.org/)
* [mysql](https://www.mysql.com) (with libmysqlclient library for linking)

## Installation

* Edit `/etc/nginx/nginx.conf` to add a server (you can use the following template).
```
server {
	listen 80;

	location /api/ {
		# IP to the server with the backend
		proxy_pass http://localhost:8080
	}

	# Location to the frontend files
	root /var/www/;
	index index.html;
}
```
* Start mysql server and import `base.sql`.

## Running

* Start nginx with `nginx` or appropriate alternative.
* To build and run the backend use `dub` in the backend directory.
* Log in with default user `defaultadmin` using password `defaultpassword`
