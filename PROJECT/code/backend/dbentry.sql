USE biblios;

INSERT INTO subjects(name) VALUES ("subject1");

INSERT INTO subjects(name) VALUES ("subject2");



INSERT INTO items (title, author, isbn, published_date, added_date, subject,
description, status, picture) VALUES ("title1", "author4", 123451, "2016-12-01", "2016-11-12",
1, "blablablauth", 1, "item_1.jpg");

INSERT INTO items (title, author, isbn, published_date, added_date, subject,
description, status, picture) VALUES ("title2", "author3", 123452, "2016-12-02", "2016-12-12",
2, "blablablatit", 1, "item_2.jpg");

INSERT INTO items (title, author, isbn, published_date, added_date, subject,
description, status, picture) VALUES ("title3", "author2", 123453, "2016-12-03", "2016-01-12",
1, "blablablatit", 0, "item_3.jpg");

INSERT INTO items (title, author, isbn, published_date, added_date, subject,
description, status, picture) VALUES ("title4", "author1", 123454, "2016-12-04", "2016-12-12",
1, "blablablaauth", 0, "item_4.jpg");



INSERT INTO users (first_name, last_name, username, email, password, salt, status,
added_date, picture) VALUES ("firstname", "lastname", "User5", "guest@email.com", "5c5afc2440e18789664d73cb53fbe36d71bd42", "p7IPzX8gPxbNjKkz2cmC1FHiCKtQTpgE", 1, "2016-12-13", "user_1.jpg");



INSERT INTO transactions (user_id, item_id, borrowed_date, returned_date) VALUES
(1, 1, "2016-12-22", "2016-12-25");

INSERT INTO transactions (user_id, item_id, borrowed_date, returned_date) VALUES
(1, 1, "2016-12-26", "2016-12-27");

INSERT INTO transactions (user_id, item_id, borrowed_date, returned_date) VALUES
(1, 1, "2016-11-29", NULL);

INSERT INTO transactions (user_id, item_id, borrowed_date, returned_date) VALUES
(1, 3, "2016-12-22", "2016-12-26");

INSERT INTO transactions (user_id, item_id, borrowed_date, returned_date) VALUES
(1, 3, "2016-12-28", "2016-12-29");

INSERT INTO transactions (user_id, item_id, borrowed_date, returned_date) VALUES
(1, 2, "2016-12-31", NULL);



INSERT INTO requests (user_id, title, author, requested_date, subject, description) VALUES (1, "title r1", "author r1", "2015-12-09", 1, "blablabla");

INSERT INTO requests (user_id, title, author, requested_date, subject, description) VALUES (1, "title r2", "author r2", "2016-03-01", 1, "blablablaaaa");


