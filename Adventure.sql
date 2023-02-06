SELECT * 
FROM Sales.Customer;
SELECT *
FROM Sales.SalesOrderDetail;
SELECT *
FROM Sales.SalesOrderHeader;
SELECT *
FROM Sales.SalesTerritory;
SELECT *
FROM production.Product;
SELECT *
FROM production.ProductSubcategory;
SELECT *
FROM production.ProductCategory;
SELECT *
FROM Sales.Store;

SELECT Customer.CustomerID AS CustomerId, Header.SalesOrderID AS SalesOrderId, Detail.LineTotal AS Sales_Price,
		Product.Name AS ProductName, Subcategory.Name AS SubcategoryName,
		Category.Name AS CategoryName, Store.Name as StoreName, Territory.CountryRegionCode AS CountryCode,
		Territory.[Group] AS Region, YEAR(Detail.ModifiedDate) AS Order_Year,
		MONTH(Detail.ModifiedDate) AS Order_Month
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


