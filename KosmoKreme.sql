/* Howdy! We are in a space donut shop and it's your first day here. 
This SQL project aims to help the space donut shop offer a variety of options. 
It also offers products for customers with dietary restrictions, such as kryptonite-free, largsnarp-free, and zorp-free donuts.
This system makes it easier for intergalactic shop workers to keep track of their inventory and send warning messages if they are low on an ingredient. 
Please enjoy your stay!
*/

-- debug, so the code can delete the db once it starts
DROP DATABASE IF EXISTS KosmoKreme;

-- creating db
CREATE DATABASE IF NOT EXISTS KosmoKreme;

-- use the KosmoKreme database
USE KosmoKreme;

-- ingredients table
CREATE TABLE IF NOT EXISTS Ingredients (
    IngredientID INT PRIMARY KEY AUTO_INCREMENT,
    ItemName VARCHAR(50) UNIQUE,
    Quantity INT NOT NULL,
    Unit VARCHAR(20) NOT NULL
);

-- donuts table with foreign key
CREATE TABLE IF NOT EXISTS Donuts (
    DonutID INT PRIMARY KEY AUTO_INCREMENT,
    ItemName VARCHAR(50) NOT NULL,
    Price FLOAT DEFAULT 0,
    Calories INT,
    IngredientID INT UNIQUE,
    Allergens VARCHAR(100),
    FOREIGN KEY (IngredientID) REFERENCES Ingredients(IngredientID)
);

-- stock table
CREATE TABLE IF NOT EXISTS Stock (
    StockID INT PRIMARY KEY AUTO_INCREMENT,
    ItemName VARCHAR(50) NOT NULL,
    ItemCount INT NOT NULL,
    MinQuantity INT NOT NULL
);


