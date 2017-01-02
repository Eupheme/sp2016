CREATE DATABASE biblios;

CREATE TABLE `biblios`.`items` ( `item_id` INT NOT NULL AUTO_INCREMENT, `title` VARCHAR(25) NOT NULL , `author` VARCHAR(25) NOT NULL , `isbn` INT NOT NULL , `published_date` DATE NOT NULL , `added_date` DATE NOT NULL , `subject` VARCHAR(25) NOT NULL , `description` TEXT NOT NULL , `status` INT NOT NULL , PRIMARY KEY (`item_id`)) ENGINE = InnoDB;

CREATE TABLE `biblios`.`users` ( `user_id` INT NOT NULL AUTO_INCREMENT, `first_name` VARCHAR(25) NOT NULL , `last_name` VARCHAR(25) NOT NULL , `username` VARCHAR(25) NOT NULL , `email` VARCHAR(25) NOT NULL , `password` VARCHAR(25) NOT NULL , `salt` VARCHAR(25) NOT NULL , `status` INT NOT NULL , `picture` BLOB NULL , `birth_date` DATE NULL , `added_date` DATE NOT NULL , PRIMARY KEY (`user_id`)) ENGINE = InnoDB;

CREATE TABLE `biblios`.`transactions` ( `user_id` INT NOT NULL , `item_id` INT NOT NULL , `borrowed_date` INT NOT NULL , `returned_date` DATE, FOREIGN KEY (user_id) REFERENCES users(user_id), FOREIGN KEY (item_id) REFERENCES items(item_id) ) ENGINE = InnoDB;
