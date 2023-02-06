--Create a Temporary table to store all the sale information
SELECT Customer.CustomerID AS CustomerId, Header.SalesOrderID AS SalesOrderId, Detail.LineTotal AS Sales_Price,
		Product.Name AS ProductName,Detail.UnitPrice AS ProductPrice, Subcategory.Name AS SubcategoryName,
		Category.Name AS CategoryName, Store.Name as StoreName, Territory.CountryRegionCode AS CountryCode,
		Territory.[Group] AS Region, YEAR(Detail.ModifiedDate) AS Order_Year,
		MONTH(Detail.ModifiedDate) AS Order_Month
INTO New_Sales
FROM Sales.Customer AS Customer
	JOIN Sales.SalesOrderHeader AS Header
	ON Customer.CustomerID = Header.CustomerID
	JOIN Sales.SalesOrderDetail AS Detail
	ON Header.SalesOrderID = Detail.SalesOrderID
	JOIN Production.Product AS Product
	ON Detail.ProductID = Product.ProductID
	JOIN Production.ProductSubcategory AS Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID
	JOIN Production.ProductCategory AS Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID
	JOIN Sales.Store AS Store
	ON Customer.StoreID = Store.BusinessEntityID
	JOIN Sales.SalesTerritory AS Territory
	ON Customer.TerritoryID = Territory.TerritoryID;

--Find the products that sold the most and it's price
SELECT ProductName, COUNT(CustomerId) AS TotalOrders, AVG(ProductPrice) AS ProductPrice
FROM New_Sales
GROUP BY ProductName
ORDER BY TotalOrders DESC;

-- find the total orders and percentage of the categories that Sold the most
WITH TE(CategoryName, TotalOrders) AS(
SELECT CategoryName, CAST(COUNT(CustomerId) AS float) AS TotalOrders
FROM New_Sales
GROUP BY CategoryName
)
SELECT CategoryName, TotalOrders, CAST(TotalOrders * 100/ (SELECT SUM(TotalOrders) FROM TE ) AS decimal(5,2)) AS Percent_order
FROM TE
GROUP BY CategoryName, TotalOrders
ORDER BY Percent_order DESC;

--find the top selling Subcategories
SELECT SubcategoryName, COUNT(CustomerId) AS TotalOrders
FROM New_Sales
GROUP BY SubcategoryName
ORDER BY TotalOrders DESC;

--find the month that generates the highest revenue
SELECT Order_Month, SUM(Sales_Price) AS TotalRevenue
FROM New_Sales
GROUP BY Order_Month
ORDER BY TotalRevenue DESC;

--find the stores that sold the most
SELECT StoreName, CountryCode, Count(CustomerId) AS TotalOrders
FROM New_Sales
GROUP BY StoreName, CountryCode
ORDER BY TotalOrders DESC;

--Regions and Country that sells the most
