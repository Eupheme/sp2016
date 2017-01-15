CREATE DATABASE biblios;
USE biblios;

CREATE TABLE `biblios`.`subjects` (`subject_id` INT NOT NULL AUTO_INCREMENT , `name` VARCHAR(25) NOT NULL, PRIMARY KEY (`subject_id`)) ENGINE = InnoDB;

CREATE TABLE `biblios`.`items` ( `item_id` INT NOT NULL AUTO_INCREMENT, `title` VARCHAR(25) NOT NULL , `author` VARCHAR(25) NOT NULL , `isbn` INT NOT NULL , `published_date` DATE NOT NULL , `added_date` DATE NOT NULL , `subject` INT NOT NULL , `description` TEXT NOT NULL , `status` INT NOT NULL, `picture` VARCHAR(25) NULL, PRIMARY KEY (`item_id`), FOREIGN KEY (subject) REFERENCES subjects(subject_id)) ENGINE = InnoDB;

CREATE TABLE `biblios`.`users` ( `user_id` INT NOT NULL AUTO_INCREMENT, `first_name` VARCHAR(25) NOT NULL , `last_name` VARCHAR(25) NOT NULL , `username` VARCHAR(25) UNIQUE NOT NULL , `email` VARCHAR(25) NOT NULL , `password` BINARY(40) NOT NULL , `salt` BINARY(32) NOT NULL , `status` INT NOT NULL , `picture` VARCHAR(25), `birth_date` DATE, `added_date` DATE NOT NULL , PRIMARY KEY (`user_id`)) ENGINE = InnoDB;

CREATE TABLE `biblios`.`transactions` ( `user_id` INT NOT NULL , `item_id` INT NOT NULL , `borrowed_date` DATE NOT NULL , `returned_date` DATE DEFAULT NULL, FOREIGN KEY (user_id) REFERENCES users(user_id), FOREIGN KEY (item_id) REFERENCES items(item_id) ) ENGINE = InnoDB;

CREATE TABLE `biblios`.`requests` (`request_id` INT NOT NULL AUTO_INCREMENT, `user_id` INT NOT NULL, `title` VARCHAR(25) NOT NULL , `author` VARCHAR(25) NOT NULL , `requested_date` DATE NOT NULL , `subject` INT NOT NULL , `description` TEXT NOT NULL , PRIMARY KEY (`request_id`), FOREIGN KEY (user_id) REFERENCES users(user_id), FOREIGN KEY (subject) REFERENCES subjects(subject_id)) ENGINE = InnoDB;

INSERT INTO users(first_name, last_name, username, email, password, salt, status, picture, birth_date, added_date) VALUES ("defaultadmin", "defaultadmin", "defaultadmin", "default@admin.com", "89faac46e4b86e9b1201d1d3b8e6723aa78067", "qrjzvu5VXLWsBMULep5KhXylW6Hf2UVl", 1, "", NULL, "2017-01-15");