-- creating alerts
CREATE TABLE IF NOT EXISTS Alerts (
    AlertID INT PRIMARY KEY AUTO_INCREMENT,
    IngredientName VARCHAR(50) NOT NULL,
    AlertTimestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- creating ingredients table and adding data
INSERT INTO Ingredients (ItemName, Quantity, Unit)
VALUES
    ('Chocolate base', 100, 'g'),
    ('Vanilla base', 100, 'g'),
    ('Vanilla creme', 30, 'ml'),
    ('Cinnamon sugar', 40, 'g'),
    ('Rock candy', 25, 'g'),
    ('Caramel drizzle', 20, 'ml'),
    ('Peanut butter crunch', 50, 'g'),
    ('Strawberry glaze', 50, 'ml'),
    ('Cosmic dust', 50, 'g'),
    ('Blueberry filling', 25, 'ml'),
    ('Chocolate brownie chunks', 30, 'g'),
    ('Fudge', 40, 'ml');

-- stock data population
INSERT INTO Stock (ItemName, ItemCount, MinQuantity)
VALUES
    ('Chocolate base', 5000, 100),
    ('Vanilla base', 2000, 100),
    ('Vanilla creme', 600, 50),
    ('Cinnamon sugar', 250, 50), 
    ('Rock candy', 400, 50),
    ('Caramel drizzle', 300, 50),
    ('Peanut butter crunch', 1000, 50),
    ('Strawberry glaze', 800, 50),
    ('Cosmic dust', 1200, 50),
    ('Blueberry filling', 500, 50),
    ('Chocolate brownie chunks', 600, 50),
    ('Fudge', 200, 50);

-- making the donut table
INSERT INTO Donuts (ItemName, Price, Calories, IngredientID, Allergens)
VALUES
    ('Centauri Circles', 20, 300, 1, 'Rock'),
    ('Cosmo Kreme', 35, 250, 2, 'Peanuts'),
    ('Astro Rings', 25, 200, 3, 'None'),
    ('Moonrocky Road', 30, 350, 4, 'Rock'),
    ('Comet Crunch', 25, 280, 7, 'Peanuts'),
    ('Stellar Strawbs', 35, 290, 9, 'Cdus'),
    ('Cosmo Klassic', 15, 220, 6, 'None'),
    ('Supernova Sprinkles', 25, 240, 5, 'Rock'),
    ('Galaxy Goo', 20, 320, 10, 'Cdus'),
    ('RBR-2 Donuts', 10, 380, 11, 'None');
    
/* STORY TIME!*/
---------------------------------------
-- An alien Zorp comes in the shop. They have Rock allergies, the cashier needs to recommend them non-Rock donuts.
SELECT * 
FROM Donuts d
WHERE d.Allergens != 'Rock'
ORDER BY d.Allergens;
-- Great! Zorp pays you 50 emeralds. 
---------------------------------------
-- Your boss comes in and tells you that stock is running low on Strawberry glaze. It's now depleted. 
SELECT * FROM Stock; -- You check the stock table first. 
UPDATE Stock s
SET s.ItemCount = 0
WHERE s.ItemName = 'Strawberry Glaze';
-- You have now completed your boss's order and updated the database. You get a raise. 
---------------------------------------
-- An old astronaut comes into your store. He says on Ea-rth they had something similar, he can't remember.
-- He says his favorite donut ended in 'Kreme'
SELECT * FROM Donuts d
ORDER BY d.ItemName; -- You now check the database
-- You find it a bit annoying to sift through every line. 
SELECT d.ItemName
FROM Donuts AS d
WHERE d.ItemName 
LIKE '%Kreme';
-- The gentleman is very happy and buys one Cosmo Kreme. He gives you a mysterious orb from Ea-rth.
---------------------------------------
-- Your boss runs in and asks you to find the maximum and minimum price of our donuts. 
SELECT MAX(Price) AS MaxDonutPrice, MIN(Price) AS MinDonutPrice
FROM Donuts;
-- She asks you to find the average price now for interstellar tax reasons. 

SELECT AVG(Price) AS AverageDonutPrice
FROM Donuts;

-- The health inspector drops by your workplace. They ask what amount of calories one would consume if they ate everything off the menu today. 
SELECT SUM(Calories) AS TotalCalories
FROM Donuts;

-- The boss and the inspector both argue on their way out. 
---------------------------------------

-- The boss comes back and tells you new donut recipes. She tells you to populate the table in order to prepare for the delivery. 
-- You populate the parent table first:
-- Add data to the Ingredients table
-- Insert new ingredients with the corresponding IDs
INSERT INTO Ingredients (IngredientID, ItemName, Quantity, Unit)
VALUES
    (25, 'Gnarp 25', 100, 'g'),
    (27, 'Space Jam 27', 100, 'g'),
    (39, 'Alien Sparkle 39', 100, 'g');

-- Now, you can insert the donuts
INSERT INTO Donuts (ItemName, Price, Calories, IngredientID, Allergens)
VALUES
    ('Gnarp Donut', 25, 220, 25, 'None'),
    ('Space Jam Delight', 30, 280, 27, 'None'),
    ('Alien Sparkle Donut', 20, 200, 39, 'None');

----------------------------------------
-- Your boss came back with good news. She got the Gnorp instead of Gnarp variety. Very similar but tastes different.
INSERT INTO Ingredients (IngredientID, ItemName, Quantity, Unit)
VALUES
    (26,'Gnorp Sprinkles', 100, 'g');
INSERT INTO Donuts (ItemName, Price, Calories, IngredientID, Allergens)
VALUES
    ('Gnorp Donut', 35, 220, 26, 'None'); 
    
-- Your boss told you she has allergies to Fudge. We will now never serve fudge. EVER. 

-- Query to delete a specific ingredient from the Ingredients table
DELETE FROM Ingredients
WHERE ItemName = 'Fudge';
    
------------------------------------
-- After a database specialist advises you, you turn to use some joins to unite the Stock, INgredient and Donuts tables.
-- This is you joining Donuts table's Ingredient ID with your Ingredients table's name-lookalike
SELECT
    D.ItemName AS DonutName,
    D.Price,
    D.Calories,
    Ingredients.ItemName AS IngredientName
FROM Donuts D
JOIN Ingredients ON D.IngredientID = Ingredients.IngredientID;
-- This is you joining to see which ingredients are used in which donuts.
SELECT
    I.ItemName AS IngredientName,
    D.ItemName AS DonutName
FROM Ingredients I
INNER JOIN Donuts D ON I.IngredientID = D.IngredientID;



---------------------------------------------

/*Stored procedure starts now*/

-- Automating checking the ingredient Stock by creating a procedure and making our lives amazingly easier
DELIMITER //

CREATE PROCEDURE CheckIngredientStock()
BEGIN
    -- alerting low stock items
    INSERT INTO Alerts (IngredientName)
    SELECT S.ItemName
    FROM Stock S
    WHERE S.ItemCount < S.MinQuantity;
END;
//

DELIMITER ;
CALL CheckIngredientStock();
SELECT * FROM Alerts;
/*Procedure ends here*/

---------------------------------------------
-- This is your last day on the job, your boss tells you to create a database for allergens.

CREATE TABLE Allergens (
    AllergenID INT PRIMARY KEY AUTO_INCREMENT,
    AllergenName VARCHAR(50) UNIQUE NOT NULL
);
-- populate it with Donuts's Allergens
INSERT INTO Allergens (AllergenName)
SELECT DISTINCT Allergens FROM Donuts;
-- and index her!
ALTER TABLE Allergens
ADD INDEX idx_AllergenName (AllergenName);
-- And check it. 
SELECT * FROM Allergens;
-- Your boss pays you 500 diamonds. You've done your job well!

------------------------------------------------------------------
