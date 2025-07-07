create Database Co

use Co

-- Task 1
Create Table Department(
	DNum int Primary Key Identity(10 , 10),
	DName Varchar(50) Not Null ,
	Location Varchar(255) Default 'Cairo'
) 

Create Table Employee(
	SSN int Primary Key,
	FName Varchar(50) Not Null,
	LName Varchar(50) Not Null,
	Gender Char(1) check(Gender ='M' OR  Gender ='F' ),
	Birthdate Date,
	DNum int Foreign Key References Department(DNum),
	Super int Null
)

Create Table Project(
	PNum int Primary Key,
	PName Varchar(255) Not Null,
	City Varchar(50) Not Null,
	DNum int Foreign Key References Department(DNum)
) 


Create Table Dependent(
	Name Varchar(50),
	SSN int Foreign Key References Employee(SSN),
	Gender Char(1) check(Gender ='M' OR  Gender ='F' ),
	Birthdate Date,
	Primary Key(Name , SSN)
) 


Create Table Manager_HiringDate(
	DNum int Foreign Key References Department(DNum),
	SSN int Foreign Key References Employee(SSN),
	Primary Key(SSN , DNum) 
)
Alter Table Manager_HiringDate
Add Hiring_Date Date Default GetDate()


Create Table Works_On(
	PNum int Foreign Key References Project(PNum),
	SSN int Foreign Key References Employee(SSN),
	[Working Hours] int Not Null,
	Primary Key(SSN , PNum) 
)

Alter Table Employee
Add Salary int Check(Salary > 15000)


INSERT INTO Department (DName) VALUES 
('IT'), 
('HR'), 
('Finance'), 
('Marketing'), 
('Logistics');


INSERT INTO Employee (SSN, FName, LName, Gender, Birthdate, DNum, Super) VALUES
(1001, 'Ali', 'Essam', 'M', '2005-01-01', 10, NULL),
(1002, 'Sara', 'Ahmed', 'F', '2002-03-05', 20, 1001),
(1003, 'Omar', 'Youssef', 'M', '2001-07-12', 10, 1001),
(1004, 'Mona', 'Khaled', 'F', '2000-11-30', 30, 1002),
(1005, 'Yassin', 'Tariq', 'M', '1999-09-15', 40, NULL);

INSERT INTO Project (PNum, PName, City, DNum) VALUES
(1, 'AI Assistant', 'Cairo', 10),
(2, 'Payroll System', 'Alexandria', 20),
(3, 'E-Commerce Site', 'Cairo', 10),
(4, 'HR Portal', 'Giza', 30),
(5, 'Logistics Tracker', 'Tanta', 40);

INSERT INTO Dependent (Name, SSN, Gender, Birthdate) VALUES
('Noor', 1001, 'F', '2010-04-05'),
('Tamer', 1002, 'M', '2012-06-20'),
('Hala', 1003, 'F', '2011-09-10'),
('Mazen', 1004, 'M', '2009-12-01'),
('Dina', 1005, 'F', '2013-07-15');

INSERT INTO Manager_HiringDate (DNum, SSN) VALUES
(10, 1001),
(20, 1002),
(30, 1004),
(40, 1005),
(50, 1003);  

INSERT INTO Works_On (PNum, SSN, [Working Hours]) VALUES
(1, 1001, 40),
(2, 1002, 35),
(3, 1003, 30),
(4, 1004, 20),
(5, 1005, 25)


--Task2--
use StoreDB


--1
select *
from [production].[products]
where list_price > 1000

--2
select *
from [sales].[customers]
where state in('CA' ,'NY')

--3
select *
from [sales].[orders]
where YEAR(order_date) = 2023

--4
select *
from [sales].[customers]
where email Like '%@gmail.com'

--5
select *
from [sales].[staffs]
where active != 1

--6
select Top 5 *
from [production].[products]
Order By list_price Desc

--7
select Top 10 *
from [sales].[orders]
Order By order_date Desc

--8
select Top 3 *
from [sales].[customers]
Order By last_name

--9
select *
from [sales].[customers]
where phone is Null

--10
select *
from [sales].[staffs]
where manager_id is Not Null

--11
select category_id ,COUNT(*) as Number_Of_Products
from [production].[products]
Group By category_id
Order By category_id

--12
select state , COUNT(*) As Number_Of_Customers
from [sales].[customers]
Group By state

--13
select brand_id ,(SUM(list_price)/COUNT(list_price)) As [average list price]
from [production].[products]
Group By brand_id
Order By brand_id

--14
select staff_id , COUNT(*) As Number_Of_Orders
from [sales].[orders]
Group By staff_id
Order By staff_id

--15
select  distinct O.customer_id
from [sales].[orders] O , [sales].[order_items] OI
where O.order_id = OI.order_id and OI.quantity > 2
Order By o.customer_id

--16
select *
from [production].[products]
where list_price Between 500 and 1500 

--17
select *
from [sales].[customers]
where city like 'S%'

--18
select *
from [sales].[orders]
where order_status in (2, 4)

--19
select *
from [production].[products]
where category_id in (1,2,3)

--20
select *
from [sales].[staffs]
where store_id = 1 OR phone is Null