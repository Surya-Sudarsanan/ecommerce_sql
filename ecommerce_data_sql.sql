USE ecommercedb;

CREATE TABLE sales_data (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice FLOAT,
    CustomerID INT,
    Country VARCHAR(50)
);

BULK INSERT sales_data
FROM 'C:\Users\Arya\Desktop\ElevateLab\Task4\ecommerce_data.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

	SELECT * FROM sales_data;

SELECT * FROM sales_data
WHERE Country = 'France';

-- most expensive items
SELECT Description, UnitPrice FROM sales_data
ORDER BY UnitPrice DESC;

-- GROUP BY with aggregate: Total quantity sold by country
SELECT Country, SUM(Quantity) AS TotalQuantity
FROM sales_data
GROUP BY Country
ORDER BY TotalQuantity DESC;

-- JOIN
-- Creating a dummy product category table
CREATE TABLE product_categories (
    StockCode VARCHAR(20),
    Category VARCHAR(50)
);

-- Simulate JOIN: sales with product category
SELECT s.InvoiceNo, s.Description, p.Category
FROM sales_data s
LEFT JOIN product_categories p ON s.StockCode = p.StockCode;

--Customers who bought more than 100 items
SELECT DISTINCT CustomerID
FROM sales_data
WHERE CustomerID IN (
    SELECT CustomerID
    FROM sales_data
    GROUP BY CustomerID
    HAVING SUM(Quantity) > 100
);

--Average unit price per country
SELECT Country, AVG(UnitPrice) AS AvgPrice
FROM sales_data
GROUP BY Country;

-- Indexing for optimization
CREATE INDEX idx_customer ON sales_data(CustomerID);
CREATE INDEX idx_country ON sales_data(Country);