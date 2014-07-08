CREATE TABLE `answers` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
                        `session_id` integer REFERENCES `sessions`(`session_id`),
                        `question_option_id` integer REFERENCES `question_options`);

CREATE TABLE `categories` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
                            `category_name` varchar(255));

CREATE TABLE `input_types` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
                            `input_type_name` varchar(255));

CREATE TABLE `option_choices` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
                                `option_group_id` integer REFERENCES `option_groups`, `option_choice_name` varchar(255));

CREATE TABLE `option_groups` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
                                `option_group_name` varchar(255));

CREATE TABLE `question_options` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
                                `question_id` integer REFERENCES `questions`,
                                `option_choice_id` integer REFERENCES `option_choices`);

CREATE TABLE `questions` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
                            `input_type_id` integer REFERENCES `input_types`,
                            `category_id` integer REFERENCES `categories`,
                            `option_group_id` integer REFERENCES `option_groups`,
                            `question_name` varchar(255));

CREATE TABLE `sessions` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
                        `session_id` varchar(255));

INSERT INTO "categories" ("category_name") VALUES ("Health History");