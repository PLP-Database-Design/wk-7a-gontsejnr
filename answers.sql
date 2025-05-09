-- Question 1
WITH RECURSIVE split_products AS (
  SELECT 
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(Products, ',', 1)) AS Product,
    SUBSTRING(Products, LENGTH(SUBSTRING_INDEX(Products, ',', 1)) + 2) AS Remaining
  FROM ProductDetail

  UNION ALL

  SELECT
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(Remaining, ',', 1)),
    SUBSTRING(Remaining, LENGTH(SUBSTRING_INDEX(Remaining, ',', 1)) + 2)
  FROM split_products
  WHERE Remaining IS NOT NULL AND Remaining != ''
)

SELECT OrderID, CustomerName, Product
FROM split_products;

-- Question 2
CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerName VARCHAR(100)
);
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

CREATE TABLE OrderItems (
  OrderID INT,
  Product VARCHAR(100),
  Quantity INT,
  PRIMARY KEY (OrderID, Product),
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
