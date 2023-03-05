USE exercise;
/* Exercise 1 */
CREATE TABLE office_objects (
objects varchar(255),
price int
);
INSERT INTO office_objects(objects, price) VALUES ("stapler",500), ("chair",5000), ("printer",500);
SELECT * FROM office_objects;
DELETE FROM office_objects;
ALTER TABLE office_objects DROP COLUMN price;
DROP TABLE office_objects;


/* Exercise 2 */
USE exercise;
CREATE TABLE languages (
country varchar(255),
language varchar(255)
);
SELECT * FROM languages;
INSERT INTO languages(country,language) 
VALUES 
('Italy', 'Italian'),
('France', 'French'),
('Germany', 'German'),
('England', 'English'),
('Hungary', 'Hungarian'),
('USA', 'English'),
('Romania', 'Romanian'),
('Poland', 'Polish'),
('Belgium', 'Dutch'),
('Austria', 'German'),
('Spain', 'Spanish'),
('Greece', 'Greek');
SELECT * FROM languages;
SELECT DISTINCT country,language FROM languages;
SELECT language, COUNT(language) FROM languages GROUP BY language;
SELECT DISTINCT language
FROM languages
WHERE country LIKE '%a' OR country LIKE '%y'
GROUP BY language;
ALTER TABLE languages ADD COLUMN datetime_column DATETIME;
UPDATE languages
SET datetime_column = '2023-03-10 14:25:00'
WHERE country = 'Hungary';

UPDATE languages
SET datetime_column = '2023-05-21 08:15:30'
WHERE country = 'USA';

UPDATE languages
SET datetime_column = '2023-06-18 19:45:00'
WHERE country = 'Romania';

UPDATE languages
SET datetime_column = '2023-09-02 12:30:15'
WHERE country = 'Poland';

UPDATE languages
SET datetime_column = '2023-11-15 17:10:45'
WHERE country = 'Belgium';

SELECT country
FROM languages
WHERE datetime_column >= '2023-01-01 00:00:00' AND datetime_column < '2023-08-01 00:00:00'
ORDER BY datetime_column DESC;

/*Exercise 3*/
CREATE TABLE capitals (
ID int, 
capital_cities varchar (250)
);
SELECT * FROM capitals; 
-- adding capitals
INSERT INTO capitals (capital_cities) VALUES 
  ('Rome'),
  ('Paris'),
  ('Berlin'),
  ('London'),
  ('Budapest'),
  ('Washington, D.C.'),
  ('Bucharest'),
  ('Warsaw'),
  ('Brussels'),
  ('Vienna'),
  ('Madrid'),
  ('Athens');
/* Adding auto increment*/
-- debug commands
SELECT * FROM languages;
SELECT * FROM capitals;
-- dropping original column
ALTER TABLE capitals DROP COLUMN ID;
-- auto incremented so it matches the other table
ALTER TABLE capitals
ADD ID INT AUTO_INCREMENT PRIMARY KEY;
-- foreign key
ALTER TABLE languages
ADD FOREIGN KEY (capital_cities_id) REFERENCES capitals (ID);
