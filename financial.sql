-- Create tables
CREATE TABLE Securities (
    SecurityID INT PRIMARY KEY,
    Name VARCHAR(255),
    Type VARCHAR(255)
);

CREATE TABLE Portfolio (
    PortfolioID INT PRIMARY KEY,
    Name VARCHAR(255)
);

CREATE TABLE Holdings (
    HoldingID INT PRIMARY KEY,
    PortfolioID INT,
    SecurityID INT,
    Quantity DECIMAL(10,2),
    PurchaseDate DATE,
    PurchasePrice DECIMAL(10,2),
    FOREIGN KEY (PortfolioID) REFERENCES Portfolio(PortfolioID),
    FOREIGN KEY (SecurityID) REFERENCES Securities(SecurityID)
);

-- Calculate portfolio returns
SELECT
    Portfolio.PortfolioID,
    Portfolio.Name AS PortfolioName,
    SUM(Holdings.Quantity * Holdings.PurchasePrice) AS TotalInvestment,
    SUM(Holdings.Quantity * CurrentPrice) AS CurrentValue,
    (SUM(Holdings.Quantity * CurrentPrice) - SUM(Holdings.Quantity * Holdings.PurchasePrice)) / SUM(Holdings.Quantity * Holdings.PurchasePrice) AS ReturnPercentage
FROM
    Portfolio
JOIN
    Holdings ON Portfolio.PortfolioID = Holdings.PortfolioID
JOIN
    Securities ON Holdings.SecurityID = Securities.SecurityID
JOIN
    (
        -- Subquery to get current security prices
        SELECT
            SecurityID,
            CurrentPrice
        FROM
            SecurityPrices
        WHERE
            PriceDate = CURRENT_DATE() -- Assuming the current date for calculation
    ) AS Prices ON Holdings.SecurityID = Prices.SecurityID
GROUP BY
    Portfolio.PortfolioID,
    Portfolio.Name;

-- Calculate portfolio volatility
SELECT
    Portfolio.PortfolioID,
    Portfolio.Name AS PortfolioName,
    SQRT(SUM((Holdings.Quantity * Holdings.PurchasePrice - MeanValue) * (Holdings.Quantity * Holdings.PurchasePrice - MeanValue)) / COUNT(*)) AS Volatility
FROM
    Portfolio
JOIN
    Holdings ON Portfolio.PortfolioID = Holdings.PortfolioID
JOIN
    Securities ON Holdings.SecurityID = Securities.SecurityID
JOIN
    (
        -- Subquery to get mean portfolio value
        SELECT
            Holdings.PortfolioID,
            AVG(Holdings.Quantity * Holdings.PurchasePrice) AS MeanValue
        FROM
            Holdings
        GROUP BY
            Holdings.PortfolioID
    ) AS MeanValues ON Holdings.PortfolioID = MeanValues.PortfolioID
GROUP BY
    Portfolio.PortfolioID,
    Portfolio.Name;

-- Calculate Sharpe ratio
SELECT
    Portfolio.PortfolioID,
    Portfolio.Name AS PortfolioName,
    (SUM(Holdings.Quantity * Holdings.PurchasePrice) - SUM(Holdings.Quantity * CurrentPrice)) / SQRT(SUM((Holdings.Quantity * Holdings.PurchasePrice - MeanValue) * (Holdings.Quantity * Holdings.PurchasePrice - MeanValue)) / COUNT(*)) AS SharpeRatio
FROM
    Portfolio
JOIN
    Holdings ON Portfolio.PortfolioID = Holdings.PortfolioID
JOIN
    Securities ON Holdings.SecurityID = Securities.SecurityID
JOIN
    (
        -- Subquery to get current security prices
        SELECT
            SecurityID,
            CurrentPrice
        FROM
            SecurityPrices
        WHERE
            PriceDate = CURRENT_DATE() -- Assuming the current date for calculation
    ) AS Prices ON Holdings.SecurityID = Prices.SecurityID
JOIN
    (
        -- Subquery to get mean portfolio value
        SELECT
            Holdings.PortfolioID,
            AVG(Holdings.Quantity * Holdings.PurchasePrice) AS MeanValue
        FROM
            Holdings
        GROUP BY
            Holdings.PortfolioID
    ) AS MeanValues ON Holdings.PortfolioID = MeanValues.PortfolioID
GROUP BY
    Portfolio.PortfolioID,
    Portfolio.Name;

-- Example of a stored procedure to add a transaction (buy or sell)
CREATE PROCEDURE AddTransaction (
    IN p_PortfolioID INT,
    IN p_SecurityID INT,
    IN p_Quantity DECIMAL(10,2),
    IN p_PurchaseDate DATE,
    IN p_PurchasePrice DECIMAL(10,2),
    IN p_TransactionType VARCHAR(10)
)
BEGIN
    IF p_TransactionType = 'buy' THEN
        INSERT INTO Holdings (PortfolioID, SecurityID, Quantity, PurchaseDate, PurchasePrice)
        VALUES (p_PortfolioID, p_SecurityID, p_Quantity, p_PurchaseDate, p_PurchasePrice);
    ELSEIF p_TransactionType = 'sell' THEN
        UPDATE Holdings
        SET Quantity = Quantity - p_Quantity
        WHERE PortfolioID = p_PortfolioID AND SecurityID = p_SecurityID;
    END IF;
END;
