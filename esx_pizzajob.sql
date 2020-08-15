INSERT INTO `jobs` (name, label) VALUES
    ('pizzaJob', 'Mama Johns')
;
INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
    ('pizzaJob', 0, 'deliveryDriver', 'Delivery Driver', 20, '{}', '{}')
;
INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_pizzaJob', 'Mama Johns', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_pizzaJob', 'Mama Johns', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_pizzaJob', 'Mama Johns', 1)
;
INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('pizza', 'Pizza', -1, 0, 1)
;