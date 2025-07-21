use AdventureWorks2022

--1.1
Select E.BusinessEntityID , P.FirstName ,P.LastName , E.HireDate
From [HumanResources].[Employee] E ,[Person].[Person] P
Where E.HireDate > '2012-01-01' and E.BusinessEntityID = P.BusinessEntityID
Order By E.HireDate DESC

--1.2
Select ProductID ,Name,ListPrice,ProductNumber
from [Production].[Product]
where ListPrice between 100 and 500
Order By ListPrice 

--1.3
select C.CustomerID,P.FirstName,P.LastName,PA.City
from [Person].[Person] P ,[Person].[BusinessEntityAddress] BA ,[Sales].[Customer] C , [Person].[Address] PA
where P.BusinessEntityID = BA.BusinessEntityID and C.PersonID =P.BusinessEntityID  and Ba.AddressID =PA.AddressID and City in ('Seattle', 'Portland')

--1.4
select TOP 15 P.Name,P.ListPrice,P.ProductNumber,PC.Name 
from Production.Product P ,Production.ProductSubcategory PS,Production.ProductCategory PC
where P.ProductSubcategoryID = PS.ProductSubcategoryID and PS.ProductCategoryID = PC.ProductCategoryID and P.SellEndDate IS NULL AND P.ListPrice > 0
Order By P.ListPrice Desc


--2.1
Select ProductID,Name,Color,ListPrice
From Production.Product
Where Name Like '%Mountain%' And Color = 'Black'

--2.2
Select P.FirstName + ' ' + P.LastName AS [Full Name],E.BirthDate,DATEDIFF(YEAR, E.BirthDate, GETDATE()) AS Age
From HumanResources.Employee E ,Person.Person P 
Where E.BusinessEntityID = P.BusinessEntityID and E.BirthDate between '1970-01-01' and '1985-12-31'

--2.3
Select SalesOrderID,OrderDate,CustomerID,TotalDue
From Sales.SalesOrderHeader
Where YEAR(OrderDate) = 2013 And MONTH(OrderDate) Between 10 AND 12

--2.4
Select ProductID ,Name,Weight,Size,ProductNumber
from Production.Product
where Weight is Null and Size is Not Null


--3.1
Select PS.Name ,COUNT(ProductID) As [Number Of Products]
from Production.Product P , Production.ProductCategory PC , Production.ProductSubcategory PS
Where PC.ProductCategoryID = PS.ProductCategoryID and P.ProductSubcategoryID = PS.ProductSubcategoryID
Group By PS.Name
Order By COUNT(ProductID) Desc


--3.2
select PS.Name , AVG(ListPrice) 
from Production.Product P , Production.ProductSubcategory PS
Where P.ProductSubcategoryID = PS.ProductSubcategoryID
Group By PS.Name
HAving COUNT(ProductID) > 5

--3.3
Select Top 10 C.CustomerID , P.FirstName , COUNT(SH.SalesOrderID)
From Sales.Customer C , Sales.SalesOrderHeader SH , Person.Person P
Where C.PersonID = P.BusinessEntityID And SH.CustomerID = C.CustomerID
Group By C.CustomerID,P.FirstName
Order By COUNT(SH.SalesOrderID) Desc

--3.4
select DATENAME(MONTH,OrderDate) As Month,SUM(TotalDue) [Sales Total]
from Sales.SalesOrderHeader
Where YEAR(OrderDate) = 2013
Group By DATENAME(MONTH,OrderDate)

--4.1
Select ProductID , Name , SellStartDate , YEAR(SellStartDate) As StartDate
from Production.Product
Where YEAR(SellStartDate) IN(Select YEAR(SellStartDate)
						   From Production.Product
						   Where Name ='Mountain-100 Black, 42')
						   

--5.1
Create TABLE Sales.ProductReviews (
    ReviewID Int IDENTITY(1,1) Primary Key,
    ProductID Int NOT NULL UNIQUE,
    CustomerID Int NOT NULL  UNIQUE,
    Rating Int CHECK (Rating BETWEEN 0 AND 10),
    ReviewDate DATE DEFAULT GETDATE(),
    ReviewText NVARCHAR(MAx),
    VerifiedPurchase Smallint DEFAULT 0,
    HelpfulVotes Int DEFAULT 0 CHECK (HelpfulVotes >= 0),
    Constraint FK_Product Foreign Key (ProductID) References Production.Product(ProductID),
    Constraint FK_Customer Foreign Key(CustomerID) References Sales.Customer(CustomerID)
)
Go

--6.1
Alter Table Production.Product
Add LastModifiedDate Date Default GETDATE()

--6.2
Create NONCLUSTERED INDEX IX_Person_LastName
ON Person.Person (LastName)
INCLUDE (FirstName, MiddleName)

--6.3
Alter Table Production.Product
Add Constraint CK_ListPrice
CHECK (ListPrice > StandardCost) --Error





